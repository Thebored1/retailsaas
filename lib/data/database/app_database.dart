import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:rxdart/rxdart.dart'; // For CombineLatestStream
import 'seed_data.dart';

import 'tables/products.dart';
import 'tables/vendors.dart';
import 'tables/categories.dart';
import 'tables/brands.dart';
import 'tables/purchase_orders.dart';
import 'tables/purchase_order_items.dart';
import 'tables/debit_notes.dart';
import 'tables/debit_note_items.dart';
import 'tables/goods_receipts.dart';
import 'tables/goods_receipt_items.dart';
import 'tables/product_transactions.dart';
import 'tables/sales_bills.dart';
import 'tables/bill_items.dart';
import 'tables/bill_payments.dart';
import 'tables/bill_payments.dart';
import 'tables/general_ledger.dart';
import 'tables/vendor_payments.dart';
import 'tables/payment_allocations.dart';

import 'tables/product_batches.dart';
import 'tables/product_uoms.dart';

import 'tables/users.dart';
import 'tables/audit_logs.dart';
import 'tables/accounts.dart';
import 'tables/customers.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Products,
    Vendors,
    Categories,
    Brands,
    PurchaseOrders,
    PurchaseOrderItems,
    DebitNotes,
    DebitNoteItems,
    GoodsReceipts,
    GoodsReceiptItems,
    ProductTransactions,
    SalesBills,
    BillItems,
    BillPayments,
    BillPayments,
    GeneralLedger,
    VendorPayments,
    PaymentAllocations,
    ProductBatches,
    ProductBatches,
    ProductUoms,
    Users,
    AuditLogs,
    Accounts,
    Customers,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 31;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        try {
          // Ensure initial RMA bin exists or logics handle it
        } catch (e) {
          print('Error in Create: $e');
        }
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 31) {
          // Add base64 WebP image columns to categories and products
          try {
            await m.addColumn(categories, categories.imageB64);
          } catch (e) {
            print('Migration v31: imageB64 on categories may already exist: $e');
          }
          try {
            await m.addColumn(products, products.imageB64);
          } catch (e) {
            print('Migration v31: imageB64 on products may already exist: $e');
          }
        }
        if (from < 30) {
          // Add new tax snapshot columns to bill_items
          await m.addColumn(billItems, billItems.hsnCode);
          await m.addColumn(billItems, billItems.taxRate);
          await m.addColumn(billItems, billItems.cessRate);
        }
        if (from < 29) {
          await m.addColumn(salesBills, salesBills.customerId);
        }
        if (from < 28) {
          await m.createTable(customers);
        }
        if (from < 27) {
          await m.createTable(accounts);
        }
        if (from < 26) {
          // Add Users and AuditLogs tables
          await m.createTable(users);
          await m.createTable(auditLogs);

          // Add userId columns to all transaction tables
          await m.addColumn(salesBills, salesBills.userId);
          await m.addColumn(productTransactions, productTransactions.userId);
          await m.addColumn(purchaseOrders, purchaseOrders.userId);
          await m.addColumn(goodsReceipts, goodsReceipts.userId);
          await m.addColumn(debitNotes, debitNotes.userId);
          await m.addColumn(vendorPayments, vendorPayments.userId);
          await m.addColumn(billPayments, billPayments.userId);
        }
        if (from < 25) {
          await m.addColumn(goodsReceipts, goodsReceipts.totalAmount);

          // Backfill totalAmount for existing GRNs
          try {
            final grns = await select(goodsReceipts).get();
            for (final grn in grns) {
              final items = await (select(
                goodsReceiptItems,
              )..where((t) => t.grnId.equals(grn.id))).get();
              double total = 0.0;
              for (final item in items) {
                final tax = item.taxRate ?? 0.0; // Handle null if any
                final amount = (item.receivedQty * item.rate) * (1 + tax / 100);
                total += amount;
              }

              await (update(goodsReceipts)..where((t) => t.id.equals(grn.id)))
                  .write(GoodsReceiptsCompanion(totalAmount: Value(total)));
            }
          } catch (e) {
            print('Error backfilling totalAmount: $e');
          }
        }
        if (from < 24) {
          // Add PaymentAllocations Table
          await m.createTable(paymentAllocations);
          // Add paidAmount column to GoodsReceipts
          await m.addColumn(goodsReceipts, goodsReceipts.paidAmount);
        }
        if (from < 17) {
          await m.addColumn(goodsReceiptItems, goodsReceiptItems.taxRate);
        }
        if (from < 18) {
          await m.createTable(productUoms);
        }
        if (from < 19) {
          await m.addColumn(purchaseOrderItems, purchaseOrderItems.uom);
          await m.addColumn(
            purchaseOrderItems,
            purchaseOrderItems.conversionFactor,
          );
          await m.addColumn(
            goodsReceiptItems,
            goodsReceiptItems.conversionFactor,
          );
        }
        if (from < 20) {
          await m.createTable(billItems);
          try {
            await m.addColumn(products, products.warrantyMonths);
          } catch (e) {
            print('Error adding warrantyMonths: $e');
          }
        }
        if (from < 21) {
          try {
            await m.addColumn(productBatches, productBatches.isDamaged);
          } catch (e) {
            print('Error adding isDamaged: $e');
          }
        }
        if (from < 22) {
          try {
            await m.addColumn(
              productTransactions,
              productTransactions.location,
            );
          } catch (e) {
            print('Error adding location: $e');
          }
        }
        if (from < 2) {
          // Add receivedQuantity column to PurchaseOrderItems table
          await m.addColumn(
            purchaseOrderItems,
            purchaseOrderItems.receivedQuantity,
          );
        }
        if (from < 3) {
          // Add challanNumber column to PurchaseOrders table
          await m.addColumn(purchaseOrders, purchaseOrders.challanNumber);
        }
        if (from < 4) {
          // Add notes column to DebitNotes table
          await m.addColumn(debitNotes, debitNotes.notes);
          // Create DebitNoteItems table
          await m.createTable(debitNoteItems);
        }
        if (from < 5) {
          // 5 was skipped or covered by 4 logic in previous steps
        }
        if (from < 6) {
          await m.createTable(goodsReceipts);
        }
        if (from < 7) {
          await m.createTable(goodsReceiptItems);
        }
        if (from < 8) {
          await m.createTable(productTransactions);
        }
        if (from < 10) {
          // Force fix for ProductTransactions schema (Int -> Text UUID)
          // Doing this at v10 ensures it runs for users stuck on broken v9
          await m.deleteTable(productTransactions.actualTableName);
          await m.createTable(productTransactions);
        }
        if (from < 12) {
          // Ensure isInfiniteStock is added (runs for v10->12 and v11->12)
          try {
            await m.addColumn(products, products.isInfiniteStock);
          } catch (e) {
            // Ignore if column already exists (rare case)
            print('Column isInfiniteStock might already exist: $e');
          }
        }
        if (from < 13) {
          // Add SalesBills and BillPayments tables
          await m.createTable(salesBills);
          await m.createTable(billPayments);
        }
        if (from < 14) {
          await m.createTable(generalLedger);
        }
        if (from < 15) {
          // Product-Batch Refactor
          await m.createTable(productBatches);

          // DATA MIGRATION: Move Stock/Price from Products to ProductBatches
          try {
            final oldProducts = await customSelect(
              'SELECT * FROM products',
            ).get();
            for (final row in oldProducts) {
              final pId = row.read<String>('id');
              final mrp = row.read<double>(
                'mrp',
              ); // Assumes snake_case? No, drift default is snake_case but better check if custom name used.
              // In products.dart: get mrp => real()(); -> 'mrp'
              final sp = row.read<double>('selling_price');
              final pr = row.read<double>('purchase_rate');
              final stock = row.read<double>('stock_qty');
              final created =
                  row.read<DateTime>('created_at') ?? DateTime.now();

              await into(productBatches).insert(
                ProductBatchesCompanion(
                  id: Value(const Uuid().v4()),
                  productId: Value(pId),
                  mrp: Value(mrp),
                  sellingPrice: Value(sp),
                  purchaseRate: Value(pr),
                  stockQty: Value(stock),
                  batchNumber: const Value('INITIAL-MIGRATION'),
                  createdAt: Value(created),
                ),
              );
            }
          } catch (e) {
            print('Migration v15 Data Error: $e');
            // Don't crash migration, but data might be lost if not careful.
            // For now, logging.
          }

          // Update Products Table (Drop Columns)
          // Drift's alterTable with TableMigration matches the table class definition
          await m.alterTable(TableMigration(products));
        }

        if (from < 16) {
          // Re-adding pricing columns to Products table (with defaults handling backfill)
          // We use try-catch block in case they somehow exist or issues arise
          try {
            await m.addColumn(products, products.mrp);
            await m.addColumn(products, products.sellingPrice);
            await m.addColumn(products, products.purchaseRate);
          } catch (e) {
            print('Error adding pricing columns in v16: $e');
          }
        }
        if (from < 23) {
          await m.createTable(vendorPayments);
        }
      },
    );
  }

  // --- Dashboard Metrics ---

  // 1. Total Inventory Value: sum(batch.stockQty * batch.purchaseRate)
  Stream<double> watchTotalInventoryValue() {
    final purchaseValue = productBatches.stockQty * productBatches.purchaseRate;
    final totalValue = purchaseValue.sum();
    final query = selectOnly(productBatches)..addColumns([totalValue]);
    return query.map((row) => row.read(totalValue) ?? 0.0).watchSingle();
  }

  // 2. Low Stock Items: count where sum(batch.stock) <= lowStockLimit
  // This is complex in Drift. For now, we'll fetch all and count in Dart or simplify.
  // Simplified: Check simply products that have low stock limit?
  // Better: Use Dart stream transformation.
  Stream<int> watchLowStockItemsCount() {
    // Left Join Products with Batches
    final query = select(products).join([
      leftOuterJoin(
        productBatches,
        productBatches.productId.equalsExp(products.id),
      ),
    ]);

    return query.watch().map((rows) {
      final productInfo = <String, ({double limit, double stock})>{};

      for (final row in rows) {
        final p = row.readTable(products);
        final b = row.readTableOrNull(productBatches);

        final current =
            productInfo[p.id] ?? (limit: p.lowStockLimit, stock: 0.0);
        productInfo[p.id] = (
          limit: current.limit,
          stock: current.stock + (b?.stockQty ?? 0),
        );
      }

      var count = 0;
      for (final info in productInfo.values) {
        if (info.stock <= info.limit) {
          count++;
        }
      }
      return count;
    });
  }

  // 3. Pending Purchase Orders: count where status is 'Draft' or 'Sent' (not Received/Completed)
  // Adjust logic based on your exact status strings. Assuming 'Draft' and 'Sent' are pending.
  Stream<int> watchPendingPurchaseOrdersCount() {
    final count = purchaseOrders.id.count();
    final query = selectOnly(purchaseOrders)
      ..addColumns([count])
      ..where(purchaseOrders.status.isIn(['Draft', 'Sent', 'Ordered']));
    return query.map((row) => row.read(count) ?? 0).watchSingle();
  }

  // 4. Pending Debit Notes: count where status is 'Draft'
  Stream<int> watchPendingDebitNotesCount() {
    return (select(debitNotes)..where((t) => t.status.equals('Draft')))
        .watch()
        .map((list) => list.length);
  }

  Future<void> findOrCreateBatch({
    required String productId,
    required double mrp,
    required double buyPrice,
    required double quantity,
    DateTime? expiry,
    String? batchNumber,
  }) async {
    final query = select(productBatches)
      ..where((tbl) => tbl.productId.equals(productId) & tbl.mrp.equals(mrp))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(1);

    final results = await query.get();
    final existing = results.isNotEmpty ? results.first : null;

    if (existing != null) {
      // Update existing batch
      final oldQty = existing.stockQty;
      final oldRate = existing.purchaseRate;
      final newQty = oldQty + quantity;

      // Weighted Average Cost
      final newRate = newQty > 0
          ? ((oldQty * oldRate) + (quantity * buyPrice)) / newQty
          : buyPrice;

      await (update(
        productBatches,
      )..where((t) => t.id.equals(existing.id))).write(
        ProductBatchesCompanion(
          stockQty: Value(newQty),
          purchaseRate: Value(newRate),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      // Create new batch
      await into(productBatches).insert(
        ProductBatchesCompanion(
          id: Value(const Uuid().v4()),
          productId: Value(productId),
          mrp: Value(mrp),
          sellingPrice: Value(mrp), // Default SP = MRP
          purchaseRate: Value(buyPrice),
          stockQty: Value(quantity),
          batchNumber: Value(batchNumber),
          expiryDate: Value(expiry),
          createdAt: Value(DateTime.now()),
        ),
      );
    }
  }

  Future<List<TransactionWithProduct>> getRecentTransactions() async {
    final query = select(productTransactions).join([
      innerJoin(products, products.id.equalsExp(productTransactions.productId)),
    ])..orderBy([OrderingTerm.desc(productTransactions.date)]);

    final rows = await query.get();
    return rows.map((row) {
      return TransactionWithProduct(
        row.readTable(productTransactions),
        row.readTable(products),
      );
    }).toList();
  }

  Stream<double> watchTodaysSales() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = select(salesBills)
      ..where((t) => t.date.isBetweenValues(startOfDay, endOfDay));

    return query.watch().map((bills) {
      return bills.fold(0.0, (sum, bill) => sum + bill.grandTotal);
    });
  }

  // 8. Watch Vendor Balance
  Stream<double> watchVendorBalance(String vendorId) {
    // Liability: Sum of GRN values (What we received and accepted/billed)
    final liabilityQuery = select(goodsReceipts).join([
      innerJoin(
        purchaseOrders,
        purchaseOrders.id.equalsExp(goodsReceipts.poId),
      ),
    ])..where(purchaseOrders.vendorId.equals(vendorId));

    // Paid: Sum of VendorPayments
    final paidQuery = select(vendorPayments)
      ..where((t) => t.vendorId.equals(vendorId));

    // Returns/Adjustments: Sum of DebitNotes (Status != Draft)
    final debitNoteQuery = select(debitNotes)
      ..where((t) => t.vendorId.equals(vendorId) & t.status.equals('Sent'));

    return CombineLatestStream.combine3(
      liabilityQuery.watch(),
      paidQuery.watch(),
      debitNoteQuery.watch(),
      (
        List<TypedResult> grns,
        List<VendorPayment> payments,
        List<DebitNote> dns,
      ) {
        final liability = grns.fold(
          0.0,
          (sum, row) => sum + row.readTable(goodsReceipts).totalAmount,
        );
        final paid = payments.fold(0.0, (sum, p) => sum + p.amount);
        final adjusted = dns.fold(0.0, (sum, dn) => sum + dn.amount);

        return liability - paid - adjusted;
      },
    );
  }

  // 9. Monthly Sales Chart
  Future<List<Map<String, dynamic>>> getMonthlySales(int year) async {
    // Custom Query for Aggregation
    // SQLite: strftime('%m', date) but Drift has date functions too.
    // Custom SQL is easiest for aggregation.
    final result = await customSelect(
      'SELECT strftime(\'%m\', date) as month, SUM(grand_total) as total '
      'FROM sales_bills '
      'WHERE strftime(\'%Y\', date) = ? '
      'GROUP BY month '
      'ORDER BY month ASC',
      variables: [Variable.withString(year.toString())],
      readsFrom: {salesBills},
    ).get();

    return result.map((row) {
      return {
        'month': int.parse(row.read<String>('month')),
        'total': row.read<double>('total'),
      };
    }).toList();
  }

  // --- Ledger Helpers ---

  Future<void> recordLedgerEntry(GeneralLedgerCompanion entry) async {
    await into(generalLedger).insert(entry);
  }

  Stream<List<GeneralLedgerData>> watchLedger() {
    return (select(
      generalLedger,
    )..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();
  }

  // Sync/Backfill Ledger from existing transactions
  Future<void> syncLedger() async {
    // 1. Sync Sales
    final sales = await select(salesBills).get();
    for (final sale in sales) {
      final exists = await (select(
        generalLedger,
      )..where((tbl) => tbl.referenceId.equals(sale.id))).getSingleOrNull();
      if (exists == null) {
        await recordLedgerEntry(
          GeneralLedgerCompanion(
            id: Value(const Uuid().v4()),
            date: Value(sale.date), // Correct field: date
            type: const Value('SALE'),
            description: Value(
              'Bill #${sale.id.length > 8 ? sale.id.substring(0, 8) : sale.id}',
            ), // Use ID segment as bill number fallback
            debit: const Value(0.0),
            credit: Value(sale.grandTotal),
            referenceId: Value(sale.id),
            referenceTable: const Value('sales_bills'),
          ),
        );
      }
    }

    // 2. Sync Purchases (GRNs)
    final grns = await select(goodsReceipts).get();
    for (final grn in grns) {
      final exists = await (select(
        generalLedger,
      )..where((tbl) => tbl.referenceId.equals(grn.id))).getSingleOrNull();
      if (exists == null) {
        // Calculate total for GRN if not stored directly.
        // For now, we'll fetch items to sum up or just skip if expensive.
        // ACTUALLY, we don't store GRN total in header easily, checking GoodsReceipts tabledef might be needed.
        // Let's assume we can get it from items.
        final items = await (select(
          goodsReceiptItems,
        )..where((tbl) => tbl.grnId.equals(grn.id))).get();
        final total = items.fold(
          0.0,
          (sum, item) => sum + (item.acceptedQty * item.rate),
        );

        if (total > 0) {
          await recordLedgerEntry(
            GeneralLedgerCompanion(
              id: Value(const Uuid().v4()),
              date: Value(grn.grnDate),
              type: const Value('PURCHASE'),
              description: Value('GRN Recv: ${grn.grnNumber}'),
              debit: Value(total),
              credit: const Value(0.0),
              referenceId: Value(grn.id),
              referenceTable: const Value('goods_receipts'),
            ),
          );
        }
      }
    }

    // 3. Sync Debit Notes
    final dns = await select(debitNotes).get();
    for (final dn in dns) {
      final exists = await (select(
        generalLedger,
      )..where((tbl) => tbl.referenceId.equals(dn.id))).getSingleOrNull();
      if (exists == null) {
        await recordLedgerEntry(
          GeneralLedgerCompanion(
            id: Value(const Uuid().v4()),
            date: Value(dn.date),
            type: const Value('DEBIT_NOTE'),
            description: Value('Debit Note: ${dn.reason}'),
            debit: const Value(0.0),
            credit: Value(dn.amount), // Money back/Asset reduction
            referenceId: Value(dn.id),
            referenceTable: const Value('debit_notes'),
          ),
        );
      }
    }
  }

  // 5. Watch Sold Quantities (Grouped by Product ID)
  // Excludes 'Replacement' items so we track Net Sales - Returns (Active Warranties)
  Stream<Map<String, double>> watchSoldQuantities() {
    final qty = billItems.quantity.sum();
    final query = selectOnly(billItems)
      ..addColumns([billItems.productId, qty])
      ..where(billItems.productName.like('%(Replacement)').not())
      ..groupBy([billItems.productId]);

    return query.watch().map((rows) {
      final map = <String, double>{};
      for (final row in rows) {
        final pId = row.read(billItems.productId);
        final q = row.read(qty);
        if (pId != null && q != null) {
          map[pId] = q;
        }
      }
      return map;
    });
  }

  // 6. Watch Stock Ledger
  Stream<List<StockLedgerEntry>> watchStockLedger() {
    final query = select(productTransactions).join([
      leftOuterJoin(
        products,
        products.id.equalsExp(productTransactions.productId),
      ),
      leftOuterJoin(
        productBatches,
        productBatches.id.equalsExp(productTransactions.batchId),
      ),
    ]);

    // Order by date desc
    query.orderBy([OrderingTerm.desc(productTransactions.date)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return StockLedgerEntry(
          transaction: row.readTable(productTransactions),
          product: row.readTable(products),
          batch: row.readTableOrNull(productBatches),
        );
      }).toList();
    });
  }

  // 7. Watch Metrics
  Stream<LedgerMetrics> watchLedgerMetrics() {
    return select(productTransactions).watch().map((rows) {
      int swaps = 0;
      int rmaStock = 0;
      int goodStockOut = 0;

      for (var t in rows) {
        if (t.type == 'Replacement') {
          swaps++;
        }

        if (t.location == 'RMA_BIN') {
          // Assume positive quantity for IN
          rmaStock += t.quantity.toInt();
        }

        if (t.location == 'SHOP_FLOOR' && t.type == 'Replacement') {
          // Replacement is OUT, stored as positive quantity in transaction usually?
          // In _processSaleItem: quantity: Value(item.quantity.toDouble()) -> Positive.
          // So for OUT, we sum it up.
          goodStockOut += t.quantity.toInt();
        }
      }

      return LedgerMetrics(
        totalSwaps: swaps,
        rmaInventory: rmaStock,
        goodStockOut: goodStockOut,
      );
    });
  }

  // 10. Get Damaged Stock for RMA Return
  Future<List<RmaItem>> getDamagedStock() async {
    final query =
        select(productBatches).join([
          innerJoin(products, products.id.equalsExp(productBatches.productId)),
        ])..where(
          productBatches.isDamaged.equals(true) &
              productBatches.stockQty.isBiggerThanValue(0),
        );

    final rows = await query.get();
    return rows.map((row) {
      return RmaItem(
        product: row.readTable(products),
        batch: row.readTable(productBatches),
      );
    }).toList();
  }

  // 11. Process RMA Return (Standalone Debit Note)
  Future<void> processRmaReturn({
    required DebitNotesCompanion dn,
    required List<
      ({DebitNoteItemsCompanion item, String batchId, double quantity})
    >
    items,
  }) {
    return transaction(() async {
      // 1. Insert Debit Note
      await into(debitNotes).insert(dn);

      // 2. Process Items
      for (final i in items) {
        // A. Insert DN Item
        await into(debitNoteItems).insert(i.item);

        // B. Deduct Stock from ProductBatch (RMA Bin)
        // We know the batchId from the UI selection
        final batch = await (select(
          productBatches,
        )..where((t) => t.id.equals(i.batchId))).getSingle();

        final newQty = batch.stockQty - i.quantity;

        await (update(productBatches)..where((t) => t.id.equals(i.batchId)))
            .write(ProductBatchesCompanion(stockQty: Value(newQty)));

        // C. Record Transaction (OUT)
        await into(productTransactions).insert(
          ProductTransactionsCompanion(
            id: Value(const Uuid().v4()),
            productId: i.item.productId,
            type: const Value('Purchase Return'),
            quantity: Value(i.quantity),
            location: const Value('RMA_BIN'),
            batchId: Value(i.batchId),
            date: dn.date,
            totalAmount: Value(i.quantity * i.item.rate.value),
            price: i.item.rate,
          ),
        );
      }
    });
  }

  // --- Maintenance / Debug ---
  Future<void> clearAllTransactions() async {
    await transaction(() async {
      // Inventory
      await delete(productBatches).go();
      await delete(productTransactions).go();

      // Purchases
      await delete(purchaseOrders).go();
      await delete(purchaseOrderItems).go();
      await delete(goodsReceipts).go();
      await delete(goodsReceiptItems).go();
      await delete(vendorPayments).go();
      await delete(paymentAllocations).go();

      // Sales
      await delete(salesBills).go();
      await delete(billItems).go();
      await delete(billPayments).go();

      // Accounting / Adjustments
      await delete(generalLedger).go();
      await delete(debitNotes).go();
      await delete(debitNoteItems).go();
    });
  }
}

class TransactionWithProduct {
  final ProductTransaction transaction;
  final Product product;
  TransactionWithProduct(this.transaction, this.product);
}

class StockLedgerEntry {
  final ProductTransaction transaction;
  final Product product;
  final ProductBatch? batch;
  StockLedgerEntry({
    required this.transaction,
    required this.product,
    this.batch,
  });
}

class RmaItem {
  final Product product;
  final ProductBatch batch;
  RmaItem({required this.product, required this.batch});
}

class LedgerMetrics {
  final int totalSwaps;
  final int rmaInventory;
  final int goodStockOut;

  LedgerMetrics({
    required this.totalSwaps,
    required this.rmaInventory,
    required this.goodStockOut,
  });
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // 1. Find the user's writable AppData directory
    final appSupportDir = await getApplicationSupportDirectory();
    final dbFolder = Directory(p.join(appSupportDir.path, 'backend'));
    
    if (!await dbFolder.exists()) {
      await dbFolder.create(recursive: true);
    }

    final dbFile = File(p.join(dbFolder.path, 'db.sqlite'));

    // 2. If the database doesn't exist in AppData, copy it from the bundled location
    if (!await dbFile.exists()) {
      try {
        // Find bundled database relative to the executable (Production)
        // or relative to current directory (Debug)
        final exePath = Platform.resolvedExecutable;
        final exeDir = p.dirname(exePath);
        
        // Potential bundled paths
        final bundledPaths = [
          p.join(exeDir, 'backend', 'db.sqlite'), // Production
          p.join(Directory.current.path, 'backend', 'db.sqlite'), // Debug
        ];

        File? sourceFile;
        for (final path in bundledPaths) {
          final f = File(path);
          if (await f.exists()) {
            sourceFile = f;
            break;
          }
        }

        if (sourceFile != null) {
          await sourceFile.copy(dbFile.path);
          print('Database seeded from bundled file: ${sourceFile.path}');
        }
      } catch (e) {
        print('Error seeding database: $e');
      }
    }

    return NativeDatabase(dbFile);
  });
}
