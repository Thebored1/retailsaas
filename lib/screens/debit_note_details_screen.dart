import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retailsaas/widgets/admin_side_menu.dart';
import 'package:retailsaas/screens/admin_main_screen.dart';
import 'package:drift/drift.dart' as drift;
import 'package:retailsaas/data/database/app_database.dart';
import 'package:retailsaas/locator.dart';
import 'package:intl/intl.dart';

class DebitNoteDetailsScreen extends StatefulWidget {
  final String dnId;
  final String poId;
  final bool isReadOnly;

  const DebitNoteDetailsScreen({
    super.key,
    required this.dnId,
    required this.poId,
    this.isReadOnly = false,
  });

  @override
  State<DebitNoteDetailsScreen> createState() => _DebitNoteDetailsScreenState();
}

class _DebitNoteDetailsScreenState extends State<DebitNoteDetailsScreen> {
  final _db = getIt<AppDatabase>();

  // Header State
  String _dnNumber = '';
  String _vendorName = '';
  String _poNumber = '';
  DateTime _date = DateTime.now();
  String _status = 'Draft';

  // Grid State
  List<DnItem> _dnItems = [];

  // Footer State
  final TextEditingController _notesController = TextEditingController();

  // Reason dropdown options
  final List<String> _reasonOptions = [
    'Damaged',
    'Expired',
    'Wrong Item',
    'Quality Issue',
    'Quantity Mismatch',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadDebitNoteData();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadDebitNoteData() async {
    try {
      // Load DN header
      final dn = await (_db.select(
        _db.debitNotes,
      )..where((tbl) => tbl.id.equals(widget.dnId))).getSingleOrNull();

      if (dn != null) {
        // Load vendor
        final vendor = await (_db.select(
          _db.vendors,
        )..where((tbl) => tbl.id.equals(dn.vendorId))).getSingleOrNull();

        // Load PO
        final po = await (_db.select(
          _db.purchaseOrders,
        )..where((tbl) => tbl.id.equals(widget.poId))).getSingleOrNull();

        setState(() {
          _dnNumber = dn.id;
          _vendorName = vendor?.name ?? 'Unknown Vendor';
          _poNumber = po?.poNumber ?? '-';
          _date = dn.date;
          _status = dn.status;
          _notesController.text = dn.notes ?? '';
        });
      }

      // Load PO items
      final poItems = await (_db.select(
        _db.purchaseOrderItems,
      )..where((tbl) => tbl.poId.equals(widget.poId))).get();

      // Load existing DN items if any
      final dnItems = await (_db.select(
        _db.debitNoteItems,
      )..where((tbl) => tbl.dnId.equals(widget.dnId))).get();

      print('DEBUG: dnItems count: ${dnItems.length}');

      // Fallback: If no DN items found (e.g. auto-created header only),
      // fetch aggregated rejected quantities from GRNs for this PO.
      Map<String, double> aggregatedRejections = {};
      if (dnItems.isEmpty) {
        print('DEBUG: Entering Fallback Mode');
        // 1. Get GRNs for PO
        final grns = await (_db.select(
          _db.goodsReceipts,
        )..where((tbl) => tbl.poId.equals(widget.poId))).get();
        final grnIds = grns.map((g) => g.id).toList();
        print('DEBUG: Found GRNs: $grnIds');

        // 2. Get GRN Items
        final grnItems = await (_db.select(
          _db.goodsReceiptItems,
        )..where((tbl) => tbl.grnId.isIn(grnIds))).get();
        print('DEBUG: Found ${grnItems.length} GRN Items');

        // 3. Aggregate Rejections
        for (var gi in grnItems) {
          print('DEBUG: Item ${gi.productId} Rejected: ${gi.rejectedQty}');
          aggregatedRejections[gi.productId] =
              (aggregatedRejections[gi.productId] ?? 0) + gi.rejectedQty;
        }
        print('DEBUG: Aggregated: $aggregatedRejections');
      }

      setState(() {
        _dnItems = poItems.map((poItem) {
          // Find matching DN item if exists
          final existingDnItem = dnItems.cast<DebitNoteItem?>().firstWhere(
            (dnItem) => dnItem?.productId == poItem.productId,
            orElse: () => null,
          );

          final fallbackQty = aggregatedRejections[poItem.productId] ?? 0.0;
          print(
            'DEBUG: Mapping ${poItem.productName} (${poItem.productId}) -> Existing: ${existingDnItem?.rejectedQty}, Fallback: $fallbackQty',
          );

          return DnItem(
            id: poItem.productId,
            name: poItem.productName,
            orderedQty: poItem.quantity,
            rejectedQty:
                existingDnItem?.rejectedQty ??
                fallbackQty.toInt(), // Use fallback if no existing item
            reason: existingDnItem?.reason ?? _reasonOptions[0],
            rate: poItem.unitPrice,
            taxRate: poItem.taxRate + poItem.cessRate,
          );
        }).toList();
      });
    } catch (e) {
      debugPrint('Error loading DN data: $e');
    }
  }

  double get _totalAmount {
    return _dnItems.fold(
      0.0,
      (sum, item) =>
          sum + (item.rejectedQty * item.rate * (1 + item.taxRate / 100)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1100;

        return Scaffold(
          backgroundColor: const Color(0xFFF0F4F8),
          body: Row(
            children: [
              if (isDesktop)
                AdminSideMenu(
                  selectedItem: 'Debit Notes',
                  onItemSelected: (item) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) =>
                            AdminMainScreen(initialItem: item),
                      ),
                      (route) => false,
                    );
                  },
                ),
              Expanded(
                child: Column(
                  children: [
                    // AppBar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => Navigator.of(context).pop(),
                                tooltip: 'Back',
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Debit Note Details',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Main content
                    Expanded(
                      child: Shortcuts(
                        shortcuts: {
                          LogicalKeySet(
                            LogicalKeyboardKey.control,
                            LogicalKeyboardKey.keyS,
                          ): const SaveIntent(),
                        },
                        child: Actions(
                          actions: {
                            SaveIntent: CallbackAction<SaveIntent>(
                              onInvoke: (_) => _saveDN(),
                            ),
                          },
                          child: Column(
                            children: [
                              _buildHeaderZone(),
                              Expanded(child: _buildItemsGrid()),
                              _buildFooterZone(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderZone() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('DEBIT NOTE'),
                const SizedBox(height: 8),
                Text(
                  _dnNumber,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabel('VENDOR'),
                const SizedBox(height: 4),
                Text(
                  _vendorName,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
          Container(width: 1, height: 100, color: Colors.grey.shade200),
          const SizedBox(width: 48),
          // Right Side
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('PO REFERENCE'),
                          const SizedBox(height: 4),
                          Text(
                            _poNumber,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('DATE'),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('dd MMM yyyy').format(_date),
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildLabel('STATUS'),
                const SizedBox(height: 4),
                _buildStatusChip(_status),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsGrid() {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                _buildHeaderCell('#', flex: 1),
                _buildHeaderCell('Item Name', flex: 4),
                _buildHeaderCell('Ordered', flex: 2, align: TextAlign.center),
                _buildHeaderCell('Rejected', flex: 2, align: TextAlign.center),
                _buildHeaderCell('Reason', flex: 3, align: TextAlign.center),
                _buildHeaderCell('Rate (₹)', flex: 2, align: TextAlign.right),
                _buildHeaderCell('Total (₹)', flex: 2, align: TextAlign.right),
              ],
            ),
          ),
          // Table Body
          Expanded(
            child: ListView.separated(
              itemCount: _dnItems.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = _dnItems[index];
                return Container(
                  color: item.rejectedQty > 0
                      ? Colors.red.shade50
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      _buildCell('${index + 1}', flex: 1),
                      _buildCell(item.name, flex: 4, isBold: true),
                      _buildCell(
                        '${item.orderedQty}',
                        flex: 2,
                        align: TextAlign.center,
                        color: Colors.grey,
                      ),
                      // Rejected Qty (Editable)
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Container(
                            width: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.red.shade200),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: TextField(
                              enabled: !widget.isReadOnly,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              controller:
                                  TextEditingController(
                                      text: '${item.rejectedQty}',
                                    )
                                    ..selection = TextSelection.collapsed(
                                      offset: '${item.rejectedQty}'.length,
                                    ),
                              onChanged: (val) {
                                final newVal = int.tryParse(val);
                                setState(() {
                                  item.rejectedQty = newVal ?? 0;
                                });
                              },
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Reason Dropdown
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            height: 36,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: widget.isReadOnly
                                  ? Colors.grey.shade100
                                  : Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: item.reason,
                                isExpanded: true,
                                isDense: true,
                                items: _reasonOptions.map((reason) {
                                  return DropdownMenuItem(
                                    value: reason,
                                    child: Text(
                                      reason,
                                      style: GoogleFonts.inter(fontSize: 13),
                                    ),
                                  );
                                }).toList(),
                                onChanged: widget.isReadOnly
                                    ? null
                                    : (val) {
                                        setState(() {
                                          item.reason = val!;
                                        });
                                      },
                              ),
                            ),
                          ),
                        ),
                      ),
                      _buildCell(
                        item.rate.toStringAsFixed(2),
                        flex: 2,
                        align: TextAlign.right,
                      ),
                      _buildCell(
                        (item.rejectedQty * item.rate).toStringAsFixed(2),
                        flex: 2,
                        align: TextAlign.right,
                        isBold: true,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterZone() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Notes Section
            _buildLabel('ADDITIONAL NOTES (Optional)'),
            const SizedBox(height: 8),
            Container(
              height: 80,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.isReadOnly ? Colors.grey.shade100 : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _notesController,
                readOnly: widget.isReadOnly,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add any additional notes or comments...',
                  hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
                ),
                style: GoogleFonts.inter(fontSize: 14),
              ),
            ),
            const SizedBox(height: 24),
            // Action Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Total Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Debit Amount',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${_totalAmount.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
                // Action Buttons
                Row(
                  children: [
                    if (!widget.isReadOnly) ...[
                      SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _saveDN,
                          icon: const Icon(Icons.save, size: 20),
                          label: Text(
                            'Save DN\n(Ctrl + S)',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(height: 1.2),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    OutlinedButton.icon(
                      onPressed: _printDN,
                      icon: const Icon(Icons.print, size: 20),
                      label: Text(
                        'Print',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _emailDN,
                      icon: const Icon(Icons.email, size: 20),
                      label: Text(
                        'Email',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade600,
        letterSpacing: 0.5,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHeaderCell(
    String text, {
    int flex = 1,
    TextAlign align = TextAlign.left,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildCell(
    String text, {
    int flex = 1,
    TextAlign align = TextAlign.left,
    bool isBold = false,
    Color? color,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: GoogleFonts.inter(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
          color: color,
        ),
      ),
    );
  }

  Future<void> _saveDN() async {
    try {
      // Update DN header
      await (_db.update(
        _db.debitNotes,
      )..where((tbl) => tbl.id.equals(widget.dnId))).write(
        DebitNotesCompanion(
          amount: drift.Value(_totalAmount),
          notes: drift.Value(_notesController.text),
        ),
      );

      // Save DN items
      for (final item in _dnItems.where((i) => i.rejectedQty > 0)) {
        await _db
            .into(_db.debitNoteItems)
            .insert(
              DebitNoteItemsCompanion.insert(
                dnId: widget.dnId,
                productId: item.id,
                productName: item.name,
                orderedQty: item.orderedQty,
                rejectedQty: item.rejectedQty,
                reason: item.reason,
                rate: item.rate,
                taxRate: item.taxRate,
              ),
              mode: drift.InsertMode.insertOrReplace,
            );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debit Note saved successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving DN: $e')));
      }
    }
  }

  void _printDN() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.print, color: Colors.grey.shade700),
            const SizedBox(width: 8),
            const Text('Print Debit Note'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Print $_dnNumber?',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPrintDetailRow('Vendor:', _vendorName),
                  const SizedBox(height: 4),
                  _buildPrintDetailRow('PO Reference:', _poNumber),
                  const SizedBox(height: 4),
                  _buildPrintDetailRow(
                    'Amount:',
                    '₹${_totalAmount.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 4),
                  _buildPrintDetailRow(
                    'Items:',
                    '${_dnItems.where((i) => i.rejectedQty > 0).length} rejected',
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Debit Note $_dnNumber sent to printer',
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: Colors.green.shade700,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.print, size: 16),
            label: const Text('Print'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade700,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrintDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  void _emailDN() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Email sent to $_vendorName'),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }
}

// Helper class for DN items
class DnItem {
  final String id;
  final String name;
  final int orderedQty;
  int rejectedQty;
  String reason;
  final double rate;
  final double taxRate;

  DnItem({
    required this.id,
    required this.name,
    required this.orderedQty,
    required this.rejectedQty,
    required this.reason,
    required this.rate,
    required this.taxRate,
  });
}

class SaveIntent extends Intent {
  const SaveIntent();
}
