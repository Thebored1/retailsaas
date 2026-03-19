import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import '../locator.dart';
import '../data/database/app_database.dart';
import './settings_service.dart';

class SyncService {
  final AppDatabase _db = getIt<AppDatabase>();
  final SettingsService _settings = getIt<SettingsService>();

  Future<String> _getBaseUrl() async {
    final url = await _settings.serverUrl;
    return url.isNotEmpty ? url : 'http://127.0.0.1:8000/api/v1';
  }

  Future<Map<String, String>> _getHeaders() async => {
    'Content-Type': 'application/json',
    'X-Api-Key': await _settings.apiKey,
  };

  Future<bool> checkOnline() async {
    try {
      final baseUrl = await _getBaseUrl();
      final apiKey = await _settings.apiKey;
      if (baseUrl.isEmpty || apiKey.isEmpty) return false;

      final response = await http.get(
        Uri.parse('$baseUrl/sync/config'),
        headers: await _getHeaders(),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Pushes all Products from Drift to the Webfront
  Future<void> pushProducts() async {
    try {
      final products = await _db.select(_db.products).get();
      final baseUrl = await _getBaseUrl();
      final headers = await _getHeaders();

      final payload = {
        "mode": "full",
        "products": products.map((p) => {
          "external_id": p.id,
          "name": p.name,
          "sku": "",
          "price_estimate": p.mrp.toString(),
          "hsn_code": p.hsnCode,
          "gst_rate": p.gstRate.toString(),
          "is_active": p.isActive,
        }).toList()
      };

      final response = await http.post(
        Uri.parse('$baseUrl/sync/products'),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to push products: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Sync Error (Products): $e');
      rethrow;
    }
  }

  /// Pushes all Customers from Drift to the Webfront
  Future<void> pushCustomers() async {
    try {
      final customers = await _db.select(_db.customers).get();
      final baseUrl = await _getBaseUrl();
      final headers = await _getHeaders();

      final payload = {
        "mode": "full",
        "customers": customers
            .map((c) => {
                  "phone": c.phone,
                  "name": c.name,
                  "email": c.email ?? "",
                  "address": c.address,
                })
            .toList()
      };

      final response = await http.post(
        Uri.parse('$baseUrl/sync/customers'),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to push customers: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Sync Error (Customers): $e');
      rethrow;
    }
  }

  /// Pushes all Product Batches (Inventory) to the Webfront
  Future<void> pushInventory() async {
    try {
      final batches = await _db.select(_db.productBatches).get();
      final baseUrl = await _getBaseUrl();
      final headers = await _getHeaders();

      final Map<String, double> inventoryMap = {};
      for (var batch in batches) {
        inventoryMap[batch.productId] = (inventoryMap[batch.productId] ?? 0) + batch.stockQty;
      }

      final payload = {
        "mode": "full",
        "inventory": inventoryMap.entries.map((e) => {
          "product_external_id": e.key,
          "qty_available": e.value.toString(),
        }).toList()
      };

      final response = await http.post(
        Uri.parse('$baseUrl/sync/inventory'),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to push inventory: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Sync Error (Inventory): $e');
      rethrow;
    }
  }

  /// Pushes all Product Batches (Batch pricing) to the Webfront
  Future<void> pushBatches() async {
    try {
      final batches = await _db.select(_db.productBatches).get();
      final baseUrl = await _getBaseUrl();
      final headers = await _getHeaders();

      final payload = {
        "mode": "full",
        "batches": batches.map((b) => {
          "id": b.id,
          "product_external_id": b.productId,
          "batch_number": b.batchNumber ?? "",
          "expiry_date": b.expiryDate?.toIso8601String().split('T').first,
          "selling_price": b.sellingPrice.toString(),
          "qty_available": b.stockQty.toString(),
          "created_at": b.createdAt.toIso8601String(),
          "updated_at": b.updatedAt?.toIso8601String(),
        }).toList()
      };

      final response = await http.post(
        Uri.parse('$baseUrl/sync/batches'),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to push batches: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Sync Error (Batches): $e');
      rethrow;
    }
  }

  /// Pushes all SalesBills to the Webfront
  Future<void> pushSalesTransactions() async {
    try {
      final sales = await _db.select(_db.salesBills).get();
      final baseUrl = await _getBaseUrl();
      final headers = await _getHeaders();
      final payloadList = [];

      for (var sale in sales) {
        final items = await (_db.select(_db.billItems)..where((t) => t.billId.equals(sale.id))).get();
        final itemsJson = items.map((i) => {
          "productId": i.productId,
          "productName": i.productName,
          "quantity": i.quantity,
          "rate": i.unitPrice,
          "taxPercent": 0,
          "taxAmount": i.taxAmount,
          "totalAmount": i.totalAmount,
        }).toList();

        String? customerPhone;
        if (sale.customerId != null) {
          final customerResult = await (_db.select(_db.customers)..where((t) => t.id.equals(sale.customerId!))).get();
          if (customerResult.isNotEmpty) {
            customerPhone = customerResult.first.phone.toString();
          }
        }

        payloadList.add({
          "desktop_id": sale.id,
          "customer_phone": customerPhone,
          "date": sale.date.toIso8601String(),
          "grand_total": sale.grandTotal.toString(),
          "payment_status": sale.paymentStatus,
          "items_json": itemsJson,
        });
      }

      final payload = {"mode": "full", "sales": payloadList};

      final response = await http.post(
        Uri.parse('$baseUrl/sync/sales'),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to push sales: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Sync Error (Sales): $e');
      rethrow;
    }
  }

  /// DANGER: Wipes webfront tables and replaces with desktop data.
  Future<void> nuclearResetWebfront() async {
    try {
      final products = await _db.select(_db.products).get();
      final batches = await _db.select(_db.productBatches).get();
      final baseUrl = await _getBaseUrl();
      final headers = await _getHeaders();

      final inventoryMap = <String, double>{};
      for (final batch in batches) {
        inventoryMap[batch.productId] =
            (inventoryMap[batch.productId] ?? 0) + batch.stockQty;
      }

      final productExternalMap = {
        for (final p in products) p.id: p.id,
      };

      final payload = {
        "products": products
            .map((p) => {
                  "external_id": p.id,
                  "name": p.name,
                  "sku": "",
                  "price_estimate": p.mrp.toString(),
                  "hsn_code": p.hsnCode,
                  "gst_rate": p.gstRate.toString(),
                  "is_active": p.isActive,
                  "updated_at": p.updatedAt.toIso8601String(),
                })
            .toList(),
        "inventory": inventoryMap.entries
            .map((e) => {
                  "product_external_id": productExternalMap[e.key] ?? e.key,
                  "qty_available": e.value.toString(),
                })
            .toList(),
      };

      final response = await http.post(
        Uri.parse('$baseUrl/sync/reset'),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Reset failed: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Sync Error (Reset Webfront): $e');
      rethrow;
    }
  }

  /// Pulls Sales from Webfront and records them locally (Option A)
  Future<void> pullSalesTransactions() async {
    try {
      final baseUrl = await _getBaseUrl();
      final headers = await _getHeaders();

      final response = await http.get(
        Uri.parse('$baseUrl/sync/sales'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch sales: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      final sales = List<Map<String, dynamic>>.from(data['sales'] ?? []);

      for (final sale in sales) {
        final desktopId = (sale['desktop_id'] ?? '').toString();
        if (desktopId.isEmpty) continue;

        final exists = await (_db.select(_db.salesBills)
              ..where((t) => t.id.equals(desktopId)))
            .getSingleOrNull();
        if (exists != null) continue;

        await _db.transaction(() async {
          final customerId = await _resolveCustomerId(
            sale['customer_phone'],
            sale['customer_name'],
          );

          final date = _parseDate(sale['date']) ?? DateTime.now();
          final grandTotal = _parseDouble(sale['grand_total']) ?? 0.0;
          final paymentStatus = (sale['payment_status'] ?? 'PAID').toString();

          await _db.into(_db.salesBills).insert(
                SalesBillsCompanion(
                  id: drift.Value(desktopId),
                  date: drift.Value(date),
                  customerName: drift.Value(
                    (sale['customer_name'] ?? '').toString(),
                  ),
                  customerId: drift.Value(customerId),
                  grandTotal: drift.Value(grandTotal),
                  paymentStatus: drift.Value(paymentStatus),
                  userId: const drift.Value(null),
                ),
              );

          final itemsRaw = sale['items_json'];
          final items = _normalizeItems(itemsRaw);
          for (final item in items) {
            await _insertBillItemAndAdjustStock(
              billId: desktopId,
              item: item,
              saleDate: date,
            );
          }
        });
      }
    } catch (e) {
      debugPrint('Sync Error (Pull Sales): $e');
      rethrow;
    }
  }

  /// Pulls all Pending Online Orders from the Webfront
  Future<List<Map<String, dynamic>>> pullPendingOrders() async {
    try {
      final baseUrl = await _getBaseUrl();
      final headers = await _getHeaders();

      final response = await http.get(
        Uri.parse('$baseUrl/orders/pending'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['orders'] ?? []);
      } else {
        throw Exception('Failed to fetch pending orders: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Sync Error (Pull Orders): $e');
      rethrow;
    }
  }

  /// Pulls all Customers from the Webfront and upserts into Drift
  Future<void> pullCustomers() async {
    try {
      final baseUrl = await _getBaseUrl();
      final headers = await _getHeaders();

      final response = await http.get(
        Uri.parse('$baseUrl/sync/customers'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch customers: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      final customers = List<Map<String, dynamic>>.from(data['customers'] ?? []);
      for (final c in customers) {
        final phone = _parseInt(c['phone']);
        if (phone == null) continue;
        final name = (c['name'] ?? '').toString();
        final email = (c['email'] ?? '').toString();
        final address = (c['address'] ?? '').toString();
        final createdAt = _parseDate(c['created_at']) ?? DateTime.now();
        final updatedAt = _parseDate(c['updated_at']) ?? DateTime.now();

        final existing = await (_db.select(_db.customers)
              ..where((t) => t.phone.equals(phone)))
            .getSingleOrNull();

        if (existing != null) {
          await (_db.update(_db.customers)
                ..where((t) => t.id.equals(existing.id)))
              .write(
            CustomersCompanion(
              name: drift.Value(name),
              email: drift.Value(email.isEmpty ? null : email),
              address: drift.Value(address),
              updatedAt: drift.Value(updatedAt),
            ),
          );
        } else {
          await _db.into(_db.customers).insert(
                CustomersCompanion(
                  id: drift.Value(const Uuid().v4()),
                  phone: drift.Value(phone),
                  name: drift.Value(name),
                  email: drift.Value(email.isEmpty ? null : email),
                  address: drift.Value(address),
                  createdAt: drift.Value(createdAt),
                  updatedAt: drift.Value(updatedAt),
                ),
              );
        }
      }
    } catch (e) {
      debugPrint('Sync Error (Pull Customers): $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchOrders({
    List<String>? statuses,
  }) async {
    try {
      final baseUrl = await _getBaseUrl();
      final headers = await _getHeaders();
      final statusParam =
          statuses == null || statuses.isEmpty ? null : statuses.join(',');
      final uri = Uri.parse('$baseUrl/orders/list').replace(
        queryParameters:
            statusParam == null ? null : {'status': statusParam},
      );

      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['orders'] ?? []);
      } else {
        throw Exception('Failed to fetch orders: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Sync Error (Fetch Orders): $e');
      rethrow;
    }
  }

  Future<void> createSaleFromWebOrder(Map<String, dynamic> order) async {
    final rawId = order['order_id'];
    if (rawId == null) return;
    final orderId = rawId is int ? rawId.toString() : rawId.toString();
    final billId = 'WEB-$orderId';

    final exists = await (_db.select(_db.salesBills)
          ..where((t) => t.id.equals(billId)))
        .getSingleOrNull();
    if (exists != null) return;

    final customer = (order['customer'] is Map) ? order['customer'] as Map : {};
    final customerName = (customer['name'] ?? order['customer_name'] ?? '').toString();
    final customerPhone = customer['phone'] ?? order['customer_phone'];

    final total = _parseDouble(order['final_total']) ??
        _parseDouble(order['estimated_total']) ??
        0.0;

    await _db.transaction(() async {
      final customerId = await _resolveCustomerId(customerPhone, customerName);

      await _db.into(_db.salesBills).insert(
            SalesBillsCompanion(
              id: drift.Value(billId),
              date: drift.Value(DateTime.now()),
              customerName: drift.Value(customerName),
              customerId: drift.Value(customerId),
              grandTotal: drift.Value(total),
              paymentStatus: const drift.Value('UNPAID'),
              userId: const drift.Value(null),
            ),
          );

      final items = order['items'] is List ? order['items'] as List : [];
      for (final item in items) {
        if (item is! Map) continue;
        final qty = _parseDouble(item['qty'] ?? item['quantity']) ?? 0.0;
        if (qty <= 0) continue;

        final unitPrice = _parseDouble(
              item['unit_price'] ?? item['rate'] ?? item['estimated_unit_price'],
            ) ??
            0.0;
        final totalAmount = _parseDouble(
              item['line_total'] ?? item['totalAmount'] ?? item['estimated_line_total'],
            ) ??
            (qty * unitPrice);

        final mapped = {
          "product_external_id": item['product_external_id'] ?? item['productExternalId'],
          "product_name": item['product_name'] ?? item['productName'] ?? item['name'],
          "qty": qty,
          "rate": unitPrice,
          "totalAmount": totalAmount,
        };

        await _insertBillItemAndAdjustStock(
          billId: billId,
          item: mapped,
          saleDate: DateTime.now(),
        );
      }

      await _db.recordLedgerEntry(
        GeneralLedgerCompanion(
          id: drift.Value(const Uuid().v4()),
          date: drift.Value(DateTime.now()),
          type: const drift.Value('SALE'),
          description: drift.Value('Webfront Sale - Order #$orderId'),
          debit: const drift.Value(0.0),
          credit: drift.Value(total),
          referenceId: drift.Value(billId),
          referenceTable: const drift.Value('sales_bills'),
        ),
      );
    });
  }

  /// Sends POS decision (ACCEPT/REJECT) back to the Cloud Webfront
  Future<void> sendOrderDecision({
    required int orderId,
    required String decision,
    String? reason,
    double? finalTotal,
    Map<String, dynamic>? pricingBreakdown,
    String? deliverySlotLabel,
    String? deliverySlotStart,
    String? deliverySlotEnd,
    String? deliverySlotText,
    bool? outForDelivery,
    String? deliveryDate,
  }) async {
    try {
      final baseUrl = await _getBaseUrl();
      final headers = await _getHeaders();

      final Map<String, dynamic> payload = {
        "order_id": orderId,
        "decision": decision,
      };
      if (reason != null) payload["reason"] = reason;
      if (finalTotal != null) payload["final_total"] = finalTotal;
      if (pricingBreakdown != null) payload["pricing_breakdown"] = pricingBreakdown;
      if (deliverySlotLabel != null) payload["delivery_slot_label"] = deliverySlotLabel;
      if (deliverySlotStart != null) payload["delivery_slot_start"] = deliverySlotStart;
      if (deliverySlotEnd != null) payload["delivery_slot_end"] = deliverySlotEnd;
      if (deliverySlotText != null) payload["delivery_slot_text"] = deliverySlotText;
      if (outForDelivery != null) payload["out_for_delivery"] = outForDelivery;
      if (deliveryDate != null) payload["delivery_date"] = deliveryDate;

      final response = await http.post(
        Uri.parse('$baseUrl/orders/decision'),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send order decision: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Sync Error (Order Decision): $e');
      rethrow;
    }
  }

  Future<void> markOrderOutForDelivery({
    required int orderId,
  }) async {
    try {
      final baseUrl = await _getBaseUrl();
      final headers = await _getHeaders();
      final payload = {
        "order_id": orderId,
        "status": "OUT_FOR_DELIVERY",
      };

      final response = await http.post(
        Uri.parse('$baseUrl/orders/status'),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to update order status: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Sync Error (Order Status): $e');
      rethrow;
    }
  }

  /// Updates delivery agent settings on the webfront.
  Future<void> updateDeliveryPhotoRequirement({
    required bool requireDeliveryPhoto,
  }) async {
    try {
      final baseUrl = await _getBaseUrl();
      final headers = await _getHeaders();

      final payload = {
        "require_delivery_photo": requireDeliveryPhoto,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/sync/config'),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to update delivery settings: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Sync Error (Delivery Config): $e');
      rethrow;
    }
  }

  Future<void> createDeliveryAgent({
    required String username,
    required String password,
    String? fullName,
  }) async {
    try {
      final baseUrl = await _getBaseUrl();
      final headers = await _getHeaders();

      final payload = {
        "username": username,
        "password": password,
        "full_name": fullName ?? "",
      };

      final response = await http.post(
        Uri.parse('$baseUrl/sync/delivery-agents'),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode != 201) {
        throw Exception(
          'Failed to create delivery agent: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Sync Error (Create Delivery Agent): $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> listDeliveryAgents() async {
    try {
      final baseUrl = await _getBaseUrl();
      final headers = await _getHeaders();

      final response = await http.get(
        Uri.parse('$baseUrl/sync/delivery-agents/list'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load delivery agents: ${response.statusCode} - ${response.body}',
        );
      }

      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['agents'] ?? []);
    } catch (e) {
      debugPrint('Sync Error (List Delivery Agents): $e');
      rethrow;
    }
  }

  Future<void> resetDeliveryAgentPassword({
    required int id,
    required String newPassword,
  }) async {
    try {
      final baseUrl = await _getBaseUrl();
      final headers = await _getHeaders();

      final payload = {
        "id": id,
        "password": newPassword,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/sync/delivery-agents/update'),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to reset password: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Sync Error (Reset Delivery Password): $e');
      rethrow;
    }
  }

  Future<void> setDeliveryAgentActive({
    required int id,
    required bool isActive,
  }) async {
    try {
      final baseUrl = await _getBaseUrl();
      final headers = await _getHeaders();

      final payload = {
        "id": id,
        "is_active": isActive,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/sync/delivery-agents/update'),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to update agent: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Sync Error (Update Delivery Agent): $e');
      rethrow;
    }
  }

  Future<void> deleteDeliveryAgent({
    required int id,
  }) async {
    try {
      final baseUrl = await _getBaseUrl();
      final headers = await _getHeaders();

      final payload = {
        "id": id,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/sync/delivery-agents/delete'),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to delete agent: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Sync Error (Delete Delivery Agent): $e');
      rethrow;
    }
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  List<Map<String, dynamic>> _normalizeItems(dynamic itemsRaw) {
    if (itemsRaw is List) {
      return itemsRaw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }
    if (itemsRaw is Map && itemsRaw['items'] is List) {
      return List<Map<String, dynamic>>.from(itemsRaw['items']);
    }
    return [];
  }

  Future<String?> _resolveCustomerId(dynamic phoneValue, dynamic nameValue) async {
    final phone = _parseInt(phoneValue);
    if (phone == null) return null;
    final existing = await (_db.select(_db.customers)
          ..where((t) => t.phone.equals(phone)))
        .getSingleOrNull();
    if (existing != null) return existing.id;

    final name = (nameValue ?? '').toString();
    final now = DateTime.now();
    final newId = const Uuid().v4();
    await _db.into(_db.customers).insert(
          CustomersCompanion(
            id: drift.Value(newId),
            phone: drift.Value(phone),
            name: drift.Value(name.isEmpty ? phone.toString() : name),
            email: const drift.Value(null),
            address: const drift.Value(''),
            createdAt: drift.Value(now),
            updatedAt: drift.Value(now),
          ),
        );
    return newId;
  }

  Future<void> _insertBillItemAndAdjustStock({
    required String billId,
    required Map<String, dynamic> item,
    required DateTime saleDate,
  }) async {
    final productId = await _resolveProductId(item);
    if (productId == null) return;

    final quantity = _parseDouble(item['quantity'] ?? item['qty']) ?? 0.0;
    final unitPrice =
        _parseDouble(item['rate'] ?? item['estimated_unit_price']) ?? 0.0;
    final totalAmount =
        _parseDouble(item['totalAmount'] ?? item['estimated_line_total']) ??
            (quantity * unitPrice);
    final taxAmount = _parseDouble(item['taxAmount']) ?? 0.0;
    final productName = (item['productName'] ?? item['product_name'] ?? '').toString();

    await _db.into(_db.billItems).insert(
          BillItemsCompanion(
            id: drift.Value(const Uuid().v4()),
            billId: drift.Value(billId),
            productId: drift.Value(productId),
            productName: drift.Value(
              productName.isEmpty ? 'Item' : productName,
            ),
            quantity: drift.Value(quantity),
            unitPrice: drift.Value(unitPrice),
            taxAmount: drift.Value(taxAmount),
            totalAmount: drift.Value(totalAmount),
            warrantyEndDate: const drift.Value(null),
          ),
        );

    await _deductStock(productId, quantity, unitPrice, saleDate);
  }

  Future<String?> _resolveProductId(Map<String, dynamic> item) async {
    final rawId = item['productId'] ?? item['product_id'];
    if (rawId != null) {
      final id = rawId.toString();
      final product = await (_db.select(_db.products)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      if (product != null) return product.id;
    }

    final externalId = item['product_external_id'] ?? item['productExternalId'];
    if (externalId != null) {
      final id = externalId.toString();
      final product = await (_db.select(_db.products)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      return product?.id;
    }
    return null;
  }

  Future<void> _deductStock(
    String productId,
    double qtyNeeded,
    double unitPrice,
    DateTime saleDate,
  ) async {
    if (qtyNeeded <= 0) return;

    final batches = await (_db.select(_db.productBatches)
          ..where((t) => t.productId.equals(productId))
          ..orderBy([(t) => drift.OrderingTerm.asc(t.createdAt)]))
        .get();

    var remaining = qtyNeeded;
    for (final batch in batches) {
      if (remaining <= 0) break;
      final available = batch.stockQty;
      if (available <= 0) continue;

      final take = remaining <= available ? remaining : available;
      final newQty = available - take;
      await (_db.update(_db.productBatches)
            ..where((t) => t.id.equals(batch.id)))
          .write(
        ProductBatchesCompanion(
          stockQty: drift.Value(newQty),
          updatedAt: drift.Value(DateTime.now()),
        ),
      );

      await _db.into(_db.productTransactions).insert(
            ProductTransactionsCompanion(
              id: drift.Value(const Uuid().v4()),
              productId: drift.Value(productId),
              type: const drift.Value('Sale'),
              quantity: drift.Value(take),
              price: drift.Value(unitPrice),
              totalAmount: drift.Value(take * unitPrice),
              date: drift.Value(saleDate),
              batchId: drift.Value(batch.id),
              location: const drift.Value('SHOP_FLOOR'),
              orderId: const drift.Value(null),
              userId: const drift.Value(null),
            ),
          );

      remaining -= take;
    }
  }
}
