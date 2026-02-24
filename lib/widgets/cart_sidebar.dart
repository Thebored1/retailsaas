import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retailsaas/data/database/app_database.dart';
import '../models/payment_split.dart';

class CartItem {
  final Product product;
  final ProductBatch batch;
  int quantity;
  final DateTime? warrantyEnd;

  CartItem({
    required this.product,
    required this.batch,
    this.quantity = 1,
    this.warrantyEnd,
    this.type = 'Sale',
  });

  final String type;

  double get taxRate => product.gstRate + product.cessRate;

  double get unitPrice => batch.sellingPrice;

  double get taxAmount {
    if (product.isTaxInclusive) {
      // Backwards: Tax = Total - Base
      // Base = Total / (1 + rate)
      double totalValue = unitPrice * quantity;
      double baseValue = totalValue / (1 + taxRate / 100);
      return totalValue - baseValue;
    } else {
      // Forwards: Tax = Base * Rate
      return (unitPrice * quantity) * (taxRate / 100);
    }
  }

  double get total {
    if (product.isTaxInclusive) {
      return unitPrice * quantity;
    } else {
      return (unitPrice * quantity) + taxAmount;
    }
  }
}

class CartSidebar extends StatefulWidget {
  final List<CartItem> cartItems;
  final List<PaymentSplit> splits;
  final Function(CartItem) onRemoveItem;
  final Function(double) onAddSplit;
  final Function(int) onRemoveSplit;
  final Function(int, double, {String? mode}) onUpdateSplit;
  final VoidCallback onCheckout;

  const CartSidebar({
    super.key,
    required this.cartItems,
    required this.splits,
    required this.onRemoveItem,
    required this.onAddSplit, // amount
    required this.onRemoveSplit, // index
    required this.onUpdateSplit,
    required this.onCheckout,
  });

  @override
  State<CartSidebar> createState() => _CartSidebarState();
}

class _CartSidebarState extends State<CartSidebar> {
  // We keep controllers here for text editing state
  final List<TextEditingController> _amountControllers = [];
  final List<String> _paymentModes = ['CASH', 'UPI', 'CARD', 'CREDIT'];

  @override
  void initState() {
    super.initState();
    _syncControllers();
  }

  @override
  void didUpdateWidget(CartSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Be careful with syncing: if user is typing, we might overwrite.
    // However, since state is hoisted, if parent updates 'splits', we must reflect.
    // The parent updates splits mostly on "auto-sync" logic or when we call UpdateSplit.
    // Simple approach: Re-sync controllers if validation/length changes or if external sync happened.
    _syncControllers();
  }

  void _syncControllers() {
    // Resize controllers list
    while (_amountControllers.length < widget.splits.length) {
      _amountControllers.add(TextEditingController());
    }
    while (_amountControllers.length > widget.splits.length) {
      _amountControllers.last.dispose();
      _amountControllers.removeLast();
    }

    // Update text if different (avoid cursor jump if possible, but hard with full sync)
    for (int i = 0; i < widget.splits.length; i++) {
      String val = widget.splits[i].amount.toStringAsFixed(2);
      // Only update if significantly different to avoid fighting user input
      // For exact sync:
      if (_amountControllers[i].text != val) {
        // If the user *just typed* something that parses to the same double, don't overwrite
        // e.g. "300." -> 300.00.
        // Check if current text parses to the same value
        double? currentVal = double.tryParse(_amountControllers[i].text);
        if (currentVal != widget.splits[i].amount) {
          _amountControllers[i].text = val;
        }
      }
    }
  }

  @override
  void dispose() {
    for (var c in _amountControllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double subtotal = widget.cartItems.fold(
      0,
      (sum, item) => sum + item.total,
    );
    final double discount = 0.0;
    final double tax = 0.0;
    final double total = subtotal - discount + tax;

    // Ensure we have initial split if empty and data exists
    if (widget.splits.isEmpty && total > 0) {
      // Defer state update
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onAddSplit(total);
      });
    }

    final double totalPaid = widget.splits.fold(
      0.0,
      (sum, item) => sum + item.amount,
    );
    final double remaining = total - totalPaid;
    final bool isComplete = remaining.abs() < 0.1 && total > 0;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cart Details',
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Text(
            'Details of all transactions',
            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          // Cart Items List
          // Cart Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Item',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Rate',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Qty',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Tax',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Total',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Cart Items List
          Expanded(
            child: widget.cartItems.isEmpty
                ? Center(
                    child: Text(
                      "Cart is Empty",
                      style: GoogleFonts.inter(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    itemCount: widget.cartItems.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    itemBuilder: (context, index) {
                      return _CartItemWidget(
                        item: widget.cartItems[index],
                        onRemove: () =>
                            widget.onRemoveItem(widget.cartItems[index]),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 24),
          // Payment Section
          if (widget.cartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Splits',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Splits UI - Dynamic Fields
                  ...List.generate(widget.splits.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          // Mode
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<String>(
                                value: widget.splits[index].mode,
                                isExpanded: true,
                                underline: const SizedBox(),
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                                items: _paymentModes
                                    .map(
                                      (m) => DropdownMenuItem(
                                        value: m,
                                        child: Text(m),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null)
                                    widget.onUpdateSplit(
                                      index,
                                      widget.splits[index].amount,
                                      mode: val,
                                    );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Amount
                          Expanded(
                            flex: 3,
                            child: SizedBox(
                              height: 40,
                              child: TextField(
                                controller: _amountControllers[index],
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.inter(fontSize: 13),
                                decoration: InputDecoration(
                                  prefixText: '₹ ',
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                                onTap: () {
                                  _amountControllers[index].clear();
                                  // Don't necessarily set 0 immediately, wait for input?
                                  // User asked for clear:
                                  widget.onUpdateSplit(index, 0.0);
                                },
                                onChanged: (val) {
                                  if (val.isEmpty) {
                                    widget.onUpdateSplit(index, 0.0);
                                    return;
                                  }
                                  final amt = double.tryParse(val);
                                  if (amt != null) {
                                    widget.onUpdateSplit(index, amt);
                                  }
                                },
                              ),
                            ),
                          ),
                          // Remove
                          if (widget.splits.length > 1)
                            InkWell(
                              onTap: () => widget.onRemoveSplit(index),
                              child: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),

                  if (widget.splits.length < _paymentModes.length)
                    TextButton.icon(
                      onPressed: () => widget.onAddSplit(remaining),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text("Add Split"),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  // Totals
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: GoogleFonts.inter(color: Colors.grey),
                      ),
                      Text(
                        '₹${total.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Remaining:',
                        style: GoogleFonts.inter(
                          color: remaining > 0.01 ? Colors.red : Colors.green,
                        ),
                      ),
                      Text(
                        '₹${remaining.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: remaining > 0.01 ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isComplete ? widget.onCheckout : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Complete Sale',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;

  const _CartItemWidget({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    bool isInclusive = item.product.isTaxInclusive;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Name & Batch (Flex 3)
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: item.product.name,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: isInclusive ? ' (Incl)' : ' (Excl)',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: isInclusive ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  item.batch.batchNumber != null
                      ? '#${item.batch.batchNumber}'
                      : '#${item.batch.id.substring(0, 4)}',
                  style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Rate (Flex 2)
          Expanded(
            flex: 2,
            child: Text(
              item.unitPrice.toStringAsFixed(2),
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(fontSize: 12),
            ),
          ),

          // Qty (Flex 1)
          Expanded(
            flex: 1,
            child: Text(
              item.quantity.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 12),
            ),
          ),

          // Tax (Flex 2)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${item.taxRate.toStringAsFixed(0)}%',
                  style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
                ),
                Text(
                  isInclusive
                      ? '(${item.taxAmount.toStringAsFixed(2)})'
                      : '+ ${item.taxAmount.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isInclusive ? Colors.grey : Colors.red,
                  ),
                ),
              ],
            ),
          ),

          // Total (Flex 2)
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  item.total.toStringAsFixed(2),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: onRemove,
                  child: const Icon(Icons.close, size: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
