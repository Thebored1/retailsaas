import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:retailsaas/data/database/app_database.dart';

class PaymentAdvicePdf {
  static Future<void> generateAndShare({
    required VendorPayment payment,
    required Vendor vendor,
    required List<Map<String, dynamic>> allocations,
  }) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.interRegular();
    final fontBold = await PdfGoogleFonts.interBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'PAYMENT ADVICE',
                    style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 24,
                      color: PdfColors.blueGrey800,
                    ),
                  ),
                  pw.Text(
                    DateFormat('dd MMM yyyy').format(payment.date),
                    style: pw.TextStyle(font: font, fontSize: 12),
                  ),
                ],
              ),
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.SizedBox(height: 20),

              // Vendor & Payment Details
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  // To: Vendor
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'To:',
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 10,
                          color: PdfColors.grey600,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        vendor.name,
                        style: pw.TextStyle(font: fontBold, fontSize: 14),
                      ),
                      if (vendor.address.isNotEmpty)
                        pw.Container(
                          width: 200,
                          child: pw.Text(
                            vendor.address,
                            style: pw.TextStyle(font: font, fontSize: 10),
                          ),
                        ),
                      if (vendor.gstin != null)
                        pw.Text(
                          'GSTIN: ${vendor.gstin}',
                          style: pw.TextStyle(font: font, fontSize: 10),
                        ),
                    ],
                  ),

                  // Payment Details
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      _buildInfoRow(
                        'Payment Mode:',
                        payment.mode,
                        font,
                        fontBold,
                      ),
                      if (payment.reference != null &&
                          payment.reference!.isNotEmpty)
                        _buildInfoRow(
                          'Reference #:',
                          payment.reference!,
                          font,
                          fontBold,
                        ),
                      _buildInfoRow(
                        'Total Amount:',
                        'INR ${payment.amount.toStringAsFixed(2)}',
                        font,
                        fontBold,
                        isHighlight: true,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 30),

              // Allocation Table
              pw.Text(
                'Payment Allocation Details',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 12,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(
                  font: fontBold,
                  fontSize: 10,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.blueGrey700,
                ),
                cellStyle: pw.TextStyle(font: font, fontSize: 10),
                headers: ['Bill Date', 'Bill No', 'Total Bill', 'Allocated'],
                data: allocations.map((item) {
                  final totalAmount = item['totalAmount'] as double? ?? 0.0;
                  final allocatedAmount = item['allocatedAmount'] as double;

                  return [
                    DateFormat(
                      'dd MMM yyyy',
                    ).format(item['grnDate'] as DateTime),
                    item['grnNumber'].toString(),
                    'INR ${totalAmount.toStringAsFixed(2)}',
                    'INR ${allocatedAmount.toStringAsFixed(2)}',
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Payment_Advice_${payment.reference ?? "Draft"}.pdf',
    );
  }

  static pw.Widget _buildInfoRow(
    String label,
    String value,
    pw.Font font,
    pw.Font fontBold, {
    bool isHighlight = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              font: font,
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ),
          pw.SizedBox(width: 8),
          pw.Text(
            value,
            style: pw.TextStyle(
              font: fontBold,
              fontSize: isHighlight ? 12 : 10,
              color: isHighlight ? PdfColors.green700 : PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
