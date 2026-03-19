import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:drift/drift.dart' as drift;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:retailsaas/locator.dart';
import 'package:retailsaas/data/database/app_database.dart';
import 'package:intl/intl.dart';

class OrderSuccessScreen extends StatefulWidget {
  final VoidCallback onBackToPos;
  final String animationPath;
  final String title;
  final String subtitle;
  final String buttonText;
  final bool loopAnimation;
  final String? billId;

  const OrderSuccessScreen({
    super.key,
    required this.onBackToPos,
    this.animationPath = 'assets/animations/wallet_animation.json',
    this.buttonText = 'Back to POS',
    this.loopAnimation = true,
    this.title = 'Order Placed Successfully!',
    this.subtitle = 'Redirecting to POS in 10 seconds...',
    this.billId,
  });

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Auto-close after 10 seconds
    _timer = Timer(const Duration(seconds: 10), () {
      if (mounted && Navigator.of(context).canPop()) {
        widget.onBackToPos();
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleBack() {
    _timer?.cancel();
    if (mounted && Navigator.of(context).canPop()) {
      widget.onBackToPos();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Animation
            SizedBox(
              width: 300,
              height: 300,
              child: Lottie.asset(
                widget.animationPath,
                fit: BoxFit.contain,
                repeat: widget.loopAnimation,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              widget.title,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              widget.subtitle,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            // Back to POS Button
            ElevatedButton(
              onPressed: _handleBack,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                widget.buttonText,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (widget.billId != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => _printReceipt(widget.billId!),
                icon: const Icon(Icons.print),
                label: Text(
                  'Print Receipt',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _printReceipt(String billId) async {
    final db = getIt<AppDatabase>();

    // 1. Fetch Bill
    final bill = await (db.select(
      db.salesBills,
    )..where((tbl) => tbl.id.equals(billId))).getSingleOrNull();

    if (bill == null) return;

    // 2. Fetch Items
    final items = await (db.select(
      db.billItems,
    )..where((tbl) => tbl.billId.equals(billId))).get();

    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  bill.customerName == 'Warranty Swap'
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
                    'Bill #: ${bill.id.length > 8 ? bill.id.substring(0, 8) : bill.id}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                  pw.Text(
                    DateFormat('dd/MM/yy hh:mm').format(bill.date),
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              // Items
              ...items.map((item) {
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
                            fontWeight: pw.FontWeight.bold,
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
                    'Rs. ${bill.grandTotal.toStringAsFixed(2)}',
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
