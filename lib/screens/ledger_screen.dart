import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:retailsaas/data/database/app_database.dart';
import 'package:retailsaas/locator.dart';

import 'package:retailsaas/screens/sales_bill_details_screen.dart';
import 'package:retailsaas/screens/purchase_order_screen.dart';
import 'package:retailsaas/screens/goods_receipt_screen.dart';
import 'package:retailsaas/screens/debit_note_details_screen.dart';
import 'package:retailsaas/screens/vendor_payment_details_screen.dart';

class LedgerScreen extends StatelessWidget {
  const LedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = getIt<AppDatabase>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'General Ledger',
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
            icon: const Icon(Icons.sync, color: Colors.black),
            tooltip: 'Sync with Database',
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Syncing Ledger...')),
              );
              await db.syncLedger();
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Ledger Synced!')));
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<GeneralLedgerData>>(
        stream: db.watchLedger(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final entries = snapshot.data ?? [];

          if (entries.isEmpty) {
            return Center(
              child: Text(
                'No ledger entries found',
                style: GoogleFonts.inter(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final isCredit = entry.credit > 0;
              final amount = isCredit ? entry.credit : entry.debit;
              final color = isCredit ? Colors.green : Colors.red;
              final prefix = isCredit ? '+' : '-';

              IconData icon;
              switch (entry.type) {
                case 'SALE':
                  icon = Icons.receipt_long;
                  break;
                case 'PURCHASE':
                  icon = Icons.inventory;
                  break;
                case 'DEBIT_NOTE':
                  icon = Icons.remove_circle_outline;
                  break;
                case 'PAYMENT':
                  icon = Icons.payment;
                  break;
                default:
                  icon = Icons.list_alt;
              }

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade100,
                  foregroundColor: Colors.black,
                  child: Icon(icon, size: 20),
                ),
                title: Text(
                  entry.description,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      '${DateFormat('dd MMM yyyy, hh:mm a').format(entry.date)} • ${entry.type}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    if (entry.referenceId != null)
                      Text(
                        'Ref: ${entry.referenceId!.substring(0, entry.referenceId!.length > 8 ? 8 : entry.referenceId!.length)}...',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.grey.shade400,
                        ),
                      ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$prefix₹${amount.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
                onTap: () async {
                  if (entry.referenceId == null) return;

                  if (entry.type == 'SALE') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            SalesBillDetailsScreen(billId: entry.referenceId!),
                      ),
                    );
                  } else if (entry.type == 'PURCHASE') {
                    if (entry.referenceTable == 'purchase_orders') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PurchaseOrderScreen(
                            existingOrderId: entry.referenceId,
                          ),
                        ),
                      );
                    } else if (entry.referenceTable == 'goods_receipts') {
                      // Fetch GRN to get PO and Vendor details
                      final grn =
                          await (db.select(db.goodsReceipts)..where(
                                (tbl) => tbl.id.equals(entry.referenceId!),
                              ))
                              .getSingleOrNull();

                      if (grn != null) {
                        final po =
                            await (db.select(db.purchaseOrders)
                                  ..where((tbl) => tbl.id.equals(grn.poId)))
                                .getSingleOrNull();

                        if (po != null) {
                          final vendor =
                              await (db.select(
                                    db.vendors,
                                  )..where((tbl) => tbl.id.equals(po.vendorId)))
                                  .getSingleOrNull();

                          if (vendor != null && context.mounted) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => GoodsReceiptScreen(
                                  poId: po.id,
                                  poNumber: po.poNumber,
                                  vendor: {
                                    'name': vendor.name,
                                    'address': vendor.address,
                                    'contact': vendor.contact,
                                    'email': vendor.email,
                                    'gstin': vendor.gstin,
                                    'stateCode': vendor.stateCode,
                                  },
                                  isReadOnly: true,
                                  initialBillNumber: grn
                                      .grnNumber, // Used as Bill No in display logic
                                ),
                              ),
                            );
                          }
                        }
                      }
                    }
                  } else if (entry.type == 'DEBIT_NOTE') {
                    final dn =
                        await (db.select(db.debitNotes)..where(
                              (tbl) => tbl.id.equals(entry.referenceId!),
                            ))
                            .getSingleOrNull();

                    if (dn != null && context.mounted) {
                      if (dn.poId != null) {
                        // Check if PO exists (optional, but good for data integrity)
                        final po =
                            await (db.select(db.purchaseOrders)
                                  ..where((tbl) => tbl.id.equals(dn.poId!)))
                                .getSingleOrNull();

                        if (po != null && context.mounted) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DebitNoteDetailsScreen(
                                dnId: dn.id,
                                poId: dn.poId!,
                                isReadOnly: true,
                              ),
                            ),
                          );
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Purchase Order for this Debit Note not found',
                                ),
                              ),
                            );
                          }
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Debit Note is not linked to a Purchase Order',
                              ),
                            ),
                          );
                        }
                      }
                    }
                  } else if (entry.type == 'PAYMENT') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => VendorPaymentDetailsScreen(
                          paymentId: entry.referenceId!,
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
