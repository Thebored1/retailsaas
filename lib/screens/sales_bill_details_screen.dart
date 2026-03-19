import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:retailsaas/data/database/app_database.dart';
import 'package:retailsaas/locator.dart';
import 'package:drift/drift.dart' as drift;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:retailsaas/data/database/tables/bill_items.dart';

class SalesBillDetailsScreen extends StatefulWidget {
  final String billId;

  const SalesBillDetailsScreen({super.key, required this.billId});

  @override
  State<SalesBillDetailsScreen> createState() => _SalesBillDetailsScreenState();
}

class _SalesBillDetailsScreenState extends State<SalesBillDetailsScreen> {
  final _db = getIt<AppDatabase>();

  bool _isLoading = true;
  SalesBill? _bill;
  List<BillPayment> _payments = [];
  List<BillItem> _items = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // 1. Fetch Bill
      final bill = await (_db.select(
        _db.salesBills,
      )..where((tbl) => tbl.id.equals(widget.billId))).getSingleOrNull();

      if (bill == null) {
        setState(() => _isLoading = false);
        return;
      }

      // 2. Fetch Payments
      final payments = await (_db.select(
        _db.billPayments,
      )..where((tbl) => tbl.billId.equals(widget.billId))).get();

      // 3. Fetch Items (Now from BillItems table)
      final items = await (_db.select(
        _db.billItems,
      )..where((tbl) => tbl.billId.equals(widget.billId))).get();

      setState(() {
        _bill = bill;
        _payments = payments;
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading sales bill details: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_bill == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: const Center(child: Text('Sales Bill not found')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text(
          'Sale Details',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: _printReceipt,
            icon: const Icon(Icons.print),
            tooltip: 'Print Receipt',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
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
                            'Bill #${_bill!.id.length > 8 ? _bill!.id.substring(0, 8) : _bill!.id}', // Truncate UUID for display
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat(
                              'dd MMM yyyy, hh:mm a',
                            ).format(_bill!.date),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green.shade100),
                        ),
                        child: Text(
                          _bill!.paymentStatus,
                          style: GoogleFonts.inter(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  Text(
                    'Customer',
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _bill!.customerName ?? 'Walk-in Customer',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Items List
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Items Purchased',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      final isReturn = item.quantity < 0;
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (isReturn)
                                        Container(
                                          margin: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade100,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            border: Border.all(
                                              color: Colors.red,
                                            ),
                                          ),
                                          child: Text(
                                            'RETURN',
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red.shade900,
                                            ),
                                          ),
                                        ),
                                      Expanded(
                                        child: Text(
                                          item.productName,
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.quantity.toStringAsFixed(0)} x Rs. ${item.unitPrice.toStringAsFixed(2)}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: isReturn
                                          ? Colors.red.shade700
                                          : Colors.grey,
                                      fontWeight: isReturn
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  if (item.warrantyEndDate != null) ...[
                                    const SizedBox(height: 8),
                                    Builder(
                                      builder: (context) {
                                        final isExpired = DateTime.now()
                                            .isAfter(item.warrantyEndDate!);
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isExpired
                                                ? Colors.red.shade50
                                                : Colors.green.shade50,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            border: Border.all(
                                              color: isExpired
                                                  ? Colors.red.shade200
                                                  : Colors.green.shade200,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                isExpired
                                                    ? Icons.error_outline
                                                    : Icons
                                                          .check_circle_outline,
                                                size: 14,
                                                color: isExpired
                                                    ? Colors.red.shade700
                                                    : Colors.green.shade700,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                isExpired
                                                    ? 'EXPIRED'
                                                    : 'WARRANTY VALID',
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: isExpired
                                                      ? Colors.red.shade700
                                                      : Colors.green.shade700,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '(${DateFormat('dd MMM yyyy').format(item.warrantyEndDate!)})',
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Text(
                              'Rs. ${item.totalAmount.toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isReturn ? Colors.red : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Grand Total',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Rs. ${_bill!.grandTotal.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Payment Details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment History',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._payments.map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.payment, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                p.paymentMode,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (p.referenceNo != null &&
                                  p.referenceNo!.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '(${p.referenceNo})',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            '₹${p.amount.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _printReceipt() async {
    final font = await PdfGoogleFonts.interRegular();
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(base: font),
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  _bill!.customerName == 'Warranty Swap'
                      ? 'WARRANTY REPLACEMENT'
                      : 'Jiyalal Stores',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  'Plot 42, Mumbai - 400001',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Bill #: ${_bill!.id.length > 8 ? _bill!.id.substring(0, 8) : _bill!.id}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                  pw.Text(
                    DateFormat('dd/MM/yy hh:mm').format(_bill!.date),
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              // Items
              ..._items.map((item) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(
                          child: pw.Text(
                            item.productName,
                            style: const pw.TextStyle(fontSize: 12),
                          ),
                        ),
                        pw.Text(
                          'Rs. ${item.totalAmount.toStringAsFixed(2)}',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Text(
                          '${item.quantity.toStringAsFixed(0)} x Rs. ${item.unitPrice.toStringAsFixed(2)}',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: item.quantity < 0
                                ? PdfColors.red
                                : PdfColors.grey700,
                          ),
                        ),
                        if (item.quantity < 0)
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(left: 4),
                            child: pw.Text(
                              '(RETURN)',
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.red,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (item.warrantyEndDate != null)
                      pw.Container(
                        margin: const pw.EdgeInsets.only(top: 2),
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black),
                          borderRadius: const pw.BorderRadius.all(
                            pw.Radius.circular(2),
                          ),
                        ),
                        child: pw.Text(
                          'Warranty Exp: ${DateFormat('dd MMM yyyy').format(item.warrantyEndDate!)}',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold, // BOLD as requested
                          ),
                        ),
                      ),
                    pw.SizedBox(height: 5),
                  ],
                );
              }).toList(),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Total',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    'Rs. ${_bill!.grandTotal.toStringAsFixed(2)}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text(
                  'Thank you for shopping!',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }
}
