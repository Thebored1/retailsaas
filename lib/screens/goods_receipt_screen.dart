import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retailsaas/widgets/admin_side_menu.dart';
import 'package:retailsaas/screens/admin_main_screen.dart';
import 'package:drift/drift.dart' as drift;
import 'package:retailsaas/data/database/app_database.dart';
import 'package:retailsaas/locator.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class GoodsReceiptScreen extends StatefulWidget {
  final String poId;
  final String poNumber;
  final Map<String, dynamic> vendor;
  final List<Map<String, dynamic>>? items;
  final bool isReadOnly;
  final String? initialBillNumber;
  final String? initialChallanNumber;

  const GoodsReceiptScreen({
    super.key,
    required this.poId,
    required this.poNumber,
    required this.vendor,
    this.items,
    this.isReadOnly = false,
    this.initialBillNumber,
    this.initialChallanNumber,
  });

  @override
  State<GoodsReceiptScreen> createState() => _GoodsReceiptScreenState();
}

class _GoodsReceiptScreenState extends State<GoodsReceiptScreen> {
  // Zone A: Header State
  String? _selectedPO;
  final TextEditingController _billNoController = TextEditingController();
  final TextEditingController _challanNoController = TextEditingController();
  DateTime _billDate = DateTime.now();

  // Zone B: Grid State
  List<GrnItem> _grnItems = [];
  bool _isLoading = true;
  bool _hasAssociatedDebitNote = false;

  // New Logic: Close PO Checkbox
  bool _closePoManually = false;

  // Computed Check
  bool get _hasRejection => _grnItems.any((i) => i.rejectedQty > 0);

  final _uuid = const Uuid();
  final _db = getIt<AppDatabase>();

  @override
  void initState() {
    super.initState();
    _selectedPO = widget.poNumber;
    if (widget.initialBillNumber != null) {
      _billNoController.text = widget.initialBillNumber!;
    }
    if (widget.initialChallanNumber != null) {
      _challanNoController.text = widget.initialChallanNumber!;
    }
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      if (widget.isReadOnly && widget.initialBillNumber != null) {
        await _loadHistoricalData();
      } else {
        await _loadNewGrnData();
      }
    } catch (e) {
      debugPrint('Error loading GRN data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadNewGrnData() async {
    final items = await (_db.select(
      _db.purchaseOrderItems,
    )..where((tbl) => tbl.poId.equals(widget.poId))).get();

    debugPrint('GRN: Loading items for PO ${widget.poId}');
    debugPrint('GRN: Found ${items.length} items in database');

    final grnItemFutures = items.map((item) async {
      debugPrint(
        'GRN: Processing item: ${item.productName}, Qty: ${item.quantity}',
      );
      // Fetch latest batch to get "Default" MRP
      final latestBatch =
          await (_db.select(_db.productBatches)
                ..where((tbl) => tbl.productId.equals(item.productId))
                ..orderBy([(t) => drift.OrderingTerm.desc(t.createdAt)])
                ..limit(1))
              .getSingleOrNull();

      // Pre-fill Received with Pending Amount (Ordered - Already Received)
      // Default Rejected to 0
      final pending = item.quantity - (item.receivedQuantity ?? 0);
      return GrnItem(
        id: item.productId,
        name: item.productName,
        orderedQty: item.quantity,
        alreadyReceivedQty: item.receivedQuantity ?? 0,
        receivedQty: pending > 0 ? pending : 0,
        rejectedQty: 0,
        rate: item.unitPrice,
        mrp: latestBatch?.mrp ?? 0.0, // Prefill from latest batch or 0
        taxRate: item.taxRate + item.cessRate,
        uom: item.uom,
        conversionFactor: item.conversionFactor,
      );
    });

    final grnItems = await Future.wait(grnItemFutures);

    // Fetch UOMs
    for (var item in grnItems) {
      final uoms = await (_db.select(
        _db.productUoms,
      )..where((t) => t.productId.equals(item.id))).get();
      item.availableUoms = uoms
          .map(
            (u) => {
              'name': u.uomName,
              'factor': u.conversionFactor,
              'isBase': u.isBase,
            },
          )
          .toList();

      // If UOM missing (legacy), set default
      if (item.uom == null) {
        final base = uoms.firstWhere(
          (u) => u.isBase,
          orElse: () => uoms.firstOrNull ?? (throw Exception('No UOM')),
        );
        item.uom = base.uomName;
        item.conversionFactor = base.conversionFactor;
      }
    }

    setState(() {
      _grnItems = grnItems;
    });

    debugPrint('GRN: Final _grnItems count: ${_grnItems.length}');
  }

  Future<void> _loadHistoricalData() async {
    final grn =
        await (_db.select(_db.goodsReceipts)..where(
              (tbl) =>
                  tbl.poId.equals(widget.poId) &
                  tbl.grnNumber.equals(widget.initialBillNumber!),
            ))
            .getSingleOrNull();

    if (grn == null) return;

    final historicalItems = await (_db.select(
      _db.goodsReceiptItems,
    )..where((tbl) => tbl.grnId.equals(grn.id))).get();

    final dn = await (_db.select(
      _db.debitNotes,
    )..where((tbl) => tbl.reason.like('%${grn.id}%'))).getSingleOrNull();

    // Check if PO was closed by this GRN (snapshot) - Logic not directly stored, inferred by current display needs
    // For now, we mainly need the item snapshots.

    setState(() {
      _hasAssociatedDebitNote = dn != null;

      _grnItems = historicalItems.map((item) {
        return GrnItem(
          id: item.productId,
          name: item.productName,
          orderedQty: item.orderedQty.toInt(),
          alreadyReceivedQty: 0,
          receivedQty: item.receivedQty.toInt(),
          rejectedQty: item.rejectedQty.toInt(),
          rate: item.rate,
          mrp: item.rate, // Default to rate if MRP not stored
          taxRate: item.taxRate,
          uom: item.uom,
          conversionFactor: item.conversionFactor,
        );
      }).toList();
    });
  }

  // --- Calculations ---
  double get _taxableValue {
    return _grnItems.fold(
      0.0,
      (sum, item) =>
          sum +
          (item.rate *
              item.receivedQty), // Bill is usually on Total Received (including rejected) before DN?
      // Requirement: "Ordered: 10, Received: 6. Bill Total..."
      // Usually you are billed for what you receive. If you reject, you raise a Debit Note to deduct value.
      // So Taxable Value here should be based on Received Qty.
    );
  }

  double get _totalTax {
    return _grnItems.fold(
      0.0,
      (sum, item) =>
          sum + ((item.rate * item.receivedQty) * (item.taxRate / 100)),
    );
  }

  double get _billTotal => _taxableValue + _totalTax;

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
                  selectedItem: 'Purchase Order',
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
                                'Goods Receipt Note',
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
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Shortcuts(
                              shortcuts: {
                                LogicalKeySet(
                                  LogicalKeyboardKey.control,
                                  LogicalKeyboardKey.keyS,
                                ): const SaveIntent(),
                              },
                              child: Actions(
                                actions: {
                                  SaveIntent: CallbackAction<SaveIntent>(
                                    onInvoke: (_) => _saveGrn(),
                                  ),
                                },
                                child: Column(
                                  children: [
                                    _buildHeaderZone(),
                                    Expanded(child: _buildVerificationGrid()),
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

  // --- Zone A ---
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
          // Left Side (Source)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('AGAINST PO'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedPO,
                      isExpanded: true,
                      items: [widget.poNumber].map((po) {
                        return DropdownMenuItem(
                          value: po,
                          child: Text(
                            po,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {},
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                if (widget.isReadOnly) ...[
                  _buildLabel('SELECT PAST GRN'),
                  const SizedBox(height: 8),
                  FutureBuilder<List<GoodsReceipt>>(
                    future: (_db.select(
                      _db.goodsReceipts,
                    )..where((tbl) => tbl.poId.equals(widget.poId))).get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty)
                        return const SizedBox();
                      final grns = snapshot.data!;
                      String? selectedGrnId;
                      try {
                        selectedGrnId = grns
                            .firstWhere(
                              (g) => g.grnNumber == _billNoController.text,
                            )
                            .id;
                      } catch (_) {}

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedGrnId,
                            hint: Text(
                              'Cumulative View',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            icon: Icon(
                              Icons.history,
                              size: 16,
                              color: Colors.blue.shade700,
                            ),
                            items: grns.map((grn) {
                              return DropdownMenuItem(
                                value: grn.id,
                                child: Text(
                                  '${grn.grnNumber} (${DateFormat('dd MMM').format(grn.grnDate)})',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              final selected = grns.firstWhere(
                                (g) => g.id == val,
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GoodsReceiptScreen(
                                    poId: widget.poId,
                                    poNumber: widget.poNumber,
                                    vendor: widget.vendor,
                                    isReadOnly: true,
                                    initialBillNumber: selected.grnNumber,
                                    initialChallanNumber:
                                        selected.challanNumber,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                _buildLabel('VENDOR'),
                const SizedBox(height: 4),
                Text(
                  widget.vendor['name'],
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
          // Vertical Divider
          Container(width: 1, height: 100, color: Colors.grey.shade200),
          const SizedBox(width: 48),
          // Right Side
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _billNoController,
                        label: 'Vendor Bill No',
                        placeholder: 'e.g. INV-9923',
                        readOnly: widget.isReadOnly,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDatePicker(
                        label: 'Bill Date',
                        date: _billDate,
                        onPick: (d) => setState(() => _billDate = d),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _challanNoController,
                  label: 'Challan No (Optional)',
                  placeholder: 'Delivery Note #',
                  readOnly: widget.isReadOnly,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to determine if we should show 'Ordered' (First GRN) or 'Pending' (Subsequent)
  bool get _showPendingColumn {
    // If ANY item has already been received, we are in a subsequent GRN state.
    return _grnItems.any((i) => i.alreadyReceivedQty > 0);
  }

  // --- Zone B: Traffic Light Grid ---
  Widget _buildVerificationGrid() {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // Header
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
                _buildHeaderCell('Item Name', flex: 3),
                _buildHeaderCell('UOM', flex: 2), // Added UOM
                _buildHeaderCell(
                  _showPendingColumn ? 'Pending' : 'Ordered',
                  flex: 2,
                  align: TextAlign.center,
                ), // Changed dynamically based on history
                // Traffic Light Columns
                _buildHeaderCell(
                  'Received', // Changed Total Recv -> Received (Implies Good/Accepted)
                  flex: 2,
                  align: TextAlign.center,
                ), // A
                _buildHeaderCell(
                  'Rejected',
                  flex: 2,
                  align: TextAlign.center,
                ), // B
                _buildHeaderCell(
                  'Accepted',
                  flex: 2,
                  align: TextAlign.center,
                ), // C

                _buildHeaderCell('Batch', flex: 2, align: TextAlign.left),
                _buildHeaderCell('MRP (₹)', flex: 2, align: TextAlign.right),
                _buildHeaderCell(
                  'Rate (Excl)',
                  flex: 2,
                  align: TextAlign.right,
                ),
                _buildHeaderCell('Tax %', flex: 1, align: TextAlign.right),
                _buildHeaderCell('Total (₹)', flex: 2, align: TextAlign.right),
                _buildHeaderCell('', flex: 1), // Actions
              ],
            ),
          ),
          // Body
          Expanded(
            child: ListView.separated(
              itemCount: _grnItems.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = _grnItems[index];
                return Container(
                  color: (item.rejectedQty > 0 && !widget.isReadOnly)
                      ? Colors
                            .orange
                            .shade50 // Warn if rejection
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      _buildCell('${index + 1}', flex: 1),
                      _buildCell(item.name, flex: 3, isBold: true),

                      // UOM Dropdown
                      Expanded(
                        flex: 2,
                        child: (item.availableUoms.isEmpty)
                            ? Text(
                                item.uom ?? 'PCS',
                                style: const TextStyle(fontSize: 12),
                              )
                            : DropdownButton<String>(
                                value: item.uom,
                                isDense: true,
                                underline: const SizedBox(),
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                                items: (item.availableUoms).map((u) {
                                  return DropdownMenuItem<String>(
                                    value: u['name'] as String,
                                    child: Text(
                                      u['name'],
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  );
                                }).toList(),
                                onChanged: widget.isReadOnly
                                    ? null
                                    : (val) {
                                        if (val == null) return;
                                        setState(() {
                                          final oldFactor =
                                              item.conversionFactor;
                                          final selected = item.availableUoms
                                              .firstWhere(
                                                (u) => u['name'] == val,
                                              );
                                          final newFactor =
                                              (selected['factor'] as num)
                                                  .toDouble();

                                          // 1. Recalculate Rate
                                          // Old Rate = Rate per Old UOM.
                                          // Base Rate = Old Rate / Old Factor.
                                          // New Rate = Base Rate * New Factor.
                                          final baseRate =
                                              item.rate /
                                              (oldFactor == 0 ? 1 : oldFactor);
                                          item.rate = baseRate * newFactor;

                                          // 2. Recalculate Quantities
                                          // Formula: CurrentQty * (OldFactor / NewFactor)
                                          // But to minimize float drift, we assume base unit matches Factor 1.
                                          // BaseQty (e.g. Total pieces) = Qty * OldFactor
                                          // NewQty = BaseQty / NewFactor

                                          final ratio = oldFactor / newFactor;

                                          // Calculated via doubles then rounded to prevent partial units
                                          item.orderedQty =
                                              (item.orderedQty * ratio).round();
                                          item.alreadyReceivedQty =
                                              (item.alreadyReceivedQty * ratio)
                                                  .round();
                                          item.receivedQty =
                                              (item.receivedQty * ratio)
                                                  .round();
                                          item.rejectedQty =
                                              (item.rejectedQty * ratio)
                                                  .round();

                                          item.uom = val;
                                          item.conversionFactor = newFactor;
                                        });
                                      },
                              ),
                      ),

                      // Pending / Ordered (Read Only)
                      _buildCell(
                        _showPendingColumn
                            ? '${item.pendingQty.toInt()}'
                            : '${item.orderedQty}',
                        flex: 2,
                        align: TextAlign.center,
                        color: Colors.grey,
                      ),

                      // A: Received (Editable) - This is now effectively "Accepted/Net Good"
                      Expanded(
                        flex: 2,
                        child: widget.isReadOnly
                            ? Center(
                                child: Text(
                                  '${item.receivedQty}',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : _buildNumberInput(
                                value: item.receivedQty,
                                onChanged: (val) {
                                  setState(() {
                                    // Constraint: Received (val) + Rejected <= Pending
                                    if (val + item.rejectedQty <=
                                        item.pendingQty) {
                                      item.receivedQty = val;
                                    } else {
                                      // If exceeds, cap it to (Pending - Rejected)
                                      final max =
                                          item.pendingQty - item.rejectedQty;
                                      item.receivedQty = max >= 0
                                          ? max.toInt()
                                          : 0;
                                    }
                                  });
                                },
                              ),
                      ),

                      // B: Rejected (Editable)
                      Expanded(
                        flex: 2,
                        child: widget.isReadOnly
                            ? Center(
                                child: Text(
                                  '${item.rejectedQty}',
                                  style: GoogleFonts.inter(color: Colors.red),
                                ),
                              )
                            : _buildNumberInput(
                                value: item.rejectedQty,
                                isDestructive: true,
                                onChanged: (val) {
                                  setState(() {
                                    // Constraint: Received + Rejected (val) <= Pending
                                    if (item.receivedQty + val <=
                                        item.pendingQty) {
                                      item.rejectedQty = val;
                                    } else {
                                      // If exceeds, cap it to (Pending - Received)
                                      final max =
                                          item.pendingQty - item.receivedQty;
                                      item.rejectedQty = max >= 0
                                          ? max.toInt()
                                          : 0;
                                    }
                                  });
                                },
                              ),
                      ),

                      // C: Accepted (Auto)
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Text(
                              '${item.acceptedQty}',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Batch
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          margin: const EdgeInsets.only(left: 4),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: TextField(
                            enabled: !widget.isReadOnly,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'No.',
                              isDense: true,
                            ),
                            style: GoogleFonts.inter(fontSize: 13),
                            onChanged: (val) => item.batchNumber = val,
                          ),
                        ),
                      ),

                      // MRP
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          margin: const EdgeInsets.only(left: 4),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: TextField(
                            enabled: !widget.isReadOnly,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              // prefixText removed for better alignment
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.right,
                            controller:
                                TextEditingController(text: '${item.mrp}')
                                  ..selection = TextSelection.collapsed(
                                    offset: '${item.mrp}'.length,
                                  ),
                            onChanged: (val) => setState(
                              () => item.mrp = double.tryParse(val) ?? 0,
                            ),
                            style: GoogleFonts.inter(fontSize: 13),
                          ),
                        ),
                      ),

                      // Rate
                      widget.isReadOnly
                          ? _buildCell(
                              '₹ ${item.rate.toStringAsFixed(2)}',
                              flex: 2,
                              align: TextAlign.right,
                            )
                          : Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                margin: const EdgeInsets.only(left: 4),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                                child: TextField(
                                  enabled: !widget.isReadOnly,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.right,
                                  controller:
                                      TextEditingController(
                                          text: '${item.rate}',
                                        )
                                        ..selection = TextSelection.collapsed(
                                          offset: '${item.rate}'.length,
                                        ),
                                  onChanged: (val) => setState(
                                    () => item.rate = double.tryParse(val) ?? 0,
                                  ),
                                  style: GoogleFonts.inter(fontSize: 13),
                                ),
                              ),
                            ),

                      // Tax Rate
                      _buildCell(
                        '${item.taxRate}%',
                        flex: 1,
                        align: TextAlign.right,
                      ),

                      // Total
                      _buildCell(
                        '₹ ${((item.rate * item.receivedQty) * (1 + item.taxRate / 100)).toStringAsFixed(2)}',
                        flex: 2,
                        align: TextAlign.right,
                        isBold: true,
                      ),

                      // Actions
                      Expanded(
                        flex: 1,
                        child: widget.isReadOnly
                            ? const SizedBox()
                            : IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _grnItems.removeAt(index);
                                  });
                                },
                              ),
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

  // --- Zone C: Footer with Close PO Switch ---
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Left Side: Close PO Checkbox (or Debit Note Notice)
            Expanded(
              flex: 5,
              child: (!widget.isReadOnly)
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _closePoManually
                            ? Colors.red.shade50
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _closePoManually
                              ? Colors.red.shade200
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _closePoManually,
                            activeColor: Colors.red,
                            onChanged: (val) =>
                                setState(() => _closePoManually = val!),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Close PO (Cancel remaining items)',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    color: _closePoManually
                                        ? Colors.red.shade900
                                        : Colors.black87,
                                  ),
                                ),
                                Text(
                                  _closePoManually
                                      ? 'Any pending items will be cancelled. Status set to Completed.'
                                      : 'PO will remain Open if items are pending.',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : _hasAssociatedDebitNote
                  ? Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.orange.shade50,
                      child: Text(
                        "Debit Note Raised for Rejections",
                        style: GoogleFonts.inter(
                          color: Colors.orange.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),

            const SizedBox(width: 24),
            // Right Side: Financials
            Expanded(
              flex: 6,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildSummaryRow(
                          'Taxable Value',
                          '₹ ${_taxableValue.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 4),
                        _buildSummaryRow(
                          'Tax (GST)',
                          '₹ ${_totalTax.toStringAsFixed(2)}',
                          isGrey: true,
                        ),
                        const SizedBox(height: 8),
                        _buildSummaryRow(
                          'Bill Total',
                          '₹ ${_billTotal.toStringAsFixed(2)}',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  if (!widget.isReadOnly)
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _saveGrn,
                        icon: const Icon(Icons.check, size: 20),
                        label: Text(
                          'Save GRN & Bill\n(Ctrl + S)',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveGrn() async {
    try {
      // 1. Calculate Status
      int totalOrdered = _grnItems.fold(0, (sum, i) => sum + i.orderedQty);
      int previousReceived = _grnItems.fold(
        0,
        (sum, i) => sum + i.alreadyReceivedQty,
      ); // Cumulative before this
      int currentReceived = _grnItems.fold(
        0,
        (sum, i) => sum + i.receivedQty,
      ); // This GRN

      int totalReceivedSoFar = previousReceived + currentReceived;
      int pending = totalOrdered - totalReceivedSoFar;

      String status;
      if (_closePoManually) {
        status = 'Completed'; // User forced close
      } else if (pending > 0) {
        status = 'Partially Received';
      } else {
        status = 'Completed'; // Fully received (or over)
      }

      await (_db.update(_db.purchaseOrders)
            ..where((tbl) => tbl.id.equals(widget.poId)))
          .write(PurchaseOrdersCompanion(status: drift.Value(status)));

      // 2. Insert GRN Header
      final grnId = _uuid.v4();
      final grnNumber = _billNoController.text.isNotEmpty
          ? _billNoController.text
          : 'GRN-${DateTime.now().millisecondsSinceEpoch}';

      await _db
          .into(_db.goodsReceipts)
          .insert(
            GoodsReceiptsCompanion.insert(
              id: grnId,
              poId: widget.poId,
              grnNumber: grnNumber,
              challanNumber: drift.Value(_challanNoController.text),
              grnDate: _billDate,
              createdAt: drift.Value(DateTime.now()),
              totalAmount: drift.Value(_billTotal),
            ),
          );

      // 3. Insert Items
      for (final item in _grnItems) {
        await _db
            .into(_db.goodsReceiptItems)
            .insert(
              GoodsReceiptItemsCompanion.insert(
                id: _uuid.v4(),
                grnId: grnId,
                productId: item.id,
                productName: item.name,
                orderedQty: item.orderedQty.toDouble(),
                receivedQty: item.receivedQty
                    .toDouble(), // This is "Total Received" in A
                rejectedQty: item.rejectedQty
                    .toDouble(), // This is "Rejected" in B
                acceptedQty: item.acceptedQty
                    .toDouble(), // This is "Accepted" in C
                rate: item.rate,
                taxRate: drift.Value(item.taxRate),
                uom: drift.Value(item.uom),
                conversionFactor: drift.Value(item.conversionFactor),
              ),
            );
      }

      // 4. Create Debit Note for Rejected Items
      if (_hasRejection) {
        final rejectedItems = _grnItems
            .where((i) => i.rejectedQty > 0)
            .toList();
        // Value of DN is typically RejectedQty * Rate. (Using Purchase Rate)
        final totalDebit = rejectedItems.fold(
          0.0,
          (sum, i) => sum + (i.rejectedQty * i.rate),
        );

        if (totalDebit > 0) {
          final dnId = _uuid.v4();
          await _db
              .into(_db.debitNotes)
              .insert(
                DebitNotesCompanion.insert(
                  id: dnId,
                  vendorId: widget.vendor['id'] ?? '',
                  poId: drift.Value(widget.poId),
                  date: DateTime.now(),
                  amount: totalDebit,
                  reason: 'Rejection in GRN ($grnId)', // "Damaged on Arrival"
                  status: 'Draft',
                ),
              );

          // NEW: Insert Debit Note Items
          for (final item in rejectedItems) {
            await _db
                .into(_db.debitNoteItems)
                .insert(
                  DebitNoteItemsCompanion.insert(
                    dnId: dnId,
                    productId: item.id,
                    productName: item.name,
                    orderedQty: item.orderedQty,
                    rejectedQty: item.rejectedQty,
                    reason: 'Damaged', // Default reason for auto-rejection
                    rate: item.rate,
                    taxRate: item.taxRate,
                  ),
                );
          }
        }
      }

      // 5. Update PO Items (Cumulative Received Qty)
      // Logic: For PO Calculation, we count Total Received (Accepted + Rejected)
      for (final item in _grnItems) {
        await (_db.update(_db.purchaseOrderItems)..where(
              (tbl) =>
                  tbl.poId.equals(widget.poId) & tbl.productId.equals(item.id),
            ))
            .write(
              PurchaseOrderItemsCompanion(
                receivedQuantity: drift.Value(
                  item.alreadyReceivedQty + item.receivedQty,
                ),
              ),
            );
      }

      // 6. Update Inventory (Via findOrCreateBatch)
      for (final item in _grnItems) {
        if (item.acceptedQty > 0) {
          await _db.findOrCreateBatch(
            productId: item.id,
            mrp: item.mrp,
            buyPrice:
                item.rate /
                (item.conversionFactor == 0
                    ? 1.0
                    : item.conversionFactor), // Cost per Base Unit
            quantity:
                item.acceptedQty * item.conversionFactor, // Stock in Base Unit
            batchNumber: item.batchNumber,
            // expiry: item.expiryDate
          );
        }
      }

      // 7. Record to General Ledger
      await _db.recordLedgerEntry(
        GeneralLedgerCompanion(
          id: drift.Value(_uuid.v4()),
          date: drift.Value(DateTime.now()),
          type: const drift.Value('PURCHASE'),
          description: drift.Value(
            'GRN Recv: ${widget.vendor['name']} (Bill: ${_billTotal.toStringAsFixed(2)})',
          ),
          debit: drift.Value(_billTotal), // Expense/Asset increase
          credit: const drift.Value(0.0),
          referenceId: drift.Value(grnId),
          referenceTable: const drift.Value('goods_receipts'),
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('GRN Saved Successfully!')),
        );
        Navigator.pop(context, status);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving GRN: $e')));
      }
    }
  }

  // --- Input Widgets ---
  Widget _buildNumberInput({
    required int value,
    required Function(int) onChanged,
    bool isDestructive = false,
  }) {
    return Center(
      child: Container(
        width: 60,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isDestructive ? Colors.red.shade200 : Colors.blue.shade200,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: TextField(
          decoration: const InputDecoration(
            border: InputBorder.none,
            isDense: true,
          ),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          controller: TextEditingController(text: '$value')
            ..selection = TextSelection.collapsed(offset: '$value'.length),
          onChanged: (val) => onChanged(int.tryParse(val) ?? 0),
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: isDestructive ? Colors.red.shade900 : Colors.black,
          ),
        ),
      ),
    );
  }

  // Helpers
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: readOnly ? Colors.grey.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: placeholder,
              hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
            ),
            style: GoogleFonts.inter(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime date,
    required Function(DateTime) onPick,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        InkWell(
          onTap: widget.isReadOnly
              ? null
              : () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) onPick(picked);
                },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: widget.isReadOnly ? Colors.grey.shade50 : Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('dd MMM yyyy').format(date),
                  style: GoogleFonts.inter(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCell(
    String text, {
    required int flex,
    TextAlign align = TextAlign.left,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text.toUpperCase(),
        textAlign: align,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildCell(
    String text, {
    required int flex,
    bool isBold = false,
    TextAlign align = TextAlign.left,
    Color? color,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          color: color ?? Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
    bool isGrey = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isTotal ? 14 : 12,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.black : Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          value,
          textAlign: TextAlign.right,
          style: GoogleFonts.inter(
            fontSize: isTotal ? 18 : 13,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: isTotal
                ? Colors.green.shade700
                : (isGrey ? Colors.grey.shade600 : Colors.black),
          ),
        ),
      ],
    );
  }
}

class GrnItem {
  final String id;
  final String name;
  int orderedQty; // Changed: Mutable for UOM Conversion
  int receivedQty; // Changed: This is now TOTAL RECEIVED (A)
  int rejectedQty; // Changed: This is now USER INPUT (B)
  double rate;
  final double taxRate;

  double mrp; // Added
  String? batchNumber;
  DateTime? expiryDate;

  GrnItem({
    required this.id,
    required this.name,
    required this.orderedQty,
    required this.receivedQty,
    this.rejectedQty = 0,
    this.alreadyReceivedQty = 0,
    required this.rate,
    required this.mrp, // Added
    required this.taxRate,
    this.batchNumber,
    this.expiryDate,
    this.uom,
    this.conversionFactor = 1.0,
    this.availableUoms = const [],
  });

  String? uom;
  double conversionFactor;
  List<dynamic> availableUoms;

  int alreadyReceivedQty; // Changed: Mutable for UOM Conversion

  // Getters
  // The 'receivedQty' input now represents the 'Good' (Accepted) quantity directly, as per user request.
  double get acceptedQty => receivedQty.toDouble();

  // Pending is Ordered - Already Received (from previous GRNs).
  double get pendingQty => (orderedQty - alreadyReceivedQty).toDouble();
}

class SaveIntent extends Intent {
  const SaveIntent();
}
