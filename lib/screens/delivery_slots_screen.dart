import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../locator.dart';
import '../services/settings_service.dart';

class DeliverySlotsScreen extends StatefulWidget {
  const DeliverySlotsScreen({super.key});

  @override
  State<DeliverySlotsScreen> createState() => _DeliverySlotsScreenState();
}

class _DeliverySlotsScreenState extends State<DeliverySlotsScreen> {
  final _settings = getIt<SettingsService>();
  bool _loading = true;
  final List<_DeliverySlot> _slots = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final raw = await _settings.loadDeliverySlots();
    setState(() {
      _slots
        ..clear()
        ..addAll(raw.map(_DeliverySlot.fromJson));
      _loading = false;
    });
  }

  Future<void> _persist() async {
    await _settings.saveDeliverySlots(
      _slots.map((s) => s.toJson()).toList(),
    );
  }

  Future<void> _openSlotDialog({_DeliverySlot? slot}) async {
    final isEditing = slot != null;
    final labelCtrl = TextEditingController(text: slot?.label ?? '');
    final startCtrl = TextEditingController(text: slot?.startTime ?? '');
    final endCtrl = TextEditingController(text: slot?.endTime ?? '');
    bool isActive = slot?.isActive ?? true;
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<_DeliverySlot>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Delivery Slot' : 'Add Delivery Slot'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: labelCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Label',
                        hintText: 'e.g. Morning Slot',
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: startCtrl,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Start (HH:MM)',
                              hintText: '09:00',
                              suffixIcon: Icon(Icons.schedule),
                            ),
                            validator: _validateTime,
                            onTap: () =>
                                _selectTime(context: context, controller: startCtrl),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: endCtrl,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'End (HH:MM)',
                              hintText: '11:00',
                              suffixIcon: Icon(Icons.schedule),
                            ),
                            validator: _validateTime,
                            onTap: () =>
                                _selectTime(context: context, controller: endCtrl),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Active'),
                      value: isActive,
                      onChanged: (v) =>
                          setDialogState(() => isActive = v),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                final newSlot = _DeliverySlot(
                  id: slot?.id ?? const Uuid().v4(),
                  label: labelCtrl.text.trim(),
                  startTime: startCtrl.text.trim(),
                  endTime: endCtrl.text.trim(),
                  isActive: isActive,
                );
                Navigator.pop(context, newSlot);
              },
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        if (isEditing) {
          final index = _slots.indexWhere((s) => s.id == result.id);
          if (index != -1) _slots[index] = result;
        } else {
          _slots.add(result);
        }
        _slots.sort((a, b) => a.startTime.compareTo(b.startTime));
      });
      await _persist();
    }

    labelCtrl.dispose();
    startCtrl.dispose();
    endCtrl.dispose();
  }

  Future<void> _deleteSlot(_DeliverySlot slot) async {
    setState(() {
      _slots.removeWhere((s) => s.id == slot.id);
    });
    await _persist();
  }

  String? _validateTime(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final raw = value.trim();
    final match = RegExp(r'^(\d{2}):(\d{2})$').firstMatch(raw);
    if (match == null) return 'Use HH:MM';
    final hour = int.tryParse(match.group(1) ?? '');
    final minute = int.tryParse(match.group(2) ?? '');
    if (hour == null || minute == null) return 'Use HH:MM';
    if (hour < 0 || hour > 23) return 'Hour 00-23';
    if (minute < 0 || minute > 59) return 'Minute 00-59';
    return null;
  }

  Future<void> _selectTime({
    required BuildContext context,
    required TextEditingController controller,
  }) async {
    TimeOfDay initial = TimeOfDay.now();
    final raw = controller.text.trim();
    final match = RegExp(r'^(\d{2}):(\d{2})$').firstMatch(raw);
    if (match != null) {
      final hour = int.tryParse(match.group(1) ?? '');
      final minute = int.tryParse(match.group(2) ?? '');
      if (hour != null && minute != null) {
        initial = TimeOfDay(hour: hour, minute: minute);
      }
    }

    FocusScope.of(context).unfocus();
    final picked = await showTimePicker(
      context: context,
      useRootNavigator: false,
      initialTime: initial,
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      final hh = picked.hour.toString().padLeft(2, '0');
      final mm = picked.minute.toString().padLeft(2, '0');
      controller.text = '$hh:$mm';
    }
  }

  Widget _timePill(String time, {required Color accent}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withOpacity(0.35)),
      ),
      child: Text(
        time,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: accent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delivery Slots',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _openSlotDialog(),
                              icon: const Icon(Icons.add),
                              label: const Text('Add Slot'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: _slots.isEmpty
                              ? Center(
                                  child: Text(
                                    'No delivery slots yet. Add one to get started.',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: _slots.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 10),
                                  itemBuilder: (context, index) {
                                    final slot = _slots[index];
                                    final label = slot.label.trim().isEmpty
                                        ? 'Slot'
                                        : slot.label.trim();
                                    return Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.02),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  label,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    _timePill(
                                                      slot.startTime,
                                                      accent: Colors.green.shade600,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    _timePill(
                                                      slot.endTime,
                                                      accent: Colors.orange.shade600,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: slot.isActive
                                                  ? Colors.green.shade50
                                                  : Colors.grey.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              slot.isActive ? 'Active' : 'Inactive',
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: slot.isActive
                                                    ? Colors.green.shade700
                                                    : Colors.grey.shade600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                            tooltip: 'Edit',
                                            icon: const Icon(Icons.edit_outlined),
                                            onPressed: () =>
                                                _openSlotDialog(slot: slot),
                                          ),
                                          IconButton(
                                            tooltip: 'Delete',
                                            icon: const Icon(Icons.delete_outline),
                                            onPressed: () => _deleteSlot(slot),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _DeliverySlot {
  final String id;
  final String label;
  final String startTime;
  final String endTime;
  final bool isActive;

  _DeliverySlot({
    required this.id,
    required this.label,
    required this.startTime,
    required this.endTime,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'startTime': startTime,
        'endTime': endTime,
        'isActive': isActive,
      };

  factory _DeliverySlot.fromJson(Map<String, dynamic> json) {
    return _DeliverySlot(
      id: json['id']?.toString() ?? const Uuid().v4(),
      label: json['label']?.toString() ?? '',
      startTime: json['startTime']?.toString() ?? '',
      endTime: json['endTime']?.toString() ?? '',
      isActive: json['isActive'] == true,
    );
  }
}
