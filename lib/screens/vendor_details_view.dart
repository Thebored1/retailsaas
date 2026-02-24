import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/vendor.dart' as model;
import '../data/database/app_database.dart';
import 'package:intl/intl.dart';
import 'package:retailsaas/screens/vendor_payment_screen.dart';

class VendorDetailsView extends StatefulWidget {
  final model.Vendor vendor;
  final VoidCallback onBack;

  const VendorDetailsView({
    super.key,
    required this.vendor,
    required this.onBack,
  });

  @override
  State<VendorDetailsView> createState() => _VendorDetailsViewState();
}

class _VendorDetailsViewState extends State<VendorDetailsView> {
  late AppDatabase _db;
  int _ordersMade = 0;
  int _pending = 0;
  int _debitNotes = 0;
  int _delivered = 0;
  double _balance = 0.0;
  bool _isLoading = true;
  // ... existing code ...

  List<_VendorTransaction> _transactionHistory = [];

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _loadStatistics();
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  Future<void> _loadStatistics() async {
    try {
      // Orders Made: Count all POs for this vendor
      final ordersMadeCount =
          await (_db.select(_db.purchaseOrders)
                ..where((tbl) => tbl.vendorId.equals(widget.vendor.id)))
              .get()
              .then((rows) => rows.length);

      // Pending: Count POs with status = 'Draft'
      final pendingList =
          await (_db.select(_db.purchaseOrders)
                ..where((tbl) => tbl.vendorId.equals(widget.vendor.id))
                ..where((tbl) => tbl.status.equals('Draft')))
              .get();
      final pendingCount = pendingList.length;

      // Debit Notes: Count all DNs for this vendor
      final debitNotesCount =
          await (_db.select(_db.debitNotes)
                ..where((tbl) => tbl.vendorId.equals(widget.vendor.id)))
              .get()
              .then((rows) => rows.length);

      // Delivered: Count POs with status = 'Completed'
      final deliveredList =
          await (_db.select(_db.purchaseOrders)
                ..where((tbl) => tbl.vendorId.equals(widget.vendor.id))
                ..where((tbl) => tbl.status.equals('Completed')))
              .get();
      final deliveredCount = deliveredList.length;

      // Balance: Fetch first value from stream
      final balance = await _db.watchVendorBalance(widget.vendor.id).first;

      // --- Load Unified History ---
      final poList = await (_db.select(
        _db.purchaseOrders,
      )..where((tbl) => tbl.vendorId.equals(widget.vendor.id))).get();

      final dnList = await (_db.select(
        _db.debitNotes,
      )..where((tbl) => tbl.vendorId.equals(widget.vendor.id))).get();

      final paymentList = await (_db.select(
        _db.vendorPayments,
      )..where((tbl) => tbl.vendorId.equals(widget.vendor.id))).get();

      final List<_VendorTransaction> history = [];

      // Convert POs
      for (var po in poList) {
        history.add(
          _VendorTransaction(
            id: po.id,
            date: po.createdAt,
            type: _TransactionType.purchaseOrder,
            reference: po.poNumber,
            amount: po.totalAmount,
            description: po.status == 'Completed' ? 'Delivered' : po.status,
            status: po.status,
          ),
        );
      }

      // Convert DNs
      for (var dn in dnList) {
        history.add(
          _VendorTransaction(
            id: dn.id,
            date: dn.date,
            type: _TransactionType.debitNote,
            reference: 'DN-${dn.id.substring(0, 8)}',
            amount: dn.amount,
            description: dn.reason,
            status: dn.status,
          ),
        );
      }

      // Convert Payments
      for (var pay in paymentList) {
        history.add(
          _VendorTransaction(
            id: pay.id,
            date: pay.date,
            type: _TransactionType.payment,
            reference: pay.mode,
            amount: pay.amount,
            description: pay.notes ?? '',
          ),
        );
      }

      // Sort Descending
      history.sort((a, b) => b.date.compareTo(a.date));

      setState(() {
        _ordersMade = ordersMadeCount;
        _pending = pendingCount;
        _debitNotes = debitNotesCount;
        _delivered = deliveredCount;
        _balance = balance;
        _transactionHistory = history;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading vendor statistics: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.vendor.name,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.vendor.description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VendorPaymentScreen(
                        preSelectedVendorId: widget.vendor.id,
                      ),
                    ),
                  );
                  _loadStatistics(); // Refresh data
                },
                icon: const Icon(Icons.payment, size: 18),
                label: Text(
                  'Record Payment',
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
          const SizedBox(height: 24),

          // Wireframe Box (Interactions + History)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Main Content (Left)
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Interactions made with this Vendor',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Stats Row
                          Wrap(
                            spacing: 24,
                            runSpacing: 24,
                            children: [
                              _buildStatCard(
                                icon: Icons.account_balance_wallet_outlined,
                                title: 'Balance Due',
                                value: _isLoading
                                    ? '...'
                                    : '₹${_balance.toStringAsFixed(0)}',
                                color: _balance > 0 ? Colors.red : Colors.green,
                              ),
                              _buildStatCard(
                                icon: Icons.inventory_2_outlined,
                                title: 'Orders Made',
                                value: _isLoading
                                    ? '...'
                                    : _ordersMade.toString().padLeft(2, '0'),
                              ),
                              _buildStatCard(
                                icon: Icons.pending_actions_outlined,
                                title: 'Pending',
                                value: _isLoading
                                    ? '...'
                                    : _pending.toString().padLeft(2, '0'),
                              ),
                              _buildStatCard(
                                icon: Icons.description_outlined,
                                title: 'Debit Notes',
                                value: _isLoading
                                    ? '...'
                                    : _debitNotes.toString().padLeft(2, '0'),
                              ),
                              _buildStatCard(
                                icon: Icons.local_shipping_outlined,
                                title: 'Delivered',
                                value: _isLoading
                                    ? '...'
                                    : _delivered.toString().padLeft(2, '0'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Divider(color: Colors.grey.shade200),
                          const SizedBox(height: 32),

                          // Key Details Section
                          Text(
                            'Vendor Info',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Wrap(
                            spacing: 48,
                            runSpacing: 24,
                            children: [
                              _buildDetailItem('GSTIN', widget.vendor.gstin),
                              _buildDetailItem(
                                'Vendor Type',
                                widget.vendor.type,
                              ),
                              _buildDetailItem('Email', widget.vendor.email),
                              _buildDetailItem(
                                'Phone',
                                widget.vendor.mobileNumber,
                              ),
                              _buildDetailItem(
                                'Address',
                                widget.vendor.address,
                              ),
                              if (widget.vendor.bankDetails != null) ...[
                                _buildDetailItem(
                                  'Bank Name',
                                  widget.vendor.bankDetails!.bankName,
                                ),
                                _buildDetailItem(
                                  'Account No',
                                  widget.vendor.bankDetails!.accountNumber,
                                ),
                                _buildDetailItem(
                                  'IFSC',
                                  widget.vendor.bankDetails!.ifscCode,
                                ),
                                _buildDetailItem(
                                  'UPI ID',
                                  widget.vendor.bankDetails!.upiId,
                                ),
                              ],
                            ],
                          ),

                          const SizedBox(height: 32),
                          Divider(color: Colors.grey.shade200),
                          const SizedBox(height: 32),

                          // Contact Persons Section
                          Text(
                            'Contact Persons',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (widget.vendor.additionalContacts.isNotEmpty)
                            ...widget.vendor.additionalContacts.map(
                              (c) => _buildContactItem(c),
                            ),
                          if (widget.vendor.additionalContacts.isEmpty)
                            _buildContactItem(
                              model.ContactPerson(
                                name: widget.vendor.contactPerson,
                                role: 'Primary Contact',
                                phone: widget.vendor.mobileNumber,
                                email: widget.vendor.email,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // History Sidebar (Right)
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'History',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Previous interactions with this Vendor',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Timeline
                          Expanded(
                            child: _isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  )
                                : _transactionHistory.isEmpty
                                ? Center(
                                    child: Text(
                                      'No history available',
                                      style: GoogleFonts.inter(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: _transactionHistory.length,
                                    itemBuilder: (context, index) {
                                      final transaction =
                                          _transactionHistory[index];
                                      final istDate = transaction.date
                                          .toUtc()
                                          .add(Duration(hours: 5, minutes: 30));
                                      final formattedDate = DateFormat(
                                        'dd MMM yyyy, hh:mm a',
                                      ).format(istDate);

                                      return _buildTimelineItem(
                                        transaction: transaction,
                                        date: formattedDate,
                                        isFirst: index == 0,
                                        isLast:
                                            index ==
                                            _transactionHistory.length - 1,
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    Color? color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color ?? Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(width: 24), // Extra spacing for ease of layout
      ],
    );
  }

  Widget _buildTimelineItem({
    required _VendorTransaction transaction,
    required String date,
    required bool isFirst,
    required bool isLast,
  }) {
    IconData icon;
    Color color;
    String title;
    String subtitle;
    String amountStr = '';

    switch (transaction.type) {
      case _TransactionType.purchaseOrder:
        icon = Icons.inventory_2_outlined;
        color = Colors.blue;
        title = 'Order Placed: ${transaction.reference}';
        subtitle = transaction.description;
        // Only show amount if meaningful (e.g. > 0)
        if (transaction.amount > 0) {
          amountStr = '₹${transaction.amount.toStringAsFixed(2)}';
        }
        break;
      case _TransactionType.debitNote:
        icon = Icons.assignment_return_outlined;
        color = Colors.orange;
        title = 'Debit Note Issued';
        subtitle = '${transaction.description} (${transaction.reference})';
        amountStr = '- ₹${transaction.amount.toStringAsFixed(2)}';
        break;
      case _TransactionType.payment:
        icon = Icons.payment_outlined;
        color = Colors.green;
        title = 'Payment Made';
        subtitle = '${transaction.reference} ${transaction.description}';
        amountStr = '- ₹${transaction.amount.toStringAsFixed(2)}';
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Line & Dot
          Column(
            children: [
              Container(
                width: 1,
                height: 5,
                color: isFirst ? Colors.transparent : Colors.grey.shade300,
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withOpacity(0.5)),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              Expanded(
                child: Container(
                  width: 1,
                  color: isLast ? Colors.transparent : Colors.grey.shade300,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      if (amountStr.isNotEmpty)
                        Text(
                          amountStr,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color:
                                transaction.type ==
                                    _TransactionType.purchaseOrder
                                ? Colors.black
                                : color,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ... other methods ...
}

enum _TransactionType { purchaseOrder, debitNote, payment }

class _VendorTransaction {
  final String id;
  final DateTime date;
  final _TransactionType type;
  final String reference; // PO Number, DN ID, Payment Mode
  final double amount;
  final String description; // Status, Reason, Notes
  final String? status;

  _VendorTransaction({
    required this.id,
    required this.date,
    required this.type,
    required this.reference,
    required this.amount,
    required this.description,
    this.status,
  });
}

Widget _buildDetailItem(String label, String value) {
  return SizedBox(
    width: 200,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  );
}

Widget _buildContactItem(model.ContactPerson contact) {
  return Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade100),
    ),
    child: Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade300,
            image: contact.avatarUrl != null
                ? DecorationImage(
                    image: NetworkImage(contact.avatarUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          alignment: Alignment.center,
          child: contact.avatarUrl == null
              ? Text(
                  contact.name.substring(0, 1).toUpperCase(),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.grey.shade700,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact.name,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                contact.email,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              Row(
                children: [
                  Text(
                    contact.role,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    contact.phone,
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
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Text(
            'Contact',
            style: GoogleFonts.inter(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
