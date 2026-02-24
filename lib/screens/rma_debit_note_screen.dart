import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retailsaas/data/database/app_database.dart';
import 'package:retailsaas/locator.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import 'package:retailsaas/widgets/admin_side_menu.dart';
import 'package:retailsaas/screens/admin_main_screen.dart';
import 'package:intl/intl.dart';

class RmaDebitNoteScreen extends StatefulWidget {
  const RmaDebitNoteScreen({super.key});

  @override
  State<RmaDebitNoteScreen> createState() => _RmaDebitNoteScreenState();
}

class _RmaDebitNoteScreenState extends State<RmaDebitNoteScreen> {
  final _db = getIt<AppDatabase>();
  final _reasonController = TextEditingController();
  final _uuid = const Uuid();

  // Selected Vendor
  Vendor? _selectedVendor;
  List<Vendor> _vendors = [];

  // Available RMA Items for this vendor
  List<RmaItem> _availableRmaItems = [];

  // Selected for Return { batchId: {qty, rate, reason} }
  final Map<String, ({double quantity, double rate, String reason})>
  _selectedItems = {};

  bool _isLoading = true;
  final DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadVendors();
  }

  Future<void> _loadVendors() async {
    final vendors = await _db.select(_db.vendors).get();
    setState(() {
      _vendors = vendors;
      _isLoading = false;
    });
  }

  Future<void> _loadRmaItemsForVendor() async {
    if (_selectedVendor == null) return;

    setState(() => _isLoading = true);

    // 1. Get all damaged stock
    final allDamaged = await _db.getDamagedStock();

    // 2. Filter by products ever bought from this vendor
    final vendorImg =
        await (_db.select(
          _db.purchaseOrders,
        )..where((t) => t.vendorId.equals(_selectedVendor!.id))).join([
          drift.innerJoin(
            _db.purchaseOrderItems,
            _db.purchaseOrderItems.poId.equalsExp(_db.purchaseOrders.id),
          ),
        ]).get();

    final productIdsFromVendor = vendorImg
        .map((row) => row.readTable(_db.purchaseOrderItems).productId)
        .toSet();

    final filtered = allDamaged.where((item) {
      return productIdsFromVendor.contains(item.product.id);
    }).toList();

    setState(() {
      _availableRmaItems = filtered;
      _selectedItems.clear(); // Reset selection
      _isLoading = false;
    });
  }

  void _toggleItemSelection(RmaItem item, bool? selected) {
    setState(() {
      if (selected == true) {
        // Default to: Max Stock, Purchase Rate, Reason: Damaged
        _selectedItems[item.batch.id] = (
          quantity: item.batch.stockQty,
          rate: item.batch.purchaseRate,
          reason: 'Damaged',
        );
      } else {
        _selectedItems.remove(item.batch.id);
      }
    });
  }

  void _updateQuantity(RmaItem item, String value) {
    if (!_selectedItems.containsKey(item.batch.id)) {
      _selectedItems[item.batch.id] = (
        quantity: 0,
        rate: item.batch.purchaseRate,
        reason: 'Damaged',
      );
    }

    final current = _selectedItems[item.batch.id]!;
    final qty = double.tryParse(value) ?? 0;
    final max = item.batch.stockQty;

    if (qty > max) {
      _selectedItems[item.batch.id] = (
        quantity: max,
        rate: current.rate,
        reason: current.reason,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Max limit: ${max.toInt()}')));
    } else {
      _selectedItems[item.batch.id] = (
        quantity: qty,
        rate: current.rate,
        reason: current.reason,
      );
    }
    setState(() {});
  }

  void _updateRate(RmaItem item, String value) {
    if (!_selectedItems.containsKey(item.batch.id)) return;

    final current = _selectedItems[item.batch.id]!;
    final newRate = double.tryParse(value) ?? current.rate;

    setState(() {
      _selectedItems[item.batch.id] = (
        quantity: current.quantity,
        rate: newRate,
        reason: current.reason,
      );
    });
  }

  void _updateReason(RmaItem item, String? newReason) {
    if (newReason == null) return;
    if (!_selectedItems.containsKey(item.batch.id)) return;

    final current = _selectedItems[item.batch.id]!;
    setState(() {
      _selectedItems[item.batch.id] = (
        quantity: current.quantity,
        rate: current.rate,
        reason: newReason,
      );
    });
  }

  // Calculations
  double get _netTotal {
    double total = 0;
    for (var item in _availableRmaItems) {
      if (_selectedItems.containsKey(item.batch.id)) {
        final data = _selectedItems[item.batch.id]!;
        total += data.quantity * data.rate;
      }
    }
    return total;
  }

  double get _taxTotal {
    double total = 0;
    for (var item in _availableRmaItems) {
      if (_selectedItems.containsKey(item.batch.id)) {
        final data = _selectedItems[item.batch.id]!;
        final taxable = data.quantity * data.rate;
        // Tax Calculation: Taxable * GST%
        total += taxable * (item.product.gstRate / 100);
      }
    }
    return total;
  }

  double get _grandTotal => _netTotal + _taxTotal;

  Future<void> _saveDebitNote() async {
    if (_selectedVendor == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Select a Vendor')));
      return;
    }
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Select items to return')));
      return;
    }
    if (_selectedItems.values.any((e) => e.quantity <= 0)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Quantity cannot be 0')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dnId = _uuid.v4();

      final note = DebitNotesCompanion.insert(
        id: dnId,
        vendorId: _selectedVendor!.id,
        date: _date,
        amount: _grandTotal,
        reason: 'RMA Return', // Generic header
        status: 'Sent',
        notes: drift.Value(
          _reasonController.text.isNotEmpty
              ? _reasonController.text
              : 'No additional notes',
        ),
      );

      final itemsToProcess =
          <({DebitNoteItemsCompanion item, String batchId, double quantity})>[];

      _selectedItems.forEach((batchId, data) {
        if (data.quantity <= 0) return;

        final item = _availableRmaItems.firstWhere(
          (e) => e.batch.id == batchId,
        );

        itemsToProcess.add((
          item: DebitNoteItemsCompanion.insert(
            dnId: dnId,
            productId: item.product.id,
            productName: item.product.name,
            orderedQty: 0,
            rejectedQty: data.quantity.toInt(),
            reason: data.reason, // Item Specific Reason
            rate: data.rate,
            taxRate: item.product.gstRate,
          ),
          batchId: batchId,
          quantity: data.quantity,
        ));
      });

      await _db.processRmaReturn(dn: note, items: itemsToProcess);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('RMA Return Processed Successfully')),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => AdminMainScreen(initialItem: 'Debit Notes'),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          AdminSideMenu(
            selectedItem: 'Debit Notes',
            onItemSelected: (item) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => AdminMainScreen(initialItem: item),
                ),
                (route) => false,
              );
            },
          ),

          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Return RMA Items',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Date: ${DateFormat('dd MMM yyyy').format(_date)}',
                        style: GoogleFonts.inter(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select Vendor',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          value: _selectedVendor?.id,
                          items: _vendors.map((v) {
                            return DropdownMenuItem(
                              value: v.id,
                              child: Text(v.name),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedVendor = _vendors.firstWhere(
                                (v) => v.id == val,
                              );
                              _availableRmaItems = [];
                              _selectedItems.clear();
                            });
                            _loadRmaItemsForVendor();
                          },
                        ),

                        SizedBox(height: 24),
                        Text(
                          'Reported Damaged Items (For this Vendor)',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 12),

                        if (_selectedVendor == null)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'Select a vendor to view returnable items',
                              ),
                            ),
                          )
                        else if (_isLoading)
                          Center(child: CircularProgressIndicator())
                        else if (_availableRmaItems.isEmpty)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'No damaged items found for this vendor.',
                              ),
                            ),
                          )
                        else
                          _buildItemsTable(),

                        SizedBox(height: 24),

                        TextField(
                          controller: _reasonController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            labelText: 'Additional Notes', // Renamed
                            border: OutlineInputBorder(),
                            hintText: 'Optional notes for this return',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Totals Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Net Total (Taxable): ',
                                style: GoogleFonts.inter(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '₹${_netTotal.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'Tax Total: ',
                                style: GoogleFonts.inter(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '₹${_taxTotal.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'Grand Total: ',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '₹${_grandTotal.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: _saveDebitNote,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                        ),
                        child: Text('Process Return'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Colors.grey.shade50,
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Text(
                    '',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                ), // Checkbox
                SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Item',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Reason',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ), // New Column
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Avail.',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Qty',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Rate',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Tax',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Total',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          // Rows
          ..._availableRmaItems.map((item) {
            final isSelected = _selectedItems.containsKey(item.batch.id);
            final selection = _selectedItems[item.batch.id];
            final qty = selection?.quantity ?? 0;
            final rate = selection?.rate ?? item.batch.purchaseRate;
            final reason = selection?.reason ?? 'Damaged';

            final gstRate = item.product.gstRate;
            final taxAmount = (rate * qty) * (gstRate / 100);
            final rowTotal = (rate * qty) + taxAmount;

            return Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
                color: isSelected
                    ? Colors.blue.shade50.withOpacity(0.2)
                    : Colors.white,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Checkbox(
                      value: isSelected,
                      onChanged: (v) => _toggleItemSelection(item, v),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.name,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Batch: ${item.batch.batchNumber ?? "-"}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  // Reason Dropdown per Item
                  Expanded(
                    flex: 2,
                    child: isSelected
                        ? Container(
                            height: 35,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: reason,
                                isExpanded: true,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                                items:
                                    [
                                      'Damaged',
                                      'Warranty',
                                      'Expired',
                                      'Wrong Item',
                                      'Other',
                                    ].map((String val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: Text(val),
                                      );
                                    }).toList(),
                                onChanged: (val) => _updateReason(item, val),
                              ),
                            ),
                          )
                        : Text('-'),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${item.batch.stockQty.toInt()}',
                      style: GoogleFonts.inter(fontSize: 13),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: isSelected
                        ? TextFormField(
                            initialValue: qty > 0 ? qty.toInt().toString() : '',
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.inter(fontSize: 13),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            onChanged: (v) => _updateQuantity(item, v),
                          )
                        : Text('-'),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: isSelected
                        ? Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: TextFormField(
                              initialValue: rate.toStringAsFixed(2),
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.inter(fontSize: 13),
                              decoration: InputDecoration(
                                prefixText: '₹',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 8,
                                ),
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              onChanged: (v) => _updateRate(item, v),
                            ),
                          )
                        : Text('₹${rate.toStringAsFixed(2)}'),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${gstRate.toStringAsFixed(0)}%',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: Text(
                      isSelected ? '₹${rowTotal.toStringAsFixed(0)}' : '-',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
