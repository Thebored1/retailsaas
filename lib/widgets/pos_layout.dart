import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retailsaas/data/database/app_database.dart';
import 'package:retailsaas/locator.dart';
import 'package:retailsaas/services/auth_service.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:uuid/uuid.dart';
import '../models/payment_split.dart';
import '../models/product_inventory_view.dart';
import '../widgets/product_card.dart';
import '../widgets/cart_sidebar.dart';
import '../screens/order_success_screen.dart';

class PosContent extends StatefulWidget {
  final String title;
  final String successAnimationPath;
  final bool successAnimationLoop;
  final String successButtonText;

  const PosContent({
    super.key,
    required this.title,
    required this.successAnimationPath,
    this.successAnimationLoop = true,
    this.successButtonText = 'Back to POS',
  });

  @override
  State<PosContent> createState() => _PosContentState();
}

class _PosContentState extends State<PosContent> {
  final _db = getIt<AppDatabase>();
  final List<CartItem> cartItems = [];
  String _searchQuery = '';
  final GlobalKey _cartSidebarKey = GlobalKey();
  bool _isSearchVisibleMobile = false;

  // Hoisted Payment State
  final List<PaymentSplit> _splits = [];
  final List<String> _paymentModes = ['CASH', 'UPI', 'CARD', 'CREDIT'];

  // Stream for Inventory View
  late Stream<List<ProductInventoryView>> _inventoryStream;

  @override
  void initState() {
    super.initState();
    _setupStream();
  }

  void _setupStream() {
    // Only Active Products
    final query = _db.select(_db.products).join([
      leftOuterJoin(
        _db.productBatches,
        _db.productBatches.productId.equalsExp(_db.products.id),
      ),
    ]);
    query.where(_db.products.isActive.equals(true));

    _inventoryStream = query.watch().map((rows) {
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
        if (batch != null && batch.stockQty > 0) {
          // Only show batches with stock in POS? Or show all?
          // Let's show all, but filter 0 stock in selection if needed.
          // Actually POS should filter 0 stock batches usually, but maybe we want to sell into negative?
          // For now, let's include all batches.
          grouped[product.id]!.batches.add(batch);
        }
      }
      return grouped.values.toList();
    });
  }

  // --- Payment Logic Hoisted --- (Same as before)
  void _initializeSplits(double total) {
    if (_splits.isEmpty && total > 0) {
      setState(() {
        _splits.add(PaymentSplit(mode: 'CASH', amount: total));
      });
    }
  }

  void _syncSingleSplit(double total) {
    if (_splits.isEmpty) {
      if (total > 0) _initializeSplits(total);
    } else if (_splits.length == 1) {
      setState(() {
        _splits[0].amount = total;
      });
    }
  }

  void _addSplit(double amount) {
    String nextMode = _paymentModes.firstWhere(
      (m) => !_splits.any((s) => s.mode == m),
      orElse: () => 'UPI',
    );
    setState(() {
      _splits.add(PaymentSplit(mode: nextMode, amount: amount));
    });
  }

  void _removeSplit(int index) {
    if (_splits.length <= 1) return;
    setState(() {
      _splits.removeAt(index);
    });
  }

  void _updateSplit(int index, double newAmount, {String? mode}) {
    setState(() {
      if (mode != null) _splits[index].mode = mode;
      if (newAmount != _splits[index].amount) {
        _splits[index].amount = newAmount;
        // Reverse Logic
        final totalPaid = _splits.fold(0.0, (sum, item) => sum + item.amount);
        final cartTotal = cartItems.fold(0.0, (sum, item) => sum + item.total);
        if (totalPaid > cartTotal + 0.01) {
          double excess = totalPaid - cartTotal;
          for (int i = 0; i < _splits.length; i++) {
            if (i == index) continue;
            if (excess <= 0.01) break;
            if (_splits[i].amount > 0) {
              double deduction = excess;
              if (_splits[i].amount < deduction) deduction = _splits[i].amount;
              _splits[i].amount -= deduction;
              excess -= deduction;
            }
          }
        }
      }
    });
  }
  // -----------------------------

  void _onProductAdd(ProductInventoryView item, int quantity) {
    if (item.batches.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No stock available!')));
      return;
    }

    // Filter batches with stock
    final availableBatches = item.batches.where((b) => b.stockQty > 0).toList();

    if (availableBatches.isEmpty) {
      // Allow selling if user insists? Or just block?
      // Let's block for now to be safe, or show all batches if we allow negative.
      // Given earlier prompt "One Product Many Prices", implicit requirement is handling selection.
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Out of Stock!')));
      return;
    }

    if (availableBatches.length == 1) {
      _addToCart(item.product, availableBatches.first, quantity: quantity);
    } else {
      _showBatchSelectionDialog(item.product, availableBatches, quantity);
    }
  }

  void _showBatchSelectionDialog(
    Product product,
    List<ProductBatch> batches,
    int initialQty,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Batch',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          product.name,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Batch List
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: batches.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final batch = batches[index];
                    return _BatchSelectionRow(
                      batch: batch,
                      initialQty: initialQty,
                      onAdd: (qty) {
                        Navigator.pop(context);
                        _addToCart(product, batch, quantity: qty);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DateTime? _calculateExpiry(DateTime saleDate, int months) {
    if (months <= 0) return null;
    return DateTime(saleDate.year, saleDate.month + months, saleDate.day);
  }

  void _addToCart(Product product, ProductBatch batch, {int quantity = 1}) {
    // Calculate current quantity of this batch in cart
    final existingIndex = cartItems.indexWhere(
      (item) => item.product.id == product.id && item.batch.id == batch.id,
    );

    int currentCartQty = 0;
    if (existingIndex != -1) {
      currentCartQty = cartItems[existingIndex].quantity;
    }

    // Check if adding exceeds stock
    if (currentCartQty + quantity > batch.stockQty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cannot add $quantity. Only ${batch.stockQty - currentCartQty} more available in this batch!',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      if (existingIndex != -1) {
        cartItems[existingIndex].quantity += quantity;
      } else {
        cartItems.add(
          CartItem(
            product: product,
            batch: batch,
            quantity: quantity,
            warrantyEnd: _calculateExpiry(
              DateTime.now(),
              product.warrantyMonths,
            ),
          ),
        );
      }

      final total = cartItems.fold(0.0, (sum, item) => sum + item.total);
      _syncSingleSplit(total);
    });
  }

  void _removeItem(CartItem item) {
    setState(() {
      cartItems.removeWhere(
        (i) => i.product.id == item.product.id && i.batch.id == item.batch.id,
      );
      final total = cartItems.fold(0.0, (sum, item) => sum + item.total);
      _syncSingleSplit(total);
    });
  }

  Future<void> _processSale(
    List<PaymentSplit> splits,
    double totalAmount,
  ) async {
    final billId = const Uuid().v4();

    try {
      await _db.transaction(() async {
        final userId = getIt<AuthService>().currentUser.value?.id;

        // 1. Create SalesBill
        await _db
            .into(_db.salesBills)
            .insert(
              SalesBillsCompanion(
                id: Value(billId),
                date: Value(DateTime.now()),
                customerName: const Value('Walk-in Customer'),
                grandTotal: Value(totalAmount),
                paymentStatus: const Value('PAID'),
                userId: Value(userId),
              ),
            );

        // Audit Log
        getIt<AuthService>().logAction(
          'POS_SALE',
          tableName: 'sales_bills',
          recordId: billId,
          details: 'Sale created for ₹$totalAmount',
        );

        // 2. Create BillItems (Snapshot with Warranty)
        for (var item in cartItems) {
          await _db
              .into(_db.billItems)
              .insert(
                  BillItemsCompanion(
                    id: Value(const Uuid().v4()),
                    billId: Value(billId),
                    productId: Value(item.product.id),
                    productName: Value(item.product.name),
                    hsnCode: Value(item.product.hsnCode),
                    quantity: Value(item.quantity.toDouble()),
                    unitPrice: Value(item.unitPrice),
                    taxRate: Value(item.product.gstRate),
                    cessRate: Value(item.product.cessRate),
                    taxAmount: Value(item.taxAmount),
                    totalAmount: Value(item.total),
                    warrantyEndDate: Value(item.warrantyEnd),
                  ),
              );
        }

        // 3. Create BillPayments
        for (var split in splits) {
          await _db
              .into(_db.billPayments)
              .insert(
                BillPaymentsCompanion(
                  id: Value(const Uuid().v4()),
                  billId: Value(billId),
                  paymentMode: Value(split.mode),
                  amount: Value(split.amount),
                  referenceNo: Value(split.reference),
                ),
              );
        }

        // 3. Create ProductTransactions & Update Stock
        for (var item in cartItems) {
          final transactionId = const Uuid().v4();

          await _db
              .into(_db.productTransactions)
              .insert(
                ProductTransactionsCompanion(
                  id: Value(transactionId),
                  productId: Value(item.product.id),
                  type: const Value('Pos Sale'),
                  quantity: Value(item.quantity.toDouble()),
                  price: Value(item.batch.sellingPrice), // Use Batch Price
                  totalAmount: Value(item.total),
                  date: Value(DateTime.now()),
                  orderId: Value(billId),
                  batchId: Value(item.batch.id), // Link to Batch
                ),
              );

          // Update Batch Stock Directly
          // We read the current batch to be safe or just decrement
          // Ideally fetch fresh batch, but assuming optimistic ui for now
          // We can use a custom query or just update via DAO

          // Using a raw update or 'update' statement using the batch ID
          final currentBatch = await (_db.select(
            _db.productBatches,
          )..where((t) => t.id.equals(item.batch.id))).getSingle();
          final newQty = currentBatch.stockQty - item.quantity;

          await (_db.update(_db.productBatches)
                ..where((t) => t.id.equals(item.batch.id)))
              .write(ProductBatchesCompanion(stockQty: Value(newQty)));
        }

        // 4. Record to General Ledger
        await _db.recordLedgerEntry(
          GeneralLedgerCompanion(
            id: Value(const Uuid().v4()),
            date: Value(DateTime.now()),
            type: const Value('SALE'),
            description: const Value('POS Sale - Walk-in Customer'),
            credit: Value(totalAmount),
            debit: const Value(0.0),
            referenceId: Value(billId),
            referenceTable: const Value('sales_bills'),
          ),
        );
      });

      if (mounted) {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) => OrderSuccessScreen(
                  animationPath: widget.successAnimationPath,
                  loopAnimation: widget.successAnimationLoop,
                  buttonText: widget.successButtonText,
                  onBackToPos: () {},
                  billId: billId,
                ),
              ),
            )
            .then((_) {
              if (mounted) {
                setState(() {
                  cartItems.clear();
                  _splits.clear();
                });
              }
            });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error processing sale: $e')));
      }
    }
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
          backgroundColor: const Color(0xFFF5F5F7),
          endDrawer: !isDesktop
              ? Drawer(
                  width: 350,
                  backgroundColor: Colors.white,
                  child: CartSidebar(
                    key: _cartSidebarKey,
                    cartItems: cartItems,
                    splits: _splits,
                    onAddSplit: _addSplit,
                    onRemoveSplit: _removeSplit,
                    onUpdateSplit: _updateSplit,
                    onRemoveItem: _removeItem,
                    onCheckout: () async {
                      if (_splits.isEmpty) return;
                      final total = _splits.fold(
                        0.0,
                        (sum, s) => sum + s.amount,
                      );
                      await _processSale(_splits, total);
                    },
                  ),
                )
              : null,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        _buildHeader(isDesktop: isDesktop, isSmallScreen: !isDesktop),
                        Expanded(
                          child: StreamBuilder<List<ProductInventoryView>>(
                            stream: _inventoryStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasError)
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              if (!snapshot.hasData)
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );

                              final allItems = snapshot.data!;
                              final items = _searchQuery.isEmpty
                                  ? allItems
                                  : allItems
                                        .where(
                                          (i) => i.product.name
                                              .toLowerCase()
                                              .contains(
                                                _searchQuery.toLowerCase(),
                                              ),
                                        )
                                        .toList();

                              if (items.isEmpty)
                                return const Center(
                                  child: Text('No products found'),
                                );

                              return Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        childAspectRatio: childAspectRatio,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                      ),
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    return ProductCard(
                                      item: items[index],
                                      onAdd: (qty) =>
                                          _onProductAdd(items[index], qty),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isDesktop) ...[
                  const SizedBox(width: 16),
                  Container(
                    width: 380,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: CartSidebar(
                      key: _cartSidebarKey,
                      cartItems: cartItems,
                      splits: _splits,
                      onAddSplit: _addSplit,
                      onRemoveSplit: _removeSplit,
                      onUpdateSplit: _updateSplit,
                      onRemoveItem: _removeItem,
                      onCheckout: () async {
                        if (_splits.isEmpty) return;
                        final total = _splits.fold(
                          0.0,
                          (sum, s) => sum + s.amount,
                        );
                        await _processSale(_splits, total);
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // ... (Header Widget inside PosContent)

  Widget _buildHeader({required bool isDesktop, required bool isSmallScreen}) {
    final user = getIt<AuthService>().currentUser.value;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Column(
        children: [
          if (_isSearchVisibleMobile && isSmallScreen)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => setState(() {
                        _isSearchVisibleMobile = false;
                        _searchQuery = '';
                      }),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(top: 8),
                  ),
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.title,
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (user != null && isDesktop)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue.shade100),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 14,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    user.name,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.blue.shade800,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      Text(
                        'Select products to add to cart',
                        style:
                            GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                if (isDesktop) ...[
                  Container(
                    width: 250,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ] else ...[
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () =>
                        setState(() => _isSearchVisibleMobile = true),
                  ),
                  Builder(
                    builder: (context) => IconButton(
                      icon: Badge(
                        label: Text('${cartItems.length}'),
                        isLabelVisible: cartItems.isNotEmpty,
                        child: const Icon(Icons.shopping_cart_outlined),
                      ),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _BatchSelectionRow extends StatefulWidget {
  final ProductBatch batch;
  final int initialQty;
  final Function(int) onAdd;

  const _BatchSelectionRow({
    super.key,
    required this.batch,
    required this.initialQty,
    required this.onAdd,
  });

  @override
  State<_BatchSelectionRow> createState() => _BatchSelectionRowState();
}

class _BatchSelectionRowState extends State<_BatchSelectionRow> {
  late int _qty;

  @override
  void initState() {
    super.initState();
    _qty = widget.initialQty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SP: ₹${widget.batch.sellingPrice.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Text(
                'MRP: ₹${widget.batch.mrp.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  decoration: TextDecoration.lineThrough,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Batch: ${widget.batch.batchNumber ?? "N/A"} • Stock: ${widget.batch.stockQty}',
            style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                height: 32,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 14),
                      onPressed: () {
                        if (_qty > 1) setState(() => _qty--);
                      },
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      constraints: const BoxConstraints(),
                    ),
                    Text(
                      '$_qty',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 14),
                      onPressed: () {
                        if (_qty < widget.batch.stockQty)
                          setState(() => _qty++);
                      },
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: () => widget.onAdd(_qty),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Add',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
