import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:retailsaas/data/database/app_database.dart';
import 'package:retailsaas/locator.dart';

import 'package:retailsaas/utils/payment_advice_pdf.dart';

class VendorPaymentDetailsScreen extends StatefulWidget {
  final String paymentId;

  const VendorPaymentDetailsScreen({super.key, required this.paymentId});

  @override
  State<VendorPaymentDetailsScreen> createState() =>
      _VendorPaymentDetailsScreenState();
}

class _VendorPaymentDetailsScreenState
    extends State<VendorPaymentDetailsScreen> {
  late AppDatabase _db;
  VendorPayment? _payment;
  Vendor? _vendor;
  List<Map<String, dynamic>> _allocations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _db = getIt<AppDatabase>();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // 1. Fetch Payment Details
      final payment = await (_db.select(
        _db.vendorPayments,
      )..where((tbl) => tbl.id.equals(widget.paymentId))).getSingleOrNull();

      if (payment == null) {
        setState(() => _isLoading = false);
        return;
      }

      // 2. Fetch Vendor Details
      final vendor = await (_db.select(
        _db.vendors,
      )..where((tbl) => tbl.id.equals(payment.vendorId))).getSingleOrNull();

      // 3. Fetch Allocations and Linked GRNs
      final allocations = await (_db.select(
        _db.paymentAllocations,
      )..where((tbl) => tbl.paymentId.equals(payment.id))).get();

      List<Map<String, dynamic>> allocationDetails = [];
      for (var allocation in allocations) {
        final grn = await (_db.select(
          _db.goodsReceipts,
        )..where((tbl) => tbl.id.equals(allocation.grnId))).getSingleOrNull();

        if (grn != null) {
          allocationDetails.add({
            'grnNumber': grn.grnNumber,
            'grnDate': grn.grnDate,
            'totalAmount': grn.totalAmount, // Added for PDF
            'allocatedAmount': allocation.allocatedAmount,
          });
        }
      }

      if (mounted) {
        setState(() {
          _payment = payment;
          _vendor = vendor;
          _allocations = allocationDetails;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading payment details: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_payment == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Payment Not Found',
            style: GoogleFonts.inter(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: const Center(child: Text('Payment record not found')),
      );
    }

    return Scaffold(
      backgroundColor:
          Colors.grey.shade50, // Slightly off-white background for SaaS feel
      appBar: AppBar(
        title: Text(
          'Payment Details',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: OutlinedButton.icon(
              onPressed: () async {
                if (_vendor != null) {
                  await PaymentAdvicePdf.generateAndShare(
                    payment: _payment!,
                    vendor: _vendor!,
                    allocations: _allocations,
                  );
                }
              },
              icon: const Icon(Icons.share, size: 18),
              label: Text('Share Advice', style: GoogleFonts.inter()),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue.shade700,
                side: BorderSide(color: Colors.blue.shade200),
                backgroundColor: Colors.blue.shade50,
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Summary Card
                _buildSummaryCard(),
                const SizedBox(height: 24),

                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildInfoSection()),
                      const SizedBox(width: 24),
                      Expanded(child: _buildVendorSection()),
                    ],
                  )
                else
                  Column(
                    children: [
                      _buildInfoSection(),
                      const SizedBox(height: 24),
                      _buildVendorSection(),
                    ],
                  ),

                const SizedBox(height: 32),

                // Allocations Table
                Text(
                  'Bill Allocations',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildAllocationsTable(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              color: Colors.green.shade600,
              size: 32,
            ),
          ),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Paid Amount',
                style: GoogleFonts.inter(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₹${_payment!.amount.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.0,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Text(
              'PAYMENT SUCCESSFUL',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return _buildSectionCard(
      title: 'Payment Information',
      icon: Icons.receipt_long,
      children: [
        _buildDetailRow(
          'Date',
          DateFormat('dd MMM yyyy, hh:mm a').format(_payment!.date),
        ),
        const Divider(height: 24),
        _buildDetailRow('Payment Mode', _payment!.mode),
        if (_payment!.reference != null && _payment!.reference!.isNotEmpty) ...[
          const Divider(height: 24),
          _buildDetailRow('Reference #', _payment!.reference!),
        ],
        if (_payment!.notes != null && _payment!.notes!.isNotEmpty) ...[
          const Divider(height: 24),
          _buildDetailRow('Notes', _payment!.notes!),
        ],
      ],
    );
  }

  Widget _buildVendorSection() {
    if (_vendor == null) return const SizedBox.shrink();
    return _buildSectionCard(
      title: 'Vendor Details',
      icon: Icons.store,
      children: [
        _buildDetailRow('Vendor Name', _vendor!.name),
        if (_vendor!.contact.isNotEmpty) ...[
          const Divider(height: 24),
          _buildDetailRow('Contact', _vendor!.contact),
        ],
        if (_vendor!.email != null && _vendor!.email!.isNotEmpty) ...[
          const Divider(height: 24),
          _buildDetailRow('Email', _vendor!.email!),
        ],
        if (_vendor!.gstin != null && _vendor!.gstin!.isNotEmpty) ...[
          const Divider(height: 24),
          _buildDetailRow('GSTIN', _vendor!.gstin!),
        ],
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildAllocationsTable() {
    if (_allocations.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 48,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No specific bills allocated.',
              style: GoogleFonts.inter(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade50),
          dataRowMinHeight: 50,
          dataRowMaxHeight: 50,
          columnSpacing: 24,
          columns: const [
            DataColumn(label: Text('Bill Date')),
            DataColumn(label: Text('Bill Number')),
            DataColumn(
              label: Text('Total Bill Amount', textAlign: TextAlign.right),
            ),
            DataColumn(
              label: Text('Allocated Amount', textAlign: TextAlign.right),
            ),
          ],
          rows: _allocations.map((item) {
            final totalAmount = item['totalAmount'] as double? ?? 0.0;
            final allocatedAmount = item['allocatedAmount'] as double;

            return DataRow(
              cells: [
                DataCell(
                  Text(
                    DateFormat('dd MMM yyyy').format(item['grnDate']),
                    style: GoogleFonts.inter(color: Colors.grey.shade800),
                  ),
                ),
                DataCell(
                  Text(
                    item['grnNumber'],
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  ),
                ),
                DataCell(
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '₹${totalAmount.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(color: Colors.grey.shade600),
                    ),
                  ),
                ),
                DataCell(
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '₹${allocatedAmount.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 14),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
