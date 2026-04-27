import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retailsaas/data/database/app_database.dart';
import 'package:retailsaas/locator.dart';
import 'package:retailsaas/services/settings_service.dart';
import 'package:retailsaas/services/sync_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  final Function(String)? onNavigate;

  const AdminDashboardScreen({super.key, this.onNavigate});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isLoadingPending = false;
  bool _isSubmittingDecision = false;
  String? _pendingOrdersError;
  List<Map<String, dynamic>> _pendingOrders = [];
  bool _isLoadingSlots = false;
  List<_DeliverySlotOption> _deliverySlots = [];
  Timer? _ordersRefreshTimer;

  @override
  void initState() {
    super.initState();
    _loadPendingOrders();
    _loadDeliverySlots();
    _ordersRefreshTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _loadPendingOrders(),
    );
  }

  @override
  void dispose() {
    _ordersRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadPendingOrders() async {
    if (_isLoadingPending) return;
    setState(() {
      _isLoadingPending = true;
      _pendingOrdersError = null;
    });

    try {
      final syncService = getIt<SyncService>();
      final orders = await syncService.pullPendingOrders();
      if (!mounted) return;

      setState(() {
        _pendingOrders = orders;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _pendingOrdersError = e.toString();
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingPending = false;
      });
    }
  }

  Future<void> _loadDeliverySlots() async {
    if (_isLoadingSlots) return;
    setState(() => _isLoadingSlots = true);
    try {
      final raw = await getIt<SettingsService>().loadDeliverySlots();
      final slots = raw.map(_DeliverySlotOption.fromJson).toList();
      slots.sort((a, b) => a.startTime.compareTo(b.startTime));
      if (!mounted) return;
      setState(() {
        _deliverySlots = slots;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _deliverySlots = [];
      });
    } finally {
      if (!mounted) return;
      setState(() => _isLoadingSlots = false);
    }
  }

  Future<void> _openAcceptDialog(Map<String, dynamic> order) async {
    if (_deliverySlots.isEmpty && !_isLoadingSlots) {
      await _loadDeliverySlots();
    }

    final expectedText = (order['expected_delivery_text'] ?? '').toString();
    final expectedStart = (order['expected_delivery_start'] ?? '').toString();
    final expectedEnd = (order['expected_delivery_end'] ?? '').toString();
    final initialDate = _parseDate(order['delivery_date']) ??
        DateTime.now().add(const Duration(days: 1));

    final activeSlots = _deliverySlots.where((s) => s.isActive).toList();
    _DeliverySlotOption? selectedSlot;
    if (activeSlots.isNotEmpty) {
      selectedSlot = activeSlots.firstWhere(
        (slot) =>
            slot.startTime == expectedStart &&
            slot.endTime == expectedEnd,
        orElse: () => activeSlots.first,
      );
    }

    bool outForDelivery = false;
    DateTime selectedDate = initialDate;
    final dateController = TextEditingController(
      text: _formatDateForDisplay(selectedDate),
    );
    String? errorText;

    final result = await showDialog<_AcceptDecisionResult>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Accept Order #${_parseOrderId(order) ?? ''}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (expectedText.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Expected: $expectedText',
                        style: GoogleFonts.inter(fontSize: 12),
                      ),
                    ),
                  if (activeSlots.isEmpty)
                    Text(
                      'No delivery slots configured. Add slots in Webfront > Delivery Slots.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.red.shade700,
                      ),
                    )
                  else
                    DropdownButtonFormField<_DeliverySlotOption>(
                      value: selectedSlot,
                      decoration: const InputDecoration(
                        labelText: 'Delivery slot',
                      ),
                      items: activeSlots
                          .map(
                            (slot) => DropdownMenuItem(
                              value: slot,
                              child: Text(slot.displayLabel),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedSlot = value;
                          errorText = null;
                        });
                      },
                    ),
                  const SizedBox(height: 12),
                  TextFormField(
                    readOnly: true,
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: 'Delivery date',
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (picked == null) return;
                      setDialogState(() {
                        selectedDate = picked;
                        dateController.text =
                            _formatDateForDisplay(selectedDate);
                      });
                    },
                  ),
                  const SizedBox(height: 4),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Mark as out for delivery'),
                    value: outForDelivery,
                    onChanged: (value) {
                      setDialogState(() {
                        outForDelivery = value ?? false;
                      });
                    },
                  ),
                  if (errorText != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      errorText!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: activeSlots.isEmpty
                      ? null
                      : () {
                          if (selectedSlot == null) {
                            setDialogState(() {
                              errorText = 'Select a delivery slot to continue.';
                            });
                            return;
                          }
                          Navigator.pop(
                            context,
                            _AcceptDecisionResult(
                              slot: selectedSlot!,
                              displayText: selectedSlot!.displayLabel,
                              deliveryDate: selectedDate,
                              outForDelivery: outForDelivery,
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Accept Order'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null) return;
    await _submitOrderDecisionFor(
      order,
      'ACCEPT',
      deliverySlot: result.slot,
      deliverySlotText: result.displayText,
      deliveryDate: result.deliveryDate,
      outForDelivery: result.outForDelivery,
    );
  }

  Future<void> _submitOrderDecisionFor(
    Map<String, dynamic> order,
    String decision, {
    _DeliverySlotOption? deliverySlot,
    String? deliverySlotText,
    bool outForDelivery = false,
    DateTime? deliveryDate,
  }
  ) async {
    if (_isSubmittingDecision) return;

    setState(() {
      _isSubmittingDecision = true;
    });

    try {
      final orderId = _parseOrderId(order);
      if (orderId == null) {
        throw Exception('Invalid order id');
      }

      double? finalTotal;
      if (decision == 'ACCEPT') {
        finalTotal = _parseDouble(order['estimated_total']);
      }

      await getIt<SyncService>().sendOrderDecision(
        orderId: orderId,
        decision: decision,
        finalTotal: finalTotal,
        deliverySlotLabel: deliverySlot?.label,
        deliverySlotStart: deliverySlot?.startTime,
        deliverySlotEnd: deliverySlot?.endTime,
        deliverySlotText: deliverySlotText ?? deliverySlot?.displayLabel,
        outForDelivery: decision == 'ACCEPT' ? outForDelivery : null,
        deliveryDate: deliveryDate == null ? null : _formatDateForApi(deliveryDate),
      );
      if (decision == 'ACCEPT') {
        await getIt<SyncService>().createSaleFromWebOrder(order);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              decision == 'ACCEPT'
                  ? 'Order accepted successfully.'
                  : 'Order cancelled successfully.',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }

      await _loadPendingOrders();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (!mounted) return;
      setState(() {
        _isSubmittingDecision = false;
      });
    }
  }


  int? _parseOrderId(Map<String, dynamic> order) {
    final raw = order['order_id'];
    if (raw is int) return raw;
    return int.tryParse(raw.toString());
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  List<dynamic> _extractItems(dynamic items) {
    if (items is List) return items;
    if (items is Map && items['items'] is List) {
      return items['items'] as List;
    }
    return [];
  }

  String _formatItemLabel(dynamic item) {
    if (item is Map) {
      final name = item['product_name'] ??
          item['productName'] ??
          item['name'] ??
          'Item';
      final qty = item['quantity'] ?? item['qty'];
      if (qty != null) {
        return '$name x $qty';
      }
      return name.toString();
    }
    return item.toString();
  }

  String _formatOrderDate(dynamic value) {
    if (value == null) return '';
    if (value is DateTime) return value.toString();
    return value.toString();
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  String _formatDateForDisplay(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  String _formatDateForApi(DateTime date) {
    return _formatDateForDisplay(date);
  }

  @override
  Widget build(BuildContext context) {
    // Database Reference
    final db = getIt<AppDatabase>();

    // Mock Data for Charts (Sales data not yet available in DB)
    final double onlineSales = 3086.0; // 20%
    final double offlineSales = 12344.0; // 80%

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 1100;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Admin Dashboard',
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Backoffice overview and analytics',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        // Actions Row (Notifications)
                        Row(
                          children: [
                            _buildCompactNotification(
                              _pendingOrders.length,
                              label: 'Online Orders Pending',
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Metrics Row (Compact)
                    StreamBuilder<double>(
                      stream: db.watchTotalInventoryValue(),
                      builder: (context, snapshotInv) {
                        return StreamBuilder<int>(
                          stream: db.watchLowStockItemsCount(),
                          builder: (context, snapshotLow) {
                            return StreamBuilder<int>(
                              stream: db.watchPendingDebitNotesCount(),
                              builder: (context, snapshotDebit) {
                                final totalInventoryValue =
                                    snapshotInv.data ?? 0.0;
                                final lowStockItems = snapshotLow.data ?? 0;
                                final pendingDebitNotes = snapshotDebit.data ?? 0;

                                final metrics = [
                                  _buildMetricCard(
                                    title: 'Total Inventory',
                                    value:
                                        'INR ${totalInventoryValue.toStringAsFixed(0)}',
                                    icon: Icons.inventory_2_outlined,
                                  ),
                                  _buildMetricCard(
                                    title: 'Low Stock',
                                    value: '${lowStockItems} Items',
                                    icon: Icons.warning_amber_rounded,
                                    isAlert: true,
                                  ),
                                  StreamBuilder<double>(
                                    stream: db.watchTodaysSales(),
                                    builder: (context, snapshotSales) {
                                      final sales = snapshotSales.data ?? 0.0;
                                      return _buildMetricCard(
                                        title: 'Today\'s Sales',
                                        value: 'INR ${sales.toStringAsFixed(0)}',
                                        icon: Icons.attach_money,
                                      );
                                    },
                                  ),
                                  _buildMetricCard(
                                    title: 'Pending Debit Notes',
                                    value: '${pendingDebitNotes}',
                                    icon: Icons.assignment_return_outlined,
                                    isAlert: false,
                                    onTap: () =>
                                        widget.onNavigate?.call('Debit Notes'),
                                  ),
                                ];

                                if (isSmallScreen) {
                                  return Column(
                                    children: metrics
                                        .map(
                                          (m) => Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: m,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  );
                                } else {
                                  return Row(
                                    children: metrics
                                        .map(
                                          (m) => Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                  ),
                                              child: m,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Charts Row
                    Flex(
                      direction: isSmallScreen
                          ? Axis.vertical
                          : Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Revenue Bar Chart
                        isSmallScreen
                            ? Container(
                                height: 320,
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: _buildPendingOrdersPanelContent(),
                              )
                            : Expanded(
                                flex: 2,
                                child: Container(
                                  height: 320,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9FAFB),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  child: _buildPendingOrdersPanelContent(),
                                ),
                              ),

                        SizedBox(
                          width: isSmallScreen ? 0 : 16,
                          height: isSmallScreen ? 16 : 0,
                        ),

                        // Pie Chart
                        isSmallScreen
                            ? Container(
                                height: 320,
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1C1C1E),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: _buildPieChartContent(
                                  onlineSales,
                                  offlineSales,
                                ),
                              )
                            : Expanded(
                                flex: 1,
                                child: Container(
                                  height: 320,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1C1C1E),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: _buildPieChartContent(
                                    onlineSales,
                                    offlineSales,
                                  ),
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Management Section
                    Text(
                      'Management Modules',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Flex(
                      direction: isSmallScreen
                          ? Axis.vertical
                          : Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isSmallScreen
                            ? SizedBox(
                                width: double.infinity,
                                child: _buildManagementCard(
                                  context,
                                  title: 'Inventory & Supply',
                                  items: [
                                    'Purchase Order',
                                    'Vendor Management',
                                    'Transactions',
                                    'Inventory',
                                  ],
                                ),
                              )
                            : Expanded(
                                child: _buildManagementCard(
                                  context,
                                  title: 'Inventory & Supply',
                                  items: [
                                    'Purchase Order',
                                    'Vendor Management',
                                    'Transactions',
                                    'Inventory',
                                  ],
                                ),
                              ),
                        SizedBox(
                          width: isSmallScreen ? 0 : 16,
                          height: isSmallScreen ? 16 : 0,
                        ),
                        isSmallScreen
                            ? SizedBox(
                                width: double.infinity,
                                child: _buildManagementCard(
                                  context,
                                  title: 'Sales & CRM',
                                  items: [
                                    'Online Customers',
                                    'Sales Returns',
                                    'Loyalty Program',
                                    'Quotations',
                                  ],
                                ),
                              )
                            : Expanded(
                                child: _buildManagementCard(
                                  context,
                                  title: 'Sales & CRM',
                                  items: [
                                    'Online Customers',
                                    'Sales Returns',
                                    'Loyalty Program',
                                    'Quotations',
                                  ],
                                ),
                              ),
                        SizedBox(
                          width: isSmallScreen ? 0 : 16,
                          height: isSmallScreen ? 16 : 0,
                        ),
                        isSmallScreen
                            ? SizedBox(
                                width: double.infinity,
                                child: _buildManagementCard(
                                  context,
                                  title: 'Reports & Finance',
                                  items: [
                                    'Expense Tracker',
                                    'Tax Summary',
                                    'Profit & Loss',
                                  ],
                                ),
                              )
                            : Expanded(
                                child: _buildManagementCard(
                                  context,
                                  title: 'Reports & Finance',
                                  items: [
                                    'General Ledger',
                                    'Expense Tracker',
                                    'Tax Summary',
                                    'Profit & Loss',
                                  ],
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(height: 48), // Bottom padding
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Widgets ---


  Widget _buildPendingOrdersPanelContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pending Online Orders',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                if (_isLoadingPending) ...[
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                ],
                TextButton.icon(
                  onPressed: _isLoadingPending ? null : _loadPendingOrders,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          ],
        ),
        if (_pendingOrdersError != null) ...[
          const SizedBox(height: 6),
          Text(
            'Failed to load orders: ${_pendingOrdersError}',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.red.shade700,
            ),
          ),
        ],
        const SizedBox(height: 8),
        Expanded(
          child: _pendingOrders.isEmpty
              ? Center(
                  child: Text(
                    'No pending online orders.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: _pendingOrders.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) =>
                      _buildPendingOrderRow(_pendingOrders[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildPendingOrderRow(Map<String, dynamic> order) {
    final orderId = _parseOrderId(order) ?? 0;
    final items = _extractItems(order['items']);
    final estimatedTotal = _parseDouble(order['estimated_total']);
    final createdAt = _formatOrderDate(order['created_at']);
    final expectedText = (order['expected_delivery_text'] ?? '').toString();
    final itemPreview = items.take(4).map(_formatItemLabel).toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${orderId}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (estimatedTotal != null)
                Text(
                  'INR ${estimatedTotal.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          if (itemPreview.isEmpty)
            Text(
              'No items found.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: itemPreview
                  .map(
                    (label) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        '- ${label}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          if (items.length > 4)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                '+${items.length - 4} more items',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          if (createdAt.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'Placed: ${createdAt}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          if (expectedText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'Expected: ${expectedText}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _isSubmittingDecision
                    ? null
                    : () => _submitOrderDecisionFor(order, 'REJECT'),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _isSubmittingDecision
                    ? null
                    : () => _openAcceptDialog(order),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text('Accept'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildPieChartContent(double onlineSales, double offlineSales) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SALES SOURCE',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '₹${(onlineSales + offlineSales).toStringAsFixed(0)}',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        SizedBox(
          height: 150,
          child: PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 35,
              sections: [
                PieChartSectionData(
                  color: Colors.white,
                  value: 20,
                  title: '',
                  radius: 18,
                ),
                PieChartSectionData(
                  color: Colors.grey.shade600,
                  value: 80,
                  title: '',
                  radius: 18,
                ),
              ],
              startDegreeOffset: -90,
            ),
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildDarkLegendItem(color: Colors.white, label: 'WEB'),
            _buildDarkLegendItem(color: Colors.grey.shade600, label: 'COUNTER'),
          ],
        ),
      ],
    );
  }

  Widget _buildManagementCard(
    BuildContext context, {
    required String title,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: InkWell(
                onTap: () {
                  if (widget.onNavigate != null) {
                    widget.onNavigate!(item);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Icon(
                      Icons.arrow_outward,
                      size: 14,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactNotification(int count, {String label = 'Orders Pending'}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.notifications_active, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            '$count $label',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    bool isAlert = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: isAlert
              ? Border.all(color: Colors.black)
              : Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.black, size: 20),
                if (isAlert) Icon(Icons.circle, color: Colors.black, size: 8),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: Colors.white54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DeliverySlotOption {
  final String id;
  final String label;
  final String startTime;
  final String endTime;
  final bool isActive;

  const _DeliverySlotOption({
    required this.id,
    required this.label,
    required this.startTime,
    required this.endTime,
    required this.isActive,
  });

  String get displayLabel {
    if (label.isEmpty) {
      return '$startTime - $endTime';
    }
    return '$label ($startTime - $endTime)';
  }

  factory _DeliverySlotOption.fromJson(Map<String, dynamic> json) {
    return _DeliverySlotOption(
      id: json['id']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      startTime: json['startTime']?.toString() ?? '',
      endTime: json['endTime']?.toString() ?? '',
      isActive: json['isActive'] == true,
    );
  }
}

class _AcceptDecisionResult {
  final _DeliverySlotOption slot;
  final String displayText;
  final DateTime deliveryDate;
  final bool outForDelivery;

  const _AcceptDecisionResult({
    required this.slot,
    required this.displayText,
    required this.deliveryDate,
    required this.outForDelivery,
  });
}


