import 'package:flutter/material.dart';
import '../utils/image_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' hide Column;

import 'package:retailsaas/widgets/cart_sidebar.dart';
import 'package:retailsaas/data/database/app_database.dart';
import 'package:retailsaas/locator.dart';
import '../widgets/product_card.dart';
import '../models/product_inventory_view.dart';
import 'order_success_screen.dart';

class ReturnsScreen extends StatefulWidget {
  const ReturnsScreen({super.key});

  @override
  State<ReturnsScreen> createState() => _ReturnsScreenState();
}

class _ReturnsScreenState extends State<ReturnsScreen> {
  final _db = getIt<AppDatabase>();
  final List<CartItem> returnItems = [];
  String _searchQuery = '';
  bool _isSwapMode = false;

  Future<void> _addToReturns(
    Product product, {
    int quantity = 1,
    double? soldLimit,
  }) async {
    // 1. Determine Type
    String type = 'Return'; // Default
    if (_isSwapMode) {
      // Direct Swap: 1 IN, 1 OUT
      type = 'Swap';
    }

    // Validation: Check Sold Limit
    if (soldLimit != null) {
      // Calculate how many we already have for this product (IN/Return side)
      // Note: In Swap mode, 'Swap' items also count as IN (Return of broken item)
      final currentInCart = returnItems
          .where(
            (i) =>
                i.product.id == product.id &&
                (i.type == 'Return' || i.type == 'Swap'),
          )
          .fold(0, (sum, i) => sum + i.quantity);

      if ((currentInCart + quantity) > soldLimit) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Cannot return more than sold quantity (${soldLimit.toStringAsFixed(0)})',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
    }

    // Determine Batch
    final batches = await (_db.select(
      _db.productBatches,
    )..where((t) => t.productId.equals(product.id))).get();

    // Validate Stock for Sale/Swap
    if (batches.isEmpty && (type == 'Sale' || type == 'Swap')) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No stock found for replacement!')),
        );
      }
      return;
    }

    ProductBatch? batch;
    if (batches.isNotEmpty) {
      // Prioritize Good Batch with Stock
      batch = batches.firstWhere(
        (b) => !b.isDamaged && b.stockQty > 0,
        orElse: () => batches.isNotEmpty ? batches.last : batches.first,
      );
    } else {
      // Only happens if type == 'Return' and no batches exist.
      // We need a dummy or handle it.
      if (type == 'Return') {
        // Return logic can proceed without a specific batch or create one later
        // But CartItem requires a batch. If absolutely no batch exists, we can't add to cart.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product has no batches! Initialize stock first.'),
            ),
          );
        }
        return;
      }
    }

    setState(() {
      final existingIndex = returnItems.indexWhere(
        (item) =>
            item.product.id == product.id &&
            item.batch.id == batch!.id &&
            item.type == type,
      );

      if (existingIndex != -1) {
        returnItems[existingIndex].quantity += quantity;
      } else {
        returnItems.add(
          CartItem(
            product: product,
            batch: batch!,
            quantity: quantity,
            type: type, // 'Swap' or 'Return' or 'Sale'
          ),
        );
      }
    });
  }

  void _removeReturnItem(CartItem item) {
    setState(() {
      returnItems.removeWhere(
        (i) =>
            i.product.id == item.product.id &&
            i.batch.id == item.batch.id &&
            i.type == item.type,
      );
    });
  }

  double _calculateNetTotal() {
    double sum = 0;
    for (var item in returnItems) {
      if (item.type == 'Return') {
        sum -= item.total;
      } else {
        sum += item.total;
      }
    }
    return sum;
  }

  Future<void> _processTransaction() async {
    if (returnItems.isEmpty) return;

    double netTotal = _calculateNetTotal(); // Swaps should be 0

    try {
      await _db.transaction(() async {
        final billId = const Uuid().v4();

        // 1. Create SalesBill
        await _db
            .into(_db.salesBills)
            .insert(
              SalesBillsCompanion(
                id: Value(billId),
                date: Value(DateTime.now()),
                customerName: const Value('Warranty Swap'),
                grandTotal: Value(netTotal),
                paymentStatus: const Value('PAID'),
              ),
            );

        // 2. Process Items
        for (var item in returnItems) {
          if (item.type == 'Swap') {
            // --- HANDLE SWAP (Both Return & Replacement) ---

            // A. IN (Return Damaged)
            await _processReturnItem(item, billId, isSwapComponent: true);

            // B. OUT (Replacement New)
            await _processSaleItem(item, billId, isSwapComponent: true);
          } else if (item.type == 'Return') {
            await _processReturnItem(item, billId);
          } else {
            // 'Sale' or default
            await _processSaleItem(item, billId);
          }
        }

        // 3. Ledger (If Value != 0)
        if (netTotal != 0) {
          await _db.recordLedgerEntry(
            GeneralLedgerCompanion(
              id: Value(const Uuid().v4()),
              date: Value(DateTime.now()),
              type: const Value('SALE'),
              description: const Value('Warranty Swap / Return'),
              credit: Value(netTotal > 0 ? netTotal : 0),
              debit: Value(netTotal < 0 ? -netTotal : 0),
              referenceId: Value(billId),
              referenceTable: const Value('sales_bills'),
            ),
          );
        }

        if (mounted) {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => OrderSuccessScreen(
                    animationPath: 'assets/animations/order_packed.json',
                    loopAnimation: false,
                    title: _isSwapMode
                        ? 'Swap Successful'
                        : 'Return Successful',
                    subtitle: _isSwapMode
                        ? 'Stock adjusted & Bill Generated.'
                        : 'Items added back to inventory.',
                    buttonText: 'Back to Dashboard',
                    billId: billId, // Enable Printing
                    onBackToPos: () {},
                  ),
                ),
              )
              .then((_) {
                if (mounted) {
                  setState(() {
                    returnItems.clear();
                  });
                }
              });
        }
      });
    } catch (e, stack) {
      debugPrint('Error processing transaction: $e\n$stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // Helper to process IN (Return) logic
  Future<void> _processReturnItem(
    CartItem item,
    String billId, {
    bool isSwapComponent = false,
  }) async {
    final qty =
        -item.quantity; // Negative quantity for BillItem (meaning Return)

    // For Swap Asset Transfer: Rate = 0, Total = 0
    final double price = isSwapComponent ? 0.0 : item.unitPrice;
    final double tax = isSwapComponent ? 0.0 : -item.taxAmount;
    final double total = isSwapComponent ? 0.0 : -item.total;

    // A. Insert Bill Item (Return Entry)
    await _db
        .into(_db.billItems)
        .insert(
          BillItemsCompanion(
            id: Value(const Uuid().v4()),
            billId: Value(billId),
            productId: Value(item.product.id),
            productName: Value(
              isSwapComponent
                  ? '${item.product.name} (Return)'
                  : item.product.name,
            ),
            hsnCode: Value(item.product.hsnCode),
            quantity: Value(qty.toDouble()),
            unitPrice: Value(price),
            taxRate: Value(item.product.gstRate),
            cessRate: Value(item.product.cessRate),
            taxAmount: Value(tax),
            totalAmount: Value(total),
            // No warranty extension on the returned item
            warrantyEndDate: const Value(null),
          ),
        );

    // B. Stock Update (IN -> Damaged Batch)
    final damagedBatch =
        await (_db.select(_db.productBatches)..where(
              (t) =>
                  t.productId.equals(item.product.id) &
                  t.isDamaged.equals(true),
            ))
            .getSingleOrNull();

    String targetBatchId;
    if (damagedBatch != null) {
      // Update existing
      targetBatchId = damagedBatch.id;
      await (_db.update(
        _db.productBatches,
      )..where((t) => t.id.equals(damagedBatch.id))).write(
        ProductBatchesCompanion(
          stockQty: Value(damagedBatch.stockQty + item.quantity),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      // Create New 'Damaged' Batch
      targetBatchId = const Uuid().v4();
      await _db
          .into(_db.productBatches)
          .insert(
            ProductBatchesCompanion(
              id: Value(targetBatchId),
              productId: Value(item.product.id),
              mrp: Value(item.batch.mrp),
              sellingPrice: Value(item.batch.sellingPrice),
              purchaseRate: Value(item.batch.purchaseRate),
              stockQty: Value(item.quantity.toDouble()),
              batchNumber: const Value('RMA-BIN'),
              isDamaged: const Value(true),
              createdAt: Value(DateTime.now()),
            ),
          );
    }

    // Record Transaction
    await _db
        .into(_db.productTransactions)
        .insert(
          ProductTransactionsCompanion(
            id: Value(const Uuid().v4()),
            productId: Value(item.product.id),
            type: const Value('Return'),
            quantity: Value(item.quantity.toDouble()), // Positive (IN)
            price: Value(price),
            totalAmount: Value(total),
            date: Value(DateTime.now()),
            orderId: Value(billId),
            batchId: Value(targetBatchId),
            location: const Value('RMA_BIN'),
          ),
        );
  }

  // Helper to process OUT (Sale/Replacement) logic
  Future<void> _processSaleItem(
    CartItem item,
    String billId, {
    bool isSwapComponent = false,
  }) async {
    // For Swap Asset Transfer: Rate = 0, Total = 0
    final double price = isSwapComponent ? 0.0 : item.unitPrice;
    final double tax = isSwapComponent ? 0.0 : item.taxAmount;
    final double total = isSwapComponent ? 0.0 : item.total;

    // A. Insert Bill Item (Sale Entry)
    await _db
        .into(_db.billItems)
        .insert(
          BillItemsCompanion(
            id: Value(const Uuid().v4()),
            billId: Value(billId),
            productId: Value(item.product.id),
            productName: Value(
              isSwapComponent
                  ? '${item.product.name} (Replacement)'
                  : item.product.name,
            ),
            hsnCode: Value(item.product.hsnCode),
            quantity: Value(item.quantity.toDouble()),
            unitPrice: Value(price),
            taxRate: Value(item.product.gstRate),
            cessRate: Value(item.product.cessRate),
            taxAmount: Value(tax),
            totalAmount: Value(total),
            // Warranty Extension? Yes, if policy exists.
            warrantyEndDate: item.product.warrantyMonths > 0
                ? Value(
                    DateTime.now().add(
                      Duration(days: item.product.warrantyMonths * 30),
                    ),
                  )
                : const Value(null),
          ),
        );

    // B. Stock Update (OUT -> From Good Batch)
    final currentBatch = await (_db.select(
      _db.productBatches,
    )..where((t) => t.id.equals(item.batch.id))).getSingle();

    final newQty = currentBatch.stockQty - item.quantity;
    await (_db.update(
      _db.productBatches,
    )..where((t) => t.id.equals(item.batch.id))).write(
      ProductBatchesCompanion(
        stockQty: Value(newQty),
        updatedAt: Value(DateTime.now()),
      ),
    );

    // Record Transaction
    await _db
        .into(_db.productTransactions)
        .insert(
          ProductTransactionsCompanion(
            id: Value(const Uuid().v4()),
            productId: Value(item.product.id),
            type: const Value('Replacement'), // Or Sale
            quantity: Value(item.quantity.toDouble()),
            price: Value(price),
            totalAmount: Value(total),
            date: Value(DateTime.now()),
            orderId: Value(billId),
            batchId: Value(item.batch.id),
            location: const Value('SHOP_FLOOR'),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1400;
        final crossAxisCount = constraints.maxWidth < 700
            ? 1
            : constraints.maxWidth < 1200
            ? 2
            : 3;

        final double padding = 48.0;
        final double spacing = 16.0;
        final double availableWidth = constraints.maxWidth - padding;
        final double itemWidth =
            (availableWidth - (crossAxisCount - 1) * spacing) / crossAxisCount;

        final double desiredHeight = (itemWidth / 1.4) + 240;
        final double childAspectRatio = itemWidth / desiredHeight;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F7), // Light grey background
          endDrawer: !isDesktop
              ? Drawer(
                  width: 350,
                  backgroundColor: Colors.white,
                  child: _buildReturnsSidebar(),
                )
              : null,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side - Product Grid
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildHeader(isDesktop: isDesktop),
                        _buildSortBar(),
                        Expanded(
                          child: StreamBuilder<List<Product>>(
                            stream: _db.select(_db.products).watch(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              }
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              final allProducts = snapshot.data!;
                              final products = _searchQuery.isEmpty
                                  ? allProducts
                                        .where(
                                          (p) =>
                                              !_isSwapMode ||
                                              p.warrantyMonths > 0,
                                        )
                                        .toList()
                                  : allProducts
                                        .where(
                                          (p) =>
                                              (_isSwapMode
                                                  ? p.warrantyMonths > 0
                                                  : true) &&
                                              p.name.toLowerCase().contains(
                                                _searchQuery.toLowerCase(),
                                              ),
                                        )
                                        .toList();

                              if (products.isEmpty) {
                                return const Center(
                                  child: Text('No products found'),
                                );
                              }

                              return StreamBuilder<List<ProductBatch>>(
                                stream: _db.select(_db.productBatches).watch(),
                                builder: (context, batchSnapshot) {
                                  if (!batchSnapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  final allBatches = batchSnapshot.data!;

                                  return StreamBuilder<Map<String, double>>(
                                    stream: _db.watchSoldQuantities(),
                                    builder: (context, soldSnapshot) {
                                      final soldMap = soldSnapshot.data ?? {};

                                      // Dynamic Filtering: Hide items if swapped out
                                      final displayProducts = products.where((
                                        product,
                                      ) {
                                        if (!_isSwapMode) return true;

                                        final soldQty =
                                            soldMap[product.id] ?? 0.0;
                                        if (soldQty <= 0) return false;

                                        final currentInCart = returnItems
                                            .where(
                                              (i) =>
                                                  i.product.id == product.id &&
                                                  (i.type == 'Return' ||
                                                      i.type == 'Swap'),
                                            )
                                            .fold(
                                              0,
                                              (sum, i) => sum + i.quantity,
                                            );

                                        return (soldQty - currentInCart) > 0;
                                      }).toList();

                                      if (displayProducts.isEmpty) {
                                        return const Center(
                                          child: Text(
                                            'No eligible products found.',
                                          ),
                                        );
                                      }

                                      return Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: crossAxisCount,
                                                childAspectRatio:
                                                    childAspectRatio,
                                                crossAxisSpacing: 16,
                                                mainAxisSpacing: 16,
                                              ),
                                          itemCount: displayProducts.length,
                                          itemBuilder: (context, index) {
                                            final product =
                                                displayProducts[index];
                                            final soldQty =
                                                soldMap[product.id] ?? 0.0;

                                            // Calculate remaining warranty (Active - InCart)
                                            final currentInCart = returnItems
                                                .where(
                                                  (i) =>
                                                      i.product.id ==
                                                          product.id &&
                                                      (i.type == 'Return' ||
                                                          i.type == 'Swap'),
                                                )
                                                .fold(
                                                  0,
                                                  (sum, i) => sum + i.quantity,
                                                );

                                            final remainingWarranty =
                                                soldQty - currentInCart;

                                            // 1. Filter Good Batches Only for "Stock" Display
                                            final productBatches = allBatches
                                                .where(
                                                  (b) =>
                                                      b.productId ==
                                                          product.id &&
                                                      !b.isDamaged, // Filter out damaged
                                                )
                                                .toList();

                                            return ProductCard(
                                              allowZeroStock: true,
                                              item: ProductInventoryView(
                                                product: product,
                                                batches: productBatches,
                                                soldQty:
                                                    remainingWarranty, // Valid for display
                                              ),
                                              onAdd: (qty) => _addToReturns(
                                                product,
                                                quantity: qty,
                                                soldLimit:
                                                    soldQty, // Valid for limit
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Right Side - Returns Sidebar (Desktop Only)
                if (isDesktop) ...[
                  const SizedBox(width: 16),
                  Container(
                    width: 380,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: _buildReturnsSidebar(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader({required bool isDesktop}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Returns & Warranty',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      _isSwapMode
                          ? 'Process warranty swaps (Broken IN, New OUT)'
                          : 'Select products to return to inventory',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // Swap Toggle
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _buildModeButton('Return Only', false),
                    _buildModeButton('Warranty Swap', true),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isDesktop) ...[
            Row(
              children: [
                // Search Bar
                Container(
                  width: 250,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Search Returns',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(top: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Filter', style: GoogleFonts.inter()),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {},
                ),
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: Badge(
                        label: Text('${returnItems.length}'),
                        isLabelVisible: returnItems.isNotEmpty,
                        child: const Icon(Icons.shopping_cart_outlined),
                      ),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModeButton(String label, bool isSwap) {
    final isSelected = _isSwapMode == isSwap;
    return InkWell(
      onTap: () {
        if (_isSwapMode != isSwap) {
          setState(() {
            _isSwapMode = isSwap;
            returnItems.clear(); // Clear items when switching modes
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.black : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildSortBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Short By',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnsSidebar() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Returning Items',
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Text(
            'Details of returned products',
            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Text(
            '${returnItems.length} Items Selected',
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: returnItems.isEmpty
                ? Center(
                    child: Text(
                      'No items selected for return',
                      style: GoogleFonts.inter(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    itemCount: returnItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _ReturnItemWidget(
                        item: returnItems[index],
                        onRemove: () => _removeReturnItem(returnItems[index]),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Net Total:',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
              Text(
                'Rs. ${_calculateNetTotal().toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: _calculateNetTotal() == 0
                      ? Colors.green
                      : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _processTransaction();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _isSwapMode ? 'Process Swap [F12]' : 'Process Return',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReturnItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;

  const _ReturnItemWidget({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    // Style based on type
    final isReturn = item.type == 'Return';
    final isSwap = item.type == 'Swap';

    final bgColor = isSwap
        ? Colors.blue.shade50
        : (isReturn ? Colors.red.shade50 : Colors.green.shade50);
    final borderColor = isSwap
        ? Colors.blue.shade200
        : (isReturn ? Colors.red.shade200 : Colors.green.shade200);
    final label = isSwap
        ? 'Warranty Swap'
        : (isReturn ? 'IN (Return)' : 'OUT (Sale)');
    final labelColor = isSwap
        ? Colors.blue.shade700
        : (isReturn ? Colors.red.shade700 : Colors.green.shade700);

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  image: item.product.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(item.product.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: item.product.imageUrl == null
                    ? const Icon(Icons.image, size: 24, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 24.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: borderColor),
                            ),
                            child: Text(
                              label,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: labelColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.product.name,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Qty Display
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Qty: ${item.quantity}',
                            style: GoogleFonts.inter(fontSize: 12),
                          ),
                        ),
                        // Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              isReturn
                                  ? '- Rs. ${item.total.toStringAsFixed(2)}'
                                  : 'Rs. ${item.total.toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: labelColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Close Button
        Positioned(
          top: 8,
          right: 8,
          child: InkWell(
            onTap: onRemove,
            child: Icon(Icons.cancel_outlined, size: 20, color: labelColor),
          ),
        ),
      ],
    );
  }
}
