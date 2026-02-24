import 'package:retailsaas/screens/goods_receipt_screen.dart';
import 'dart:io';
import 'package:retailsaas/widgets/grn_history_button.dart'; // Added GRN Screen
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'add_vendor_form.dart';
import '../models/product_inventory_view.dart'; // Added
// import '../models/vendor.dart'; // Using DB Vendor class now

// import '../models/purchase_order.dart'; // Using DB PO class logic (or custom model if needed)
import '../widgets/admin_side_menu.dart';
import 'admin_main_screen.dart';
import '../models/vendor.dart' as model; // Alias to avoid conflict
import 'package:drift/drift.dart' hide Column;
import '../locator.dart';
import '../data/database/app_database.dart';
import 'package:uuid/uuid.dart';

class PurchaseOrderScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final String? existingOrderId; // Changed from Object to ID for DB lookup

  const PurchaseOrderScreen({super.key, this.onBack, this.existingOrderId});

  @override
  State<PurchaseOrderScreen> createState() => _PurchaseOrderScreenState();
}

class _PurchaseOrderScreenState extends State<PurchaseOrderScreen> {
  final AppDatabase _db = getIt<AppDatabase>();
  final _uuid = const Uuid();

  // Selected items for the PO (UI state)
  // We will keep using Map for selected items to store 'qty' and snapshot data
  final List<Map<String, dynamic>> _selectedItems = [];

  Vendor? _selectedVendor; // Drift Vendor Class

  bool _showPreviewMobile = false;
  final TextEditingController _vendorSearchController = TextEditingController();

  // Status
  String _status = 'Draft';

  String? _currentPoId;
  String _currentPoNumber = '';

  // Company Details (Static for now, could be in DB)
  final Map<String, dynamic> _company = {
    'name': 'Jiyalal Stores',
    'address': 'Plot 42, Industrial Area,\nMumbai, Maharashtra - 400001',
    'gstin': '27ABCDE1234F1Z1',
    'stateCode': '27',
  };

  @override
  void initState() {
    super.initState();
    _currentPoId = widget.existingOrderId;
    if (_currentPoId != null) {
      _loadExistingOrder();
    } else {
      // Generate a new PO Number for this session
      _currentPoNumber =
          'PO-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    }
  }

  Future<void> _loadExistingOrder() async {
    if (_currentPoId == null) return;
    try {
      final po = await (_db.select(
        _db.purchaseOrders,
      )..where((tbl) => tbl.id.equals(_currentPoId!))).getSingleOrNull();

      if (po != null) {
        setState(() {
          _status = po.status;

          _currentPoNumber = po.poNumber; // Load existing number
        });

        if (po.vendorId.toString().isNotEmpty) {
          final vendor = await (_db.select(
            _db.vendors,
          )..where((tbl) => tbl.id.equals(po.vendorId))).getSingleOrNull();
          if (vendor != null) {
            setState(() => _selectedVendor = vendor);
          }
        }

        // Use a join to get product details including imageUrl
        final query = _db.select(_db.purchaseOrderItems).join([
          leftOuterJoin(
            _db.products,
            _db.products.id.equalsExp(_db.purchaseOrderItems.productId),
          ),
        ]);
        query.where(_db.purchaseOrderItems.poId.equals(po.id));

        final result = await query.get();

        if (mounted) {
          setState(() {
            _selectedItems.clear();
            _selectedItems.addAll(
              result.map((row) {
                final item = row.readTable(_db.purchaseOrderItems);
                final product = row.readTableOrNull(_db.products);

                return {
                  'id': item.productId,
                  'name': item.productName,
                  'price': item.unitPrice,
                  'qty': item.quantity,
                  'taxRate': item.taxRate,
                  'imageUrl': product?.imageUrl,
                  'uom': item.uom,
                  'factor': item.conversionFactor,
                  'hsn': product?.hsnCode,
                  'availableUoms': <dynamic>[], // Will load below
                };
              }).toList(),
            );
          });

          // Load UOMs for all items separately
          for (var item in _selectedItems) {
            final uoms = await (_db.select(
              _db.productUoms,
            )..where((t) => t.productId.equals(item['id']))).get();
            if (mounted) {
              setState(() {
                item['availableUoms'] = uoms
                    .map(
                      (u) => {
                        'name': u.uomName,
                        'factor': u.conversionFactor,
                        'isBase': u.isBase, // Store isBase for fallback logic
                      },
                    )
                    .toList();

                // If no UOM saved (legacy), default to Base
                if (item['uom'] == null) {
                  // Find base or default
                  var base = uoms.where((u) => u.isBase).firstOrNull;
                  base ??= uoms.firstOrNull;

                  if (base != null) {
                    item['uom'] = base.uomName;
                    item['factor'] = base.conversionFactor;
                  } else {
                    item['uom'] = 'PCS';
                    item['factor'] = 1.0;
                  }
                }
              });
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading PO: $e');
    }
  }

  int _getQty(String productId) {
    final index = _selectedItems.indexWhere((item) => item['id'] == productId);
    return index != -1 ? (_selectedItems[index]['qty'] as int) : 0;
  }

  Future<void> _updateQty(
    Map<String, dynamic> product,
    int delta, {
    String? uom,
    double? factor,
    List<dynamic>? uoms,
  }) async {
    final index = _selectedItems.indexWhere(
      (item) => item['id'] == product['id'],
    );

    if (index != -1) {
      // Update existing
      setState(() {
        final currentQty = _selectedItems[index]['qty'] as int;
        final newQty = currentQty + delta;
        if (newQty <= 0) {
          _selectedItems.removeAt(index);
        } else {
          _selectedItems[index]['qty'] = newQty;
        }
      });
    } else if (delta > 0) {
      // Add new
      // Use passed UOM/Factor/List if available, else fetch
      List<dynamic> uomList = uoms ?? [];
      if (uomList.isEmpty) {
        final dbUoms = await (_db.select(
          _db.productUoms,
        )..where((t) => t.productId.equals(product['id']))).get();
        uomList = dbUoms
            .map(
              (u) => {
                'name': u.uomName,
                'factor': u.conversionFactor,
                'isBase': u.isBase,
              },
            )
            .toList();
      }

      // Default logic
      String defaultUom = uom ?? "PCS";
      double defaultFactor = factor ?? 1.0;

      if (uom == null && uomList.isNotEmpty) {
        final base = uomList.firstWhere(
          (u) => u['isBase'] == true,
          orElse: () => uomList.first,
        );
        defaultUom = base['name'] as String;
        defaultFactor = (base['factor'] as num).toDouble();
      }

      setState(() {
        _selectedItems.add({
          ...product,
          'qty': delta,
          'uom': defaultUom,
          'factor': defaultFactor,
          'availableUoms': uomList,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;

        // Mobile Layout: Show only ONE pane at a time
        if (isMobile) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F9FC),
            body: SafeArea(
              child: _showPreviewMobile
                  ? _buildPreviewPane(true) // Show Preview (Full Screen)
                  : _buildInputPane(true), // Show Input Form (Full Screen)
            ),
          );
        }

        // Desktop Layout: Split View with Sidebar
        return Scaffold(
          backgroundColor: const Color(0xFFF7F9FC),
          body: Row(
            children: [
              // Sidebar
              AdminSideMenu(
                selectedItem: 'Purchase Order',
                onItemSelected: (item) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => AdminMainScreen(initialItem: item),
                    ),
                    (route) => false,
                  );
                },
              ),

              // LEFT PANE: Product Selection
              Expanded(flex: 2, child: _buildInputPane(false)),

              // RIGHT PANE: Document Preview
              Expanded(flex: 3, child: _buildPreviewPane(false)),
            ],
          ),
        );
      },
    );
  }

  // Helper Widgets
  Widget _buildInputPane(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          // Check Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => widget.onBack != null
                      ? widget.onBack!()
                      : Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 10),
                Text(
                  _currentPoId != null
                      ? 'Purchase Order Details'
                      : 'Create Purchase Order',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isMobile) ...[
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _showPreviewMobile = true;
                      });
                    },
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: const Text('Preview'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Vendor Selector
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vendor',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                StreamBuilder<List<Vendor>>(
                  stream: _db.select(_db.vendors).watch(),
                  builder: (context, snapshot) {
                    final vendors = snapshot.data ?? [];

                    return Autocomplete<Vendor>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return vendors;
                        }
                        return vendors.where((Vendor option) {
                          return option.name.toLowerCase().contains(
                            textEditingValue.text.toLowerCase(),
                          );
                        });
                      },
                      displayStringForOption: (Vendor option) => option.name,
                      onSelected: (Vendor selection) {
                        setState(() {
                          _selectedVendor = selection;
                        });
                      },
                      fieldViewBuilder:
                          (
                            BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted,
                          ) {
                            // Sync controller if vendor selected via other means
                            if (_selectedVendor != null &&
                                textEditingController.text !=
                                    _selectedVendor!.name) {
                              textEditingController.text =
                                  _selectedVendor!.name;
                            }

                            return TextField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              readOnly: _currentPoId != null,
                              decoration: InputDecoration(
                                hintText: 'Select Vendor...',
                                prefixIcon: const Icon(Icons.store),
                                suffixIcon: _selectedVendor != null
                                    ? (_currentPoId == null
                                          ? IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed: () {
                                                setState(() {
                                                  _selectedVendor = null;
                                                  textEditingController.clear();
                                                });
                                              },
                                            )
                                          : null)
                                    : IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Scaffold(
                                                body: AddVendorForm(
                                                  onSave: (model.Vendor newVendor) async {
                                                    // Save to DB
                                                    await _db
                                                        .into(_db.vendors)
                                                        .insert(
                                                          VendorsCompanion.insert(
                                                            id: _uuid.v4(),
                                                            name:
                                                                newVendor.name,
                                                            address: newVendor
                                                                .address,
                                                            contact: newVendor
                                                                .mobileNumber,
                                                            email: Value(
                                                              newVendor.email,
                                                            ),
                                                            gstin: Value(
                                                              newVendor.gstin,
                                                            ),
                                                            stateCode: Value(
                                                              newVendor
                                                                  .stateCode,
                                                            ),
                                                          ),
                                                        );
                                                    if (context.mounted)
                                                      Navigator.pop(context);
                                                  },
                                                  onCancel: () =>
                                                      Navigator.pop(context),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: _selectedVendor != null
                                        ? const Color(0xFF8B4256)
                                        : Colors.grey.shade200,
                                    width: _selectedVendor != null ? 1.5 : 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF8B4256),
                                    width: 1.5,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                              ),
                            );
                          },
                    );
                  },
                ),
              ],
            ),
          ),

          // Search Bar (Product)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller:
                  _vendorSearchController, // Reuse controller for product search
              onChanged: (_) => setState(() {}),
              readOnly: _currentPoId != null, // Disable search when PO is saved
              decoration: InputDecoration(
                hintText: _currentPoId != null
                    ? 'Product search disabled (PO saved)'
                    : 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                filled: true,
                fillColor: _currentPoId != null
                    ? Colors.grey.shade100
                    : Colors.grey.shade50,
              ),
            ),
          ),

          // Product List
          Expanded(
            child: StreamBuilder<List<ProductInventoryView>>(
              stream: (() {
                // Create Joined Stream
                final query = _db.select(_db.products).join([
                  leftOuterJoin(
                    _db.productBatches,
                    _db.productBatches.productId.equalsExp(_db.products.id),
                  ),
                ]);
                // Filter Active
                query.where(_db.products.isActive.equals(true));

                return query.watch().map((rows) {
                  final grouped = <String, ProductInventoryView>{};
                  for (final row in rows) {
                    final product = row.readTable(_db.products);
                    final batch = row.readTableOrNull(_db.productBatches);

                    if (!grouped.containsKey(product.id)) {
                      grouped[product.id] = ProductInventoryView(
                        product: product,
                        batches: [],
                      );
                    }
                    if (batch != null) {
                      grouped[product.id]!.batches.add(batch);
                    }
                  }
                  // Sort Batches by datedesc inside view? Or just rely on order.
                  return grouped.values.toList();
                });
              })(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allItems = snapshot.data!;
                // Filter locally for now
                final items = _vendorSearchController.text.isEmpty
                    ? allItems
                    : allItems
                          .where(
                            (i) => i.product.name.toLowerCase().contains(
                              _vendorSearchController.text.toLowerCase(),
                            ),
                          )
                          .toList();

                if (items.isEmpty) {
                  return const Center(child: Text('No products found'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final product = item.product;

                    final qty = _getQty(product.id);
                    final isSelected = qty > 0;

                    // Determine Purchase Rate (Latest Batch -> Master Definition)
                    double purchaseRate = 0.0;
                    if (item.batches.isNotEmpty) {
                      item.batches.sort(
                        (a, b) => a.createdAt.compareTo(b.createdAt),
                      );
                      purchaseRate = item.batches.last.purchaseRate;
                    } else {
                      purchaseRate = product.purchaseRate;
                    }

                    // Convert DB Product to Map to reuse existing logic slightly
                    final productMap = {
                      'id': product.id,
                      'name': product.name,
                      'price': purchaseRate,
                      'taxRate': product.gstRate,
                      'cess': product.cessRate,
                      'imageUrl': product.imageUrl,
                      'hsn': product.hsnCode,
                    };

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Image
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                              image: product.imageUrl != null
                                  ? DecorationImage(
                                      image:
                                          product.imageUrl!.startsWith('http')
                                          ? NetworkImage(product.imageUrl!)
                                          : FileImage(File(product.imageUrl!))
                                                as ImageProvider, // Handle Local File
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: product.imageUrl == null
                                ? Center(
                                    child: Icon(
                                      Icons.shopping_bag_outlined,
                                      color: Colors.grey.shade400,
                                      size: 24,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          // Details (Name & Stock)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  product.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Stock Display Logic
                                Text(
                                  '${item.totalStock.toStringAsFixed(0)} ${product.uom} available', // Updated
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Price & Action
                          Expanded(
                            // UOM Selector & Add Button
                            child: FutureBuilder<List<dynamic>>(
                              future:
                                  (_db.select(_db.productUoms)..where(
                                        (t) => t.productId.equals(product.id),
                                      ))
                                      .get()
                                      .then((rows) {
                                        return rows
                                            .map(
                                              (u) => {
                                                'name': u.uomName,
                                                'factor': u.conversionFactor,
                                                'isBase': u.isBase,
                                              },
                                            )
                                            .toList();
                                      }),
                              builder: (context, snapshot) {
                                final uoms = snapshot.data ?? [];

                                // Local state for Dropdown in this list item?
                                // StatefulBuilder is needed if we want to change value locally before adding.
                                return StatefulBuilder(
                                  builder: (context, setStateLocal) {
                                    // Default Selection Logic
                                    // Make sure to rely on a local variable if set, otherwise default
                                    // But we can't persist local variable easily in ListView recycling.
                                    // Simplified: Just show "Add" button if 0, or +/-.
                                    // UOM selector only relevant if not added?
                                    // Actually, let's show UOM selector always.
                                    // ISSUE: If I change dropdown, where is state stored?
                                    // Use a temporary map in parent? or just StatfulBuilder local var?
                                    // If strict local var, it resets on scroll.
                                    // Acceptable for "Add" action. user selects -> clicks add immediately.

                                    // (No local default selection logic needed as we iterate in menu)

                                    // Just use a simple "Add" with default base for now?
                                    // No, user specifically asked for selector.

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Rs. ${purchaseRate.toStringAsFixed(2)}',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),

                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Quantity Control
                                            isSelected
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                      border: Border.all(
                                                        color: Colors
                                                            .grey
                                                            .shade300,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(
                                                            Icons.remove,
                                                            size: 16,
                                                          ),
                                                          onPressed:
                                                              _currentPoId !=
                                                                  null
                                                              ? null
                                                              : () => _updateQty(
                                                                  productMap,
                                                                  -1,
                                                                ),
                                                          padding:
                                                              EdgeInsets.zero,
                                                          constraints:
                                                              const BoxConstraints(
                                                                minWidth: 32,
                                                                minHeight: 32,
                                                              ),
                                                        ),
                                                        Text(
                                                          '$qty',
                                                          style:
                                                              GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                            Icons.add,
                                                            size: 16,
                                                          ),
                                                          onPressed:
                                                              _currentPoId !=
                                                                  null
                                                              ? null
                                                              : () => _updateQty(
                                                                  productMap,
                                                                  1,
                                                                ),
                                                          padding:
                                                              EdgeInsets.zero,
                                                          constraints:
                                                              const BoxConstraints(
                                                                minWidth: 32,
                                                                minHeight: 32,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : (uoms.length > 1)
                                                ? PopupMenuButton<dynamic>(
                                                    tooltip:
                                                        'Select Unit to Add',
                                                    enabled:
                                                        _currentPoId == null,
                                                    onSelected: (u) {
                                                      _updateQty(
                                                        productMap,
                                                        1,
                                                        uom: u['name'],
                                                        factor:
                                                            (u['factor'] as num)
                                                                .toDouble(),
                                                        uoms: uoms,
                                                      );
                                                    },
                                                    itemBuilder: (context) => uoms
                                                        .map(
                                                          (u) => PopupMenuItem(
                                                            value: u,
                                                            child: Text(
                                                              "Add 1 ${u['name']}",
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                            vertical: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        "Add ▼",
                                                        style:
                                                            GoogleFonts.inter(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                    ),
                                                  )
                                                : ElevatedButton(
                                                    onPressed:
                                                        _currentPoId != null
                                                        ? null
                                                        : () => _updateQty(
                                                            productMap,
                                                            1,
                                                            uoms: uoms,
                                                          ),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.black,
                                                      foregroundColor:
                                                          Colors.white,
                                                      minimumSize: const Size(
                                                        60,
                                                        32,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Add',
                                                      style: GoogleFonts.inter(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewPane(bool isMobile) {
    // Calculate Totals for Preview
    final taxType = _getTaxType();
    final isInterState = taxType == 'IGST';
    double totalBase = 0;
    double totalTax = 0;
    double totalCess = 0;
    double grandTotal = 0;

    for (var item in _selectedItems) {
      final taxDetails = _calculateItemTax(item);
      totalBase += taxDetails['baseTotal']!;
      totalTax += taxDetails['taxAmount']!;
      totalCess += taxDetails['cessAmount']!;
      grandTotal += taxDetails['total']!;
    }

    return Column(
      children: [
        // Toolbar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isMobile)
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showPreviewMobile = false;
                    });
                  },
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('Back to Edit'),
                )
              else
                Text(
                  'Document Preview',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),

              Row(
                children: [
                  if (_currentPoId != null &&
                      (_status == 'Completed' ||
                          _status == 'Partially Received')) ...[
                    // GRN already exists
                    // GRN already exists
                    // GRN History Button (Handles Multiple GRNs)
                    GrnHistoryButton(
                      poId: _currentPoId!,
                      poNumber: _currentPoNumber,
                      vendor: _selectedVendor,
                    ),
                  ],
                  if (_currentPoId != null && _status != 'Completed') ...[
                    TextButton.icon(
                      onPressed: () async {
                        if (_selectedVendor == null || _selectedItems.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please select a vendor and items first.',
                              ),
                            ),
                          );
                          return;
                        }

                        if (_currentPoId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please SAVE the Purchase Order before creating a GRN.',
                              ),
                            ),
                          );
                          return;
                        }

                        // Use saved values
                        final poRef = _currentPoNumber;

                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GoodsReceiptScreen(
                              poId:
                                  _currentPoId!, // Must be saved to create GRN
                              poNumber:
                                  poRef, // Check if updating needs existing ref
                              vendor: {
                                'id': _selectedVendor!.id,
                                'name': _selectedVendor!.name,
                                'address': _selectedVendor!.address,
                                'gstin': _selectedVendor!.gstin,
                                'stateCode': _selectedVendor!.stateCode,
                              },
                              // items: _selectedItems, // We fetch from DB now
                            ),
                          ),
                        );

                        if (result != null && result is String) {
                          setState(() {
                            _status = result;
                          });
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'GRN Created Successfully! PO Marked Completed.',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.receipt_long, size: 16),
                      label: Text(
                        _status == 'Partially Received'
                            ? 'Receive Remaining'
                            : 'Create GRN',
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.teal.shade700,
                      ),
                    ),
                  ],
                  const SizedBox(width: 8),

                  // Save Button - only show for new POs
                  if (_currentPoId == null) ...[
                    IconButton(
                      onPressed: () async {
                        if (_selectedVendor == null || _selectedItems.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select vendor and items.'),
                            ),
                          );
                          return;
                        }

                        // Save Logic
                        try {
                          // Use existing ID or generate NEW and set it to state!
                          if (_currentPoId == null) {
                            setState(() {
                              _currentPoId = _uuid.v4();
                            });
                          }

                          final poId = _currentPoId!;
                          final poRef = _currentPoNumber;

                          // Calculate Total
                          double totalAmount = 0;
                          for (var item in _selectedItems) {
                            final details = _calculateItemTax(item);
                            totalAmount += details['total']!;
                          }

                          // Upsert PO
                          await _db
                              .into(_db.purchaseOrders)
                              .insertOnConflictUpdate(
                                PurchaseOrdersCompanion(
                                  id: Value(poId),
                                  poNumber: Value(poRef),
                                  vendorId: Value(_selectedVendor!.id),
                                  date: Value(DateTime.now()),
                                  status: const Value('Draft'),
                                  totalAmount: Value(totalAmount),
                                  // grnId: const Value(null),
                                  createdAt: Value(DateTime.now()),
                                  updatedAt: Value(DateTime.now()),
                                ),
                              );

                          // Delete existing items if updating (simplest strategy)
                          if (widget.existingOrderId != null) {
                            await (_db.delete(
                              _db.purchaseOrderItems,
                            )..where((tbl) => tbl.poId.equals(poId))).go();
                          }

                          // Insert Items
                          for (var item in _selectedItems) {
                            await _db
                                .into(_db.purchaseOrderItems)
                                .insert(
                                  PurchaseOrderItemsCompanion(
                                    poId: Value(poId),
                                    productId: Value(item['id']),
                                    quantity: Value(
                                      int.parse(item['qty'].toString()),
                                    ),
                                    unitPrice: Value(
                                      double.parse(item['price'].toString()),
                                    ),
                                    productName: Value(item['name']),
                                    uom: Value(item['uom']),
                                    conversionFactor: Value(
                                      double.tryParse(
                                            item['factor'].toString(),
                                          ) ??
                                          1.0,
                                    ),
                                    taxRate: Value(
                                      double.tryParse(
                                            item['taxRate'].toString(),
                                          ) ??
                                          0.0,
                                    ),
                                    cessRate: Value(
                                      double.tryParse(
                                            item['cess'].toString(),
                                          ) ??
                                          0.0,
                                    ),
                                  ),
                                );
                          }

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Purchase Order Saved!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            // Go back or stay?
                            // Navigator.pop(context);
                          }
                        } catch (e) {
                          debugPrint('Save Error: $e');
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error saving: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.save_outlined),
                      tooltip: 'Save',
                      color: Colors.black87,
                    ),
                  ],
                  // Read-only indicator for saved POs
                  if (_currentPoId != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 16,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'SAVED - READ ONLY',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  // Share Button (Share PDF)
                  IconButton(
                    onPressed: () async {
                      final pdfBytes = await _generatePdf(PdfPageFormat.a4);
                      final List<String> recipients = [];
                      if (_selectedVendor != null &&
                          (_selectedVendor?.email ?? '').isNotEmpty) {
                        recipients.add(_selectedVendor!.email!);
                      }

                      await Printing.sharePdf(
                        bytes: pdfBytes,
                        filename: 'purchase_order.pdf',
                        subject: 'Purchase Order from ${_company['name']}',
                        body: 'Please find attached the Purchase Order.',
                        emails: recipients,
                      );
                    },
                    icon: const Icon(Icons.email_outlined),
                    tooltip: 'Share PDF via Email',
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final pdfBytes = await _generatePdf(PdfPageFormat.a4);
                      await Printing.layoutPdf(
                        onLayout: (PdfPageFormat format) async => pdfBytes,
                      );
                    },
                    icon: const Icon(Icons.print, size: 18),
                    label: Text(
                      'Print / PDF',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Document Preview Area (Scrollable)
        Expanded(
          child: Container(
            color: const Color(0xFFD0D5DC),
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  width: 595, // A4 Width
                  constraints: const BoxConstraints(minHeight: 842),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Header (Minimalist)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Purchase Order',
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'PO Number #$_currentPoNumber',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                          // Placeholder Logo
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.teal.shade700,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.grid_view_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // 2. Parties
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'From (Supplier) :',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _selectedVendor != null
                                      ? _selectedVendor!.name
                                      : 'Select Vendor',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _selectedVendor != null
                                      ? _selectedVendor!.address
                                      : '',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (_selectedVendor != null) ...[
                                  Text(
                                    'GSTIN: ${_selectedVendor!.gstin}',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  Text(
                                    'State Code: ${_selectedVendor!.stateCode ?? "N/A"}',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ship To (Buyer) :',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _company['name'],
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _company['address'],
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'GSTIN: ${_company['gstin']}',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                Text(
                                  'State Code: ${_company['stateCode']}',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Dates
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date Issued :',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'January 01, 2026',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Due Date :',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'January 31, 2026',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Grid Header
                      Text(
                        'Order Details',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            _buildTableLabel('#', flex: 1), // Keep 1
                            _buildTableLabel(
                              'Items/Service',
                              flex: 3,
                            ), // Keep 3
                            _buildTableLabel('UOM', flex: 1), // Reduce to 1
                            _buildTableLabel('HSN', flex: 1), // Reduce to 1
                            _buildTableLabel(
                              'Qty',
                              flex: 1,
                              align: TextAlign.right,
                            ),
                            _buildTableLabel(
                              'Unit Price',
                              flex: 2,
                              align: TextAlign.right,
                            ),
                            _buildTableLabel(
                              'Tax',
                              flex: 2,
                              align: TextAlign.right,
                            ),
                            _buildTableLabel(
                              'Total',
                              flex: 2,
                              align: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      // Grid Rows
                      ..._selectedItems.asMap().entries.map((entry) {
                        final i = entry.key;
                        final item = entry.value;
                        final taxDetails = _calculateItemTax(item);
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: Row(
                            children: [
                              _buildTableValue('${i + 1}', flex: 1),

                              // Image Cell / Name
                              _buildTableValue(item['name'], flex: 3),

                              // UOM Display (Text Only)
                              _buildTableValue(item['uom'] ?? 'PCS', flex: 1),

                              _buildTableValue(
                                item['hsn'] ?? '-',
                                flex: 1,
                              ), // Reduce to 1
                              _buildTableValue(
                                item['qty'].toString(),
                                flex: 1,
                                align: TextAlign.right,
                              ),
                              _buildTableValue(
                                double.parse(
                                  item['price'].toString(),
                                ).toStringAsFixed(2),
                                flex: 2,
                                align: TextAlign.right,
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  taxDetails['cessRate']! > 0
                                      ? '${taxDetails['taxRate']}%\n(+${taxDetails['cessRate']}% Cess)'
                                      : '${taxDetails['taxRate']}%',
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              _buildTableValue(
                                taxDetails['total']!.toStringAsFixed(2),
                                flex: 2,
                                align: TextAlign.right,
                                isBold: true,
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 32),

                      // Footer
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Notes',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '• Include the PO number in the payment reference.',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Amount in Words:',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _amountToWords(grandTotal),
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 48),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                _buildSummaryRow('Subtotal', totalBase),
                                const SizedBox(height: 12),
                                if (isInterState)
                                  _buildSummaryRow('IGST', totalTax)
                                else ...[
                                  _buildSummaryRow('CGST', totalTax / 2),
                                  const SizedBox(height: 8),
                                  _buildSummaryRow('SGST', totalTax / 2),
                                ],
                                if (totalCess > 0) ...[
                                  const SizedBox(height: 8),
                                  _buildSummaryRow('Cess', totalCess),
                                ],
                                const SizedBox(height: 16),
                                const Divider(),
                                const SizedBox(height: 8),
                                _buildSummaryRow(
                                  'Grand Total',
                                  grandTotal,
                                  isBold: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Divider(color: Colors.grey.shade200),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _company['name'], // Replaced hardcoded name
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '(+91) 99887 76655', // Hardcoded as fallback or standard
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableLabel(
    String text, {
    required int flex,
    TextAlign align = TextAlign.left,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildTableValue(
    String text, {
    required int flex,
    TextAlign align = TextAlign.left,
    bool isBold = false,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            color: isBold ? Colors.black : Colors.grey.shade600,
          ),
        ),
        Text(
          'Rs. ${amount.toStringAsFixed(2)}',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // --- Tax Logic Helpers ---

  String _getTaxType() {
    if (_selectedVendor == null) return 'IGST';
    final vendorState = _selectedVendor!.stateCode;
    final companyState = _company['stateCode'];
    return (vendorState == companyState) ? 'CGST_SGST' : 'IGST';
  }

  Map<String, double> _calculateItemTax(Map<String, dynamic> item) {
    final qty = int.tryParse(item['qty'].toString()) ?? 1;
    final baseRate = double.tryParse(item['price'].toString()) ?? 0.0;
    final taxRate =
        double.tryParse(item['taxRate'].toString()) ?? 18.0; // Default
    final cessPercent = double.tryParse(item['cess'].toString()) ?? 0.0;

    final baseTotal = baseRate * qty;
    final taxAmount = baseTotal * (taxRate / 100);
    final cessAmount = baseTotal * (cessPercent / 100);
    final total = baseTotal + taxAmount + cessAmount;

    return {
      'baseTotal': baseTotal,
      'taxAmount': taxAmount,
      'cessAmount': cessAmount,
      'total': total,
      'taxRate': taxRate,
      'cessRate': cessPercent,
    };
  }

  // Simple Number to Words Converter (Tens/Thousands/Lakhs simplified for general usage)
  String _amountToWords(double amount) {
    if (amount == 0) return 'Zero Only';
    final units = [
      "",
      "One",
      "Two",
      "Three",
      "Four",
      "Five",
      "Six",
      "Seven",
      "Eight",
      "Nine",
      "Ten",
      "Eleven",
      "Twelve",
      "Thirteen",
      "Fourteen",
      "Fifteen",
      "Sixteen",
      "Seventeen",
      "Eighteen",
      "Nineteen",
    ];
    final tens = [
      "",
      "",
      "Twenty",
      "Thirty",
      "Forty",
      "Fifty",
      "Sixty",
      "Seventy",
      "Eighty",
      "Ninety",
    ];

    String convert(int n) {
      if (n < 20) return units[n];
      if (n < 100) return "${tens[n ~/ 10]} ${units[n % 10]}";
      if (n < 1000) return "${units[n ~/ 100]} Hundred ${convert(n % 100)}";
      if (n < 100000)
        return "${convert(n ~/ 1000)} Thousand ${convert(n % 1000)}";
      if (n < 10000000)
        return "${convert(n ~/ 100000)} Lakh ${convert(n % 100000)}";
      return "${convert(n ~/ 10000000)} Crore ${convert(n % 10000000)}";
    }

    final intPart = amount.toInt();
    // Handling decimals simply for "Only"
    return "Rupees ${convert(intPart)} Only"
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /* double _calculateTotal() {
    return _selectedItems.fold<double>(0, (sum, item) {
      final price = double.tryParse(item['price'].toString()) ?? 0.0;
      final qty = int.tryParse(item['qty'].toString()) ?? 1;
      return sum + (price * qty);
    });
  } */

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    final taxType = _getTaxType();
    final isInterState = taxType == 'IGST';

    // Calculate Totals for Footer
    double totalBase = 0;
    double totalTax = 0;
    double totalCess = 0;
    double grandTotal = 0;

    for (var i = 0; i < _selectedItems.length; i++) {
      final item = _selectedItems[i];
      final taxDetails = _calculateItemTax(item);
      totalBase += taxDetails['baseTotal']!;
      totalTax += taxDetails['taxAmount']!;
      totalCess += taxDetails['cessAmount']!;
      grandTotal += taxDetails['total']!;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        build: (pw.Context context) => [
          // 1. Header Section
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'PURCHASE ORDER',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Status: $_status',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey600,
                    ),
                  ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'PO No: PO-2026-001',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text('Date: 01-Jan-2026'),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          // Vendor & Ship To
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Vendor (Left)
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'To (Supplier):',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      _selectedVendor != null
                          ? _selectedVendor!.name
                          : 'Select Vendor',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      _selectedVendor != null ? _selectedVendor!.address : '',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'GSTIN: ${_selectedVendor?.gstin ?? 'N/A'}',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'State Code: ${_selectedVendor?.stateCode ?? 'N/A'}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              // Ship To (Right)
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Ship To (Buyer):',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      _company['name'],
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      _company['address'],
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'GSTIN: ${_company['gstin']}',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'State Code: ${_company['stateCode']}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 24),

          // 2. The Item Grid (Minimalist)
          pw.Text(
            'Order Details',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),

          // Header
          pw.Row(
            children: [
              pw.Expanded(
                flex: 1,
                child: pw.Text(
                  '#',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Expanded(
                flex: 4,
                child: pw.Text(
                  'Items/Service',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Text(
                  'HSN',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Text(
                  'Qty',
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Text(
                  'Unit Price',
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Text(
                  'Tax',
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Text(
                  'Total',
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          pw.Divider(color: PdfColors.grey200),

          // Table Rows
          ..._selectedItems.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            final taxDetails = _calculateItemTax(item);

            return pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 8),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: PdfColors.grey200),
                ),
              ),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text(
                      '${i + 1}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                  pw.Expanded(
                    flex: 4,
                    child: pw.Text(
                      item['name'],
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      item['hsn'] ?? '-',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text(
                      item['qty'].toString(),
                      textAlign: pw.TextAlign.right,
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      double.parse(item['price'].toString()).toStringAsFixed(2),
                      textAlign: pw.TextAlign.right,
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      taxDetails['cessRate']! > 0
                          ? '${taxDetails['taxRate']}%\n(+${taxDetails['cessRate']}% Cess)'
                          : '${taxDetails['taxRate']}%',
                      textAlign: pw.TextAlign.right,
                      style: const pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      taxDetails['total']!.toStringAsFixed(2),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          pw.SizedBox(height: 24),

          // 3. Footer Summary
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Notes (Left)
              pw.Expanded(
                flex: 3,
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey50,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Notes',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        '• Include the PO number in the payment reference.',
                        style: const pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.grey700,
                        ),
                      ),
                      pw.SizedBox(height: 12),
                      pw.Text(
                        'Amount in Words:',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        _amountToWords(grandTotal),
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontStyle: pw.FontStyle.italic,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(width: 32),
              // Totals (Right)
              pw.Expanded(
                flex: 2,
                child: pw.Column(
                  children: [
                    _buildPdfSummaryRow('Subtotal', totalBase),
                    pw.SizedBox(height: 8),
                    if (isInterState)
                      _buildPdfSummaryRow('IGST', totalTax)
                    else ...[
                      _buildPdfSummaryRow('CGST', totalTax / 2),
                      pw.SizedBox(height: 4),
                      _buildPdfSummaryRow('SGST', totalTax / 2),
                    ],
                    if (totalCess > 0) ...[
                      pw.SizedBox(height: 4),
                      _buildPdfSummaryRow('Cess', totalCess),
                    ],
                    pw.SizedBox(height: 8),
                    pw.Divider(color: PdfColors.grey300),
                    pw.SizedBox(height: 4),
                    _buildPdfSummaryRow(
                      'Grand Total',
                      grandTotal,
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 40),
          pw.Divider(color: PdfColors.grey200),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Jiyalal Stores, IND',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                '(+91) 99887 76655',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
        ], // End of MultiPage List
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildPdfSummaryRow(
    String label,
    double amount, {
    bool isBold = false,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
        pw.Text(
          'Rs. ${amount.toStringAsFixed(2)}',
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _QuantitySelector extends StatefulWidget {
  final int qty;
  final ValueChanged<int> onChanged;

  const _QuantitySelector({required this.qty, required this.onChanged});

  @override
  State<_QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<_QuantitySelector> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.qty.toString());
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(_QuantitySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.qty != oldWidget.qty && !_focusNode.hasFocus) {
      _controller.text = widget.qty.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      // Restore valid quantity if left empty or 0
      if (_controller.text.isEmpty || int.tryParse(_controller.text) == 0) {
        _controller.text = widget.qty.toString();
      } else {
        final val = int.tryParse(_controller.text);
        if (val != null && val != widget.qty) {
          widget.onChanged(val);
        }
      }
    }
  }

  void _handleSubmitted(String value) {
    final val = int.tryParse(value);
    if (val != null && val > 0) {
      widget.onChanged(val);
    } else {
      // invalid, reset
      _controller.text = widget.qty.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => widget.onChanged(widget.qty - 1),
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: const Icon(Icons.remove, size: 16, color: Colors.black),
            ),
          ),
          SizedBox(
            width: 30, // Fixed width for number
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              onSubmitted: _handleSubmitted,
              onChanged: (val) {
                // Optional: live update if desired, but might be jumpy.
                // Let's stick to onSubmitted or focus lost for state sync,
                // OR we can try live update if careful.
                // For now, let's wait for submit/blur to commit to parent to avoid cursor jumping.
              },
            ),
          ),
          InkWell(
            onTap: () => widget.onChanged(widget.qty + 1),
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: const Icon(Icons.add, size: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
