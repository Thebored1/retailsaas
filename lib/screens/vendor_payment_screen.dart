import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../data/database/app_database.dart';
import '../models/vendor.dart'
    as model; // Helper, though we might use DB vendor directly
import '../locator.dart';

class VendorPaymentScreen extends StatefulWidget {
  final String? preSelectedVendorId;

  const VendorPaymentScreen({super.key, this.preSelectedVendorId});

  @override
  State<VendorPaymentScreen> createState() => _VendorPaymentScreenState();
}

class _UnpaidGrn {
  final String grnId;
  final String grnNumber;
  final DateTime grnDate;
  final double totalAmount;
  final double paidAmount;
  final double pendingAmount;

  bool isSelected;
  double allocatedAmount;
  TextEditingController controller;

  _UnpaidGrn({
    required this.grnId,
    required this.grnNumber,
    required this.grnDate,
    required this.totalAmount,
    required this.paidAmount,
    required this.pendingAmount,
    this.isSelected = false,
    this.allocatedAmount = 0.0,
  }) : controller = TextEditingController(text: '0');

  // Helper to determine status
  String get status {
    final daysOld = DateTime.now().difference(grnDate).inDays;
    if (daysOld > 30) return 'Overdue';
    return 'Pending';
  }
}

class _VendorPaymentScreenState extends State<VendorPaymentScreen> {
  final _db = getIt<AppDatabase>();
  final _uuid = const Uuid();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // State
  String? _selectedVendorId;
  double _outstandingBalance = 0.0;
  List<_UnpaidGrn> _unpaidGrns = [];
  bool _isLoadingGrns = false;

  // Payment Form
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _notesController = TextEditingController();
  String _paymentMode = 'Cheque'; // Check, Cash, UPI, Bank Transfer
  DateTime _paymentDate = DateTime.now();

  // Allocation
  bool _allSelected = false;

  @override
  void initState() {
    super.initState();
    if (widget.preSelectedVendorId != null) {
      _selectedVendorId = widget.preSelectedVendorId;
      _loadVendorData();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _notesController.dispose();
    for (var grn in _unpaidGrns) {
      grn.controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadVendorData() async {
    if (_selectedVendorId == null) return;

    setState(() => _isLoadingGrns = true);

    try {
      // 1. Get Balance
      // We can use the stream or calculate fresh. Stream is easier but let's just get latest.
      final balance = await _db.watchVendorBalance(_selectedVendorId!).first;

      // 2. Get Unpaid GRNs
      final query =
          _db.select(_db.goodsReceipts).join([
              drift.innerJoin(
                _db.purchaseOrders,
                _db.purchaseOrders.id.equalsExp(_db.goodsReceipts.poId),
              ),
            ])
            ..where(_db.purchaseOrders.vendorId.equals(_selectedVendorId!))
            ..orderBy([drift.OrderingTerm.asc(_db.goodsReceipts.grnDate)]);

      final result = await query.get();
      final grns = result
          .map((row) => row.readTable(_db.goodsReceipts))
          .toList();

      final List<_UnpaidGrn> unpaidList = [];

      for (var grn in grns) {
        // Use pre-calculated Total Amount from DB (Backfilled)
        double total = grn.totalAmount;

        // Calculate Pending
        // Note: paidAmount column assumes we've migrated successfully.
        // If not migrated yet, this might error or be 0.
        double paid = grn.paidAmount;
        double pending = total - paid;

        // Only show if pending > 1 rupee (floating point tolerance)
        if (pending > 1.0) {
          unpaidList.add(
            _UnpaidGrn(
              grnId: grn.id,
              grnNumber: grn.grnNumber,
              grnDate: grn.grnDate,
              totalAmount: total,
              paidAmount: paid,
              pendingAmount: pending,
            ),
          );
        }
      }

      setState(() {
        _outstandingBalance = balance;
        _unpaidGrns = unpaidList;
        _isLoadingGrns = false;

        // Reset selections if vendor changed
        _amountController.clear();
        _allSelected = false;
      });
    } catch (e) {
      debugPrint('Error loading vendor data: $e');
      setState(() => _isLoadingGrns = false);
    }
  }

  // --- Allocation Logic ---

  void _autoAllocateFIFO() {
    double paymentAmt = double.tryParse(_amountController.text) ?? 0.0;
    if (paymentAmt <= 0) return;

    double remaining = paymentAmt;

    for (var grn in _unpaidGrns) {
      if (remaining <= 0) {
        grn.allocatedAmount = 0.0;
        grn.isSelected = false;
        grn.controller.text = '0';
        continue;
      }

      if (remaining >= grn.pendingAmount) {
        // Pay fully
        grn.allocatedAmount = grn.pendingAmount;
        grn.isSelected = true;
        grn.controller.text = grn.pendingAmount.toStringAsFixed(2);
        remaining -= grn.pendingAmount;
      } else {
        // Partial
        grn.allocatedAmount = remaining;
        grn.isSelected = true;
        grn.controller.text = remaining.toStringAsFixed(2);
        remaining = 0;
      }
    }
    setState(() {});
  }

  void _clearAllocation() {
    for (var grn in _unpaidGrns) {
      grn.allocatedAmount = 0.0;
      grn.isSelected = false;
      grn.controller.text = '0';
    }
    setState(() {
      _allSelected = false;
    });
  }

  void _updateGrnAllocation(_UnpaidGrn grn, String val) {
    double amount = double.tryParse(val) ?? 0.0;

    // Validation: Cannot exceed pending
    if (amount > grn.pendingAmount + 0.01) {
      // tolerance
      amount = grn.pendingAmount;
      grn.controller.text = amount.toStringAsFixed(2);
    }

    setState(() {
      grn.allocatedAmount = amount;
      grn.isSelected = amount > 0;
    });
  }

  void _toggleAll(bool? val) {
    setState(() {
      _allSelected = val ?? false;
      for (var grn in _unpaidGrns) {
        grn.isSelected = _allSelected;
        if (!_allSelected) {
          grn.allocatedAmount = 0.0;
          grn.controller.text = '0';
        }
      }
    });
    // If selecting all, we might want to auto-fill?
    // Usually "Check All" just selects them, but doesn't set amounts unless we know total payment.
    // Let's stick to simple selection for now.
  }

  // --- Saving ---

  Future<void> _savePayment() async {
    if (_formKey.currentState?.validate() != true) return;
    if (_selectedVendorId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select a vendor')));
      return;
    }

    final paymentAmt = double.tryParse(_amountController.text) ?? 0.0;
    final totalAllocated = _unpaidGrns.fold(
      0.0,
      (sum, g) => sum + g.allocatedAmount,
    );

    if (totalAllocated > paymentAmt + 0.01) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Allocated amount cannot exceed Payment Amount'),
        ),
      );
      return;
    }

    if (totalAllocated <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please allocate payment to at least one bill')),
      );
      return;
    }

    try {
      await _db.transaction(() async {
        final paymentId = _uuid.v4();

        // 1. Create Vendor Payment
        await _db
            .into(_db.vendorPayments)
            .insert(
              VendorPaymentsCompanion(
                id: drift.Value(paymentId),
                vendorId: drift.Value(_selectedVendorId!),
                amount: drift.Value(
                  totalAllocated,
                ), // Only save what was allocated/paid
                date: drift.Value(_paymentDate),
                mode: drift.Value(_paymentMode),
                reference: drift.Value(_referenceController.text),
                notes: drift.Value(_notesController.text),
              ),
            );

        // 2. Allocations & Update GRNs
        for (var grn in _unpaidGrns) {
          if (grn.allocatedAmount > 0) {
            // Create Allocation Record
            await _db
                .into(_db.paymentAllocations)
                .insert(
                  PaymentAllocationsCompanion(
                    id: drift.Value(_uuid.v4()),
                    paymentId: drift.Value(paymentId),
                    grnId: drift.Value(grn.grnId),
                    allocatedAmount: drift.Value(grn.allocatedAmount),
                    createdAt: drift.Value(DateTime.now()),
                  ),
                );

            // Update GRN Paid Amount
            // We read fresh to ensure concurrency safety if needed, though simpler update is fine here
            await (_db.customStatement(
              'UPDATE goods_receipts SET paid_amount = paid_amount + ? WHERE id = ?',
              [grn.allocatedAmount, grn.grnId],
            ));
          }
        }

        // 3. Ledger Entry
        await _db.recordLedgerEntry(
          GeneralLedgerCompanion(
            id: drift.Value(_uuid.v4()),
            date: drift.Value(_paymentDate),
            type: const drift.Value('PAYMENT'),
            description: drift.Value(
              'Vendor Payment: $_paymentMode (${_referenceController.text})',
            ),
            debit: const drift.Value(0.0),
            credit: drift.Value(totalAllocated), // Money outflow
            referenceId: drift.Value(paymentId),
            referenceTable: const drift.Value('vendor_payments'),
          ),
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment Saved Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return success
      }
    } catch (e) {
      debugPrint('Save Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving payment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // --- Panels ---

  Widget _buildFormPanel(BuildContext context, {bool isDrawer = false}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: isDrawer
            ? null
            : Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            if (isDrawer) ...[
              Text(
                'Payment Details',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
            ],

            // 1. Vendor Selection
            Text(
              'Select Vendor',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            StreamBuilder<List<Vendor>>(
              stream: _db.select(_db.vendors).watch(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const LinearProgressIndicator();
                final vendors = snapshot.data!;

                return DropdownButtonFormField<String>(
                  value: _selectedVendorId,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: vendors
                      .map(
                        (v) => DropdownMenuItem(
                          value: v.id,
                          child: Text(v.name, style: GoogleFonts.inter()),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedVendorId = val;
                      _loadVendorData();
                    });
                  },
                  hint: const Text('Choose a vendor'),
                );
              },
            ),

            const SizedBox(height: 24),

            // Balance Card
            if (_selectedVendorId != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Outstanding Balance',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.orange.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${_outstandingBalance.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_unpaidGrns.length} unpaid bills found',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 24),

            Text(
              'Payment Details',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Amount
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                labelText: 'Payment Amount',
                prefixText: '₹ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) return 'Required';
                if (double.tryParse(val)! <= 0) return 'Invalid amount';
                return null;
              },
              onChanged: (val) => setState(() {}), // rebuild to update summary
            ),

            const SizedBox(height: 16),

            // Mode & Date Row
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _paymentMode,
                    decoration: InputDecoration(
                      labelText: 'Payment Mode',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: ['Cash', 'Cheque', 'UPI', 'Bank Transfer']
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                    onChanged: (val) => setState(() => _paymentMode = val!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _paymentDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (d != null)
                        setState(
                          () => _paymentMode = _paymentMode,
                        ); // refresh? No, just set date
                      if (d != null) setState(() => _paymentDate = d);
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: const Icon(Icons.calendar_today, size: 16),
                      ),
                      child: Text(
                        DateFormat('dd MMM yyyy').format(_paymentDate),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Reference
            TextFormField(
              controller: _referenceController,
              decoration: InputDecoration(
                labelText: 'Reference No. (Cheque / UTR)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightPanel(BuildContext context) {
    final totalAllocated = _unpaidGrns.fold(
      0.0,
      (sum, g) => sum + g.allocatedAmount,
    );
    final paymentAmt = double.tryParse(_amountController.text) ?? 0.0;

    return Container(
      color: totalAllocated <= paymentAmt + 0.01
          ? Colors.grey.shade50
          : Colors.red.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Allocation',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _autoAllocateFIFO,
                      icon: const Icon(Icons.flash_on, size: 16),
                      label: const Text('Auto-Allocate (FIFO)'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: _clearAllocation,
                      child: const Text('Clear All'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Summary Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: totalAllocated <= paymentAmt
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: totalAllocated <= paymentAmt
                      ? Colors.green.shade200
                      : Colors.red.shade200,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Allocated: ₹${totalAllocated.toStringAsFixed(2)} / ₹${paymentAmt.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: totalAllocated <= paymentAmt
                          ? Colors.green.shade800
                          : Colors.red.shade800,
                    ),
                  ),
                  if (totalAllocated > paymentAmt)
                    Text(
                      'Over-allocated!',
                      style: GoogleFonts.inter(
                        color: Colors.red.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // The Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _isLoadingGrns
                  ? const Center(child: CircularProgressIndicator())
                  : _unpaidGrns.isEmpty
                  ? Center(
                      child: Text(
                        'No unpaid bills found',
                        style: GoogleFonts.inter(color: Colors.grey),
                      ),
                    )
                  : Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                  child: Checkbox(
                                    value: _allSelected,
                                    onChanged: _toggleAll,
                                  ),
                                ),
                                const Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Date',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Bill No',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                // NEW: Status Column
                                const Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Status',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                // Total Due (was Pending)
                                const Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Total Due',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                // Allocated Amount (was Allocate)
                                const Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 16),
                                    child: Text(
                                      'Allocated Amount',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // List
                          Expanded(
                            child: ListView.separated(
                              itemCount: _unpaidGrns.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final grn = _unpaidGrns[index];
                                return Container(
                                  color: grn.isSelected
                                      ? Colors.blue.shade50.withOpacity(0.2)
                                      : Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 30,
                                        child: Checkbox(
                                          value: grn.isSelected,
                                          onChanged: (val) {
                                            setState(
                                              () =>
                                                  grn.isSelected = val ?? false,
                                            );
                                            if (!grn.isSelected) {
                                              _updateGrnAllocation(grn, '0');
                                            } else {
                                              _updateGrnAllocation(
                                                grn,
                                                grn.pendingAmount.toString(),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          DateFormat(
                                            'dd MMM',
                                          ).format(grn.grnDate),
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          grn.grnNumber,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      // Status
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: grn.status == 'Overdue'
                                                ? Colors.red.shade50
                                                : Colors.orange.shade50,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            grn.status,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: grn.status == 'Overdue'
                                                  ? Colors.red.shade700
                                                  : Colors.orange.shade800,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Total Due (Pending)
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '₹${grn.pendingAmount.toStringAsFixed(0)}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      // Allocated Amount Input
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 16,
                                          ),
                                          child: SizedBox(
                                            height: 36,
                                            child: TextField(
                                              controller: grn.controller,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                prefixText: '₹ ',
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 8,
                                                    ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                              onChanged: (val) =>
                                                  _updateGrnAllocation(
                                                    grn,
                                                    val,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          // Divider between list and footer
                          const Divider(height: 1, color: Colors.grey),

                          // Footer Actions (Moved Inside Card)
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: _savePayment,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Save Payment',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 900;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Vendor Payment',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white, // Fix pink tint
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            actions: [
              if (isSmallScreen)
                TextButton.icon(
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  icon: const Icon(Icons.edit_note, color: Colors.black),
                  label: const Text(
                    'Details',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
              const SizedBox(width: 8),
            ],
          ),
          drawer: isSmallScreen
              ? Drawer(
                  width: 400,
                  child: _buildFormPanel(context, isDrawer: true),
                )
              : null,
          body: isSmallScreen
              ? _buildRightPanel(context)
              : Row(
                  children: [
                    // LEFT PANEL: Form & Vendor Selection
                    Expanded(flex: 4, child: _buildFormPanel(context)),
                    // RIGHT PANEL: Allocation Grid
                    Expanded(flex: 6, child: _buildRightPanel(context)),
                  ],
                ),
        );
      },
    );
  }
}
