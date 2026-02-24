import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retailsaas/data/database/app_database.dart';
import 'package:retailsaas/locator.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;

class DebitNoteFormScreen extends StatefulWidget {
  final String poId; // Use ID for DB lookup
  final String poNumber;
  final Map<String, dynamic> vendor;
  // Items from the PO to allow selection for debit note
  final List<Map<String, dynamic>> items;

  const DebitNoteFormScreen({
    super.key,
    required this.poId,
    required this.poNumber,
    required this.vendor,
    required this.items,
  });

  @override
  State<DebitNoteFormScreen> createState() => _DebitNoteFormScreenState();
}

class _DebitNoteFormScreenState extends State<DebitNoteFormScreen> {
  final _reasonController = TextEditingController();
  final _amountController = TextEditingController(); // Or auto-calculated
  DateTime _date = DateTime.now();

  // Smart Logic State
  late List<Map<String, dynamic>> _itemRows;

  @override
  void initState() {
    super.initState();
    _initializeItems();
  }

  void _initializeItems() {
    _itemRows = widget.items.map((item) {
      final ordered = (item['qty'] as num).toDouble();
      final received = (item['receivedQty'] as num).toDouble();
      final rejected = (item['rejectedQty'] as num? ?? 0.0)
          .toDouble(); // Get passed rejected qty

      // Shortage is (Ordered - Received). This includes Rejected + Pending.
      // Received here means "Accepted" based on previous logic change.
      final shortage = (ordered - received).clamp(0.0, ordered);

      return {
        ...item,
        'ordered': ordered,
        'received': received,
        'rejected': rejected,
        'shortage': shortage,
        'debitQty': rejected > 0 ? rejected : 0.0, // Default to Rejected Qty
        'isSelected': rejected > 0, // Auto-select if there is a Rejection
      };
    }).toList();
    _calculateTotal();
  }

  void _calculateTotal() {
    double total = 0;
    for (var item in _itemRows) {
      if (item['isSelected'] == true) {
        final qty = (item['debitQty'] as num).toDouble();
        final price = (item['price'] as num).toDouble();
        total += qty * price;
      }
    }
    _amountController.text = total.toStringAsFixed(2);
  }

  void _updateItemQty(int index, String value) {
    if (value.isEmpty) return;
    final newQty = double.tryParse(value) ?? 0;
    final maxQty = _itemRows[index]['shortage'] as double;

    if (newQty > maxQty) {
      // Show error or snap back? Let's snap back for simplicity UI but maybe warn
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot debit more than shortage (${maxQty.toInt()})'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      // We will handle the actual value update in the text field controller if we were using one
      // But here we might just force a rebuild with capped value or let it be flexible until save
      // For tight constraints, let's clamp it immediately in state
      setState(() {
        _itemRows[index]['debitQty'] = maxQty;
      });
    } else {
      setState(() {
        _itemRows[index]['debitQty'] = newQty;
      });
    }
    _calculateTotal();
  }

  final _db = getIt<AppDatabase>();
  final _uuid = const Uuid();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Create Debit Note',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vendor & PO Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vendor',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              widget.vendor['name'],
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'PO Number',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              widget.poNumber,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Date Picker
                  InkWell(
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (d != null) setState(() => _date = d);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text('${_date.day}/${_date.month}/${_date.year}'),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Items Table Header
                  Text(
                    'Item Details (Shortage Calculation)',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),

                  _buildItemsTable(),

                  const SizedBox(height: 24),

                  // Amount (Auto-Calculated / Editable)
                  TextField(
                    controller: _amountController,
                    readOnly: true, // Auto-calculated only
                    decoration: const InputDecoration(
                      labelText: 'Total Refund Amount (₹)',
                      border: OutlineInputBorder(),
                      prefixText: '₹ ',
                      helperText: 'Auto-calculated based on selected items',
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Reason
                  TextField(
                    controller: _reasonController,
                    decoration: const InputDecoration(
                      labelText: 'Reason',
                      border: OutlineInputBorder(),
                      hintText: 'e.g. Short supply against Invoice #123',
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveDebitNote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Debit Note'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            color: Colors.grey.shade50,
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Checkbox(
                    value: _itemRows.every((i) => i['isSelected']),
                    onChanged: (val) {
                      setState(() {
                        for (var item in _itemRows) {
                          if ((item['shortage'] as double) > 0 ||
                              (item['rejected'] as double) > 0) {
                            item['isSelected'] = val;
                          }
                        }
                      });
                      _calculateTotal();
                    },
                  ),
                ),
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
                Expanded(
                  flex: 2,
                  child: Text(
                    'Ord / Recv',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Rejected',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Debit Qty',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Rows
          ..._itemRows.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = item['isSelected'] as bool;
            final shortage = item['shortage'] as double;
            final rejected = item['rejected'] as double;
            final hasIssue = shortage > 0 || rejected > 0;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
                color: (isSelected && rejected > 0)
                    ? Colors.orange.shade50
                    : (hasIssue ? Colors.white : Colors.grey.shade50),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: hasIssue
                        ? Checkbox(
                            value: isSelected,
                            onChanged: (val) {
                              setState(() {
                                item['isSelected'] = val;
                                // If selecting, default to rejected (if any) or max shortage?
                                // Logic above sets initial. If user toggles, we keep current value/0?
                                // Actually, calculating total depends on value. It's fine.
                              });
                              _calculateTotal();
                            },
                          )
                        : const Icon(Icons.circle, size: 8, color: Colors.grey),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: hasIssue ? Colors.black : Colors.grey,
                          ),
                        ),
                        Text(
                          '₹${item['price']}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${(item['ordered'] as double).toInt()} / ${(item['received'] as double).toInt()}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${rejected.toInt()}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: rejected > 0
                            ? Colors.red.shade700
                            : Colors.grey.shade400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: isSelected
                        ? SizedBox(
                            height: 35,
                            child: TextFormField(
                              initialValue: (item['debitQty'] as double)
                                  .toInt()
                                  .toString(),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 13),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (val) => _updateItemQty(index, val),
                            ),
                          )
                        : const SizedBox(), // Hide input if not selected
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _saveDebitNote() async {
    // 1. Validate General
    if (_reasonController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a reason')));
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Valid Items Selected or Amount is 0')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dnId = _uuid.v4();

      // 2. Create Header
      await _db
          .into(_db.debitNotes)
          .insert(
            DebitNotesCompanion.insert(
              id: dnId,
              vendorId: widget.vendor['id'] ?? '',
              poId: drift.Value(widget.poId),
              date: _date,
              amount: amount,
              reason: _reasonController.text,
              status: 'Draft',
            ),
          );

      // 3. Create Items (If we had a table for DebitNoteItems, we would insert here)
      // For now, we are just calculating the total amount based on items.
      // Ideally, in a real system, we save the breakdown. But per current DB schema, we only have `DebitNotes` table.
      // So we save the aggregate amount, which is what we did above.

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debit Note Created Successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving: $e')));
        setState(() => _isLoading = false);
      }
    }
  }
}
