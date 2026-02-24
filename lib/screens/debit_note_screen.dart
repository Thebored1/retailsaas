import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' as drift;
import 'package:retailsaas/data/database/app_database.dart';
import 'package:retailsaas/locator.dart';
import 'package:intl/intl.dart';
import 'package:retailsaas/screens/debit_note_form_screen.dart';
import 'package:retailsaas/screens/debit_note_details_screen.dart';
import 'package:retailsaas/screens/rma_debit_note_screen.dart';

// View Model for UI
class DebitNoteViewModel {
  final String id;
  final String poId; // Added for DB lookup
  final String vendorName;
  final String poReference;
  final String date;
  final double amount;
  final String reason;
  final String status;

  DebitNoteViewModel({
    required this.id,
    required this.poId,
    required this.vendorName,
    required this.poReference,
    required this.date,
    required this.amount,
    required this.reason,
    required this.status,
  });
}

class DebitNoteScreen extends StatelessWidget {
  const DebitNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = getIt<AppDatabase>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Text(
          'Debit Notes',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: StreamBuilder<List<drift.TypedResult>>(
        stream: (db.select(db.debitNotes)).join([
          drift.leftOuterJoin(
            db.vendors,
            db.vendors.id.equalsExp(db.debitNotes.vendorId),
          ),
          drift.leftOuterJoin(
            db.purchaseOrders,
            db.purchaseOrders.id.equalsExp(db.debitNotes.poId),
          ),
        ]).watch(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final rows = snapshot.data!;
          if (rows.isEmpty) {
            return Center(
              child: Text(
                'No Debit Notes Found',
                style: GoogleFonts.inter(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: rows.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final row = rows[index];
              final dn = row.readTable(db.debitNotes);
              final vendor = row.readTableOrNull(db.vendors);
              final po = row.readTableOrNull(db.purchaseOrders);

              final note = DebitNoteViewModel(
                id: dn.id,
                poId: dn.poId ?? '',
                vendorName: vendor?.name ?? 'Unknown Vendor',
                poReference: po?.poNumber ?? '-',
                date: DateFormat('dd MMM yyyy').format(dn.date),
                amount: dn.amount,
                reason: dn.reason,
                status: dn.status,
              );

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.assignment_return_outlined,
                      color: Colors.purple.shade700,
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        note.id,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildStatusChip(note.status),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        '${note.vendorName} • Ref: ${note.poReference}',
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        note.reason,
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date: ${note.date}',
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min, // Fix overflow
                    children: [
                      Text(
                        '₹${note.amount.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.red.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey.shade400,
                        size: 20,
                      ),
                    ],
                  ),
                  onTap: () => _showDebitNoteDetails(context, note),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton.extended(
            onPressed: () => _showCreateMenu(context),
            label: Text(
              'Create New',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            icon: const Icon(Icons.add),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          );
        },
      ),
    );
  }

  void _showCreateMenu(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;

    // Position menu above the button (standard for FABs)
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    // Show White Dropdown
    final result = await showMenu<String>(
      context: context,
      position: position,
      color: Colors.white,
      surfaceTintColor: Colors.white, // Ensure it stays white (no M3 tint)
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        PopupMenuItem(
          value: 'PO',
          child: Row(
            children: [
              Icon(Icons.receipt_long, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Against Purchase Order',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Specific PO shortages',
                    style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'RMA',
          child: Row(
            children: [
              Icon(
                Icons.broken_image_outlined,
                color: Colors.red.shade700,
                size: 20,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RMA / Damaged Return',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Return from RMA Bin',
                    style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    if (result == 'PO') {
      _showPOSelectionDialog(context);
    } else if (result == 'RMA') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RmaDebitNoteScreen()),
      );
    }
  }

  void _showPOSelectionDialog(BuildContext context) async {
    final db = getIt<AppDatabase>();

    // Fetch POs joined with Vendors
    final query = db.select(db.purchaseOrders)
      ..where((tbl) => tbl.status.equals('Completed'));

    final rows = await query.join([
      drift.leftOuterJoin(
        db.vendors,
        db.vendors.id.equalsExp(db.purchaseOrders.vendorId),
      ),
    ]).get();

    final availablePOs = rows;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Purchase Order',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: availablePOs.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No eligible Purchase Orders found.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: Colors.grey),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: availablePOs.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final row = availablePOs[index];
                    final po = row.readTable(db.purchaseOrders);
                    final vendor = row.readTableOrNull(db.vendors);
                    final vendorName = vendor?.name ?? 'Unknown';

                    return ListTile(
                      title: Text(
                        po.poNumber,
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '$vendorName • ${DateFormat('dd MMM').format(po.date)}',
                        style: GoogleFonts.inter(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pop(context); // Close Dialog
                        _navigateToDebitNoteForm(context, po, vendorName);
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToDebitNoteForm(
    BuildContext context,
    PurchaseOrder po,
    String vendorName,
  ) async {
    final db = getIt<AppDatabase>();
    // Fetch Items for PO
    final items = await (db.select(
      db.purchaseOrderItems,
    )..where((tbl) => tbl.poId.equals(po.id))).get();

    // 2. Fetch all GRNs for this PO to aggregate rejected quantities
    final grns = await (db.select(
      db.goodsReceipts,
    )..where((tbl) => tbl.poId.equals(po.id))).get();
    final grnIds = grns.map((g) => g.id).toList();

    print('DEBUG: Found ${grns.length} GRNs for PO ${po.id}: $grnIds');

    // 3. Fetch all GRN Items for these GRNs
    final grnItems = await (db.select(
      db.goodsReceiptItems,
    )..where((tbl) => tbl.grnId.isIn(grnIds))).get();
    print('DEBUG: Found ${grnItems.length} GRN Items total.');

    // 4. Map Items with Aggregated Rejected Qty
    final mockItems = items.map((i) {
      // Sum rejected qty for this product across all GRNs
      final productGrnItems = grnItems.where(
        (gi) => gi.productId == i.productId,
      );

      final totalRejected = productGrnItems.fold(
        0.0,
        (sum, gi) => sum + gi.rejectedQty,
      );

      return {
        'id': i.productId,
        'name': i.productName,
        'qty': i.quantity,
        'receivedQty':
            i.receivedQuantity ?? 0, // This is Accepted Qty in new logic
        'rejectedQty': totalRejected, // New Field
        'price': i.unitPrice,
        'taxRate': i.taxRate,
      };
    }).toList();

    if (!context.mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DebitNoteFormScreen(
          poNumber: po.poNumber,
          poId: po.id,
          vendor: {'name': vendorName, 'id': po.vendorId},
          items: mockItems,
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color bg;
    Color fg;

    switch (status) {
      case 'Draft':
        bg = Colors.grey.shade200;
        fg = Colors.grey.shade700;
        break;
      case 'Sent':
        bg = Colors.blue.shade50;
        fg = Colors.blue.shade700;
        break;
      case 'Adjusted':
        bg = Colors.green.shade50;
        fg = Colors.green.shade700;
        break;
      default:
        bg = Colors.grey.shade100;
        fg = Colors.black;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showDebitNoteDetails(BuildContext context, DebitNoteViewModel note) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DebitNoteDetailsScreen(
          dnId: note.id,
          poId: note.poId,
          isReadOnly: false, // Make editable by default
        ),
      ),
    );
  }
}
