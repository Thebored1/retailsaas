import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:retailsaas/data/database/app_database.dart';
import 'package:retailsaas/locator.dart';
import 'package:retailsaas/screens/goods_receipt_screen.dart';

class GrnHistoryButton extends StatelessWidget {
  final String poId;
  final String poNumber;
  final Vendor? vendor;

  const GrnHistoryButton({
    super.key,
    required this.poId,
    required this.poNumber,
    this.vendor,
  });

  @override
  Widget build(BuildContext context) {
    final db = getIt<AppDatabase>();

    return FutureBuilder<List<GoodsReceipt>>(
      future: (db.select(
        db.goodsReceipts,
      )..where((tbl) => tbl.poId.equals(poId))).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Alternative: return a "Create GRN" label hint if needed,
          // but usually we hide history if no history.
          // However, for PurchaseOrderScreen, we might want to show "No GRNs".
          // But sticking to existing logic: return empty sized box (hidden).
          return const SizedBox();
        }

        final grns = snapshot.data!;

        // Sorting by date descending (Newest first)
        grns.sort((a, b) => b.grnDate.compareTo(a.grnDate));

        return PopupMenuButton<String>(
          tooltip: 'View GRN History',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history, size: 16, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  '${grns.length} GRN${grns.length > 1 ? "s" : ""}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_drop_down,
                  size: 16,
                  color: Colors.blue.shade700,
                ),
              ],
            ),
          ),
          itemBuilder: (context) {
            return grns.map((grn) {
              return PopupMenuItem(
                value: grn.id,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      grn.grnNumber,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Date: ${DateFormat('dd MMM yyyy').format(grn.grnDate)}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (grn.challanNumber != null &&
                        grn.challanNumber!.isNotEmpty)
                      Text(
                        'Challan: ${grn.challanNumber}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              );
            }).toList();
          },
          onSelected: (grnId) {
            // Find the selected GRN
            final selectedGrn = grns.firstWhere((g) => g.id == grnId);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GoodsReceiptScreen(
                  poId: poId,
                  poNumber: poNumber,
                  vendor: {
                    'id': vendor?.id ?? '',
                    'name': vendor?.name ?? 'Unknown Vendor',
                  },
                  isReadOnly: true,
                  initialBillNumber: selectedGrn.grnNumber,
                  initialChallanNumber: selectedGrn.challanNumber,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
