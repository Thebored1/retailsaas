import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retailsaas/locator.dart';
import 'package:retailsaas/services/settings_service.dart';
import 'package:retailsaas/services/sync_service.dart';

class OnlineOrdersManagementScreen extends StatefulWidget {
  const OnlineOrdersManagementScreen({super.key});

  @override
  State<OnlineOrdersManagementScreen> createState() =>
      _OnlineOrdersManagementScreenState();
}

class _OnlineOrdersManagementScreenState
    extends State<OnlineOrdersManagementScreen> {
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _error;
  List<Map<String, dynamic>> _orders = [];
  String _statusFilter = 'ALL';

  bool _isLoadingSlots = false;
  List<_DeliverySlotOption> _deliverySlots = [];
  Timer? _ordersRefreshTimer;

  @override
  void initState() {
    super.initState();
    _loadOrders();
    _loadDeliverySlots();
    _ordersRefreshTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _loadOrders(),
    );
  }

  @override
  void dispose() {
    _ordersRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final statuses = _statusFilter == 'ALL' ? null : [_statusFilter];
      final result =
          await getIt<SyncService>().fetchOrders(statuses: statuses);
      if (!mounted) return;
      setState(() {
        _orders = result;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
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
      setState(() => _deliverySlots = slots);
    } catch (_) {
      if (!mounted) return;
      setState(() => _deliverySlots = []);
    } finally {
      if (!mounted) return;
      setState(() => _isLoadingSlots = false);
    }
  }

  Future<void> _acceptOrder(Map<String, dynamic> order) async {
    final result = await _openAcceptDialog(order);
    if (result == null) return;

    await _submitDecision(
      order,
      'ACCEPT',
      deliverySlot: result.slot,
      deliverySlotText: result.displayText,
      deliveryDate: result.deliveryDate,
      outForDelivery: result.outForDelivery,
    );
  }

  Future<void> _markOutForDelivery(Map<String, dynamic> order) async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);
    try {
      final orderId = _parseOrderId(order);
      if (orderId == null) throw Exception('Invalid order id');
      await getIt<SyncService>().markOrderOutForDelivery(orderId: orderId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order marked out for delivery.'),
          backgroundColor: Colors.green,
        ),
      );
      await _loadOrders();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _submitDecision(
    Map<String, dynamic> order,
    String decision, {
    _DeliverySlotOption? deliverySlot,
    String? deliverySlotText,
    bool outForDelivery = false,
    DateTime? deliveryDate,
  }) async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);
    try {
      final orderId = _parseOrderId(order);
      if (orderId == null) throw Exception('Invalid order id');

      await getIt<SyncService>().sendOrderDecision(
        orderId: orderId,
        decision: decision,
        finalTotal: _parseDouble(order['estimated_total']),
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
      if (!mounted) return;
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
      await _loadOrders();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
    }
  }

  Future<_AcceptDecisionResult?> _openAcceptDialog(
    Map<String, dynamic> order,
  ) async {
    if (_deliverySlots.isEmpty && !_isLoadingSlots) {
      await _loadDeliverySlots();
    }

    final expectedText = (order['expected_delivery_text'] ?? '').toString();
    final expectedStart = (order['expected_delivery_start'] ?? '').toString();
    final expectedEnd = (order['expected_delivery_end'] ?? '').toString();
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final initialDate = _parseDate(order['delivery_date']) ?? tomorrow;

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

    return showDialog<_AcceptDecisionResult>(
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
                        firstDate: DateTime(now.year, now.month, now.day),
                        lastDate: now.add(const Duration(days: 30)),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Manage Online Orders',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      DropdownButton<String>(
                        value: _statusFilter,
                        items: const [
                          DropdownMenuItem(value: 'ALL', child: Text('All')),
                          DropdownMenuItem(
                            value: 'PENDING',
                            child: Text('Pending'),
                          ),
                          DropdownMenuItem(
                            value: 'ACCEPTED',
                            child: Text('Accepted'),
                          ),
                          DropdownMenuItem(
                            value: 'OUT_FOR_DELIVERY',
                            child: Text('Out for Delivery'),
                          ),
                          DropdownMenuItem(
                            value: 'DELIVERED',
                            child: Text('Delivered'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _statusFilter = value);
                          _loadOrders();
                        },
                      ),
                      const SizedBox(width: 12),
                      TextButton.icon(
                        onPressed: _isLoading ? null : _loadOrders,
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Refresh'),
                      ),
                    ],
                  ),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Failed to load orders: $_error',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _orders.isEmpty
                        ? Center(
                            child: Text(
                              'No orders found.',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: _orders.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              return _buildOrderCard(_orders[index]);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final orderId = _parseOrderId(order) ?? 0;
    final status = (order['status'] ?? '').toString();
    final items = _extractItems(order['items']);
    final estimatedTotal = _parseDouble(order['estimated_total']);
    final expectedText = (order['expected_delivery_text'] ?? '').toString();
    final deliverySlotText = (order['delivery_slot_text'] ?? '').toString();
    final deliveryDate = _parseDate(order['delivery_date']);

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
                'Order #$orderId',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                status,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: status == 'OUT_FOR_DELIVERY'
                      ? Colors.green.shade700
                      : status == 'DELIVERED'
                          ? Colors.blue.shade700
                          : Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (estimatedTotal != null)
            Text(
              'Estimated: INR ${estimatedTotal.toStringAsFixed(2)}',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
          const SizedBox(height: 6),
          ...items.take(3).map(
                (item) => Text(
                  '- ${_formatItemLabel(item)}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
          if (items.length > 3)
            Text(
              '+${items.length - 3} more items',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          if (expectedText.isNotEmpty && (status == 'PENDING' || deliveryDate == null))
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Expected: $expectedText',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          if (deliverySlotText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'Slot: $deliverySlotText',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          if (deliveryDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'Delivery date: ${_formatDateForDisplay(deliveryDate)}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _buildActions(order, status),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActions(Map<String, dynamic> order, String status) {
    if (status == 'PENDING') {
      return [
        TextButton(
          onPressed: _isSubmitting
              ? null
              : () => _submitDecision(order, 'REJECT'),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _isSubmitting ? null : () => _acceptOrder(order),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          child: const Text('Accept'),
        ),
      ];
    }
    if (status == 'ACCEPTED') {
      return [
        ElevatedButton(
          onPressed: _isSubmitting ? null : () => _markOutForDelivery(order),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          child: const Text('Mark Out for Delivery'),
        ),
      ];
    }
    return [];
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

