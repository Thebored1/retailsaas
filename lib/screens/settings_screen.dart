import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../locator.dart';
import '../services/settings_service.dart';
import '../services/sync_service.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _settings = getIt<SettingsService>();
  bool _loading = true;
  bool _saving = false;
  bool _showApiKey = false;
  bool _resetting = false;
  bool _requireDeliveryPhoto = false;

  // Controllers — Establishment
  final _shopNameCtrl    = TextEditingController();
  final _shopPhoneCtrl   = TextEditingController();
  final _shopEmailCtrl   = TextEditingController();
  final _shopGstinCtrl   = TextEditingController();
  final _shopStateCodeCtrl = TextEditingController();
  // Controllers — Address
  final _addrLine1Ctrl   = TextEditingController();
  final _addrLine2Ctrl   = TextEditingController();
  final _addrCityCtrl    = TextEditingController();
  final _addrStateCtrl   = TextEditingController();
  final _addrPinCtrl     = TextEditingController();
  final _addrCountryCtrl = TextEditingController();
  // Controllers — Sync
  final _serverUrlCtrl   = TextEditingController();
  final _apiKeyCtrl      = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _settings.loadAll();
    setState(() {
      _shopNameCtrl.text    = data['shopName']    ?? '';
      _shopPhoneCtrl.text   = data['shopPhone']   ?? '';
      _shopEmailCtrl.text   = data['shopEmail']   ?? '';
      _shopGstinCtrl.text   = data['shopGstin']   ?? '';
      _shopStateCodeCtrl.text = data['shopStateCode'] ?? '';
      _addrLine1Ctrl.text   = data['addrLine1']   ?? '';
      _addrLine2Ctrl.text   = data['addrLine2']   ?? '';
      _addrCityCtrl.text    = data['addrCity']    ?? '';
      _addrStateCtrl.text   = data['addrState']   ?? '';
      _addrPinCtrl.text     = data['addrPin']     ?? '';
      _addrCountryCtrl.text = data['addrCountry'] ?? 'India';
      _serverUrlCtrl.text   = data['serverUrl']   ?? '';
      _apiKeyCtrl.text      = data['apiKey']      ?? '';
      _requireDeliveryPhoto = data['requireDeliveryPhoto'] == true;
      _loading = false;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await _settings.saveAll(
        shopName:    _shopNameCtrl.text.trim(),
        shopPhone:   _shopPhoneCtrl.text.trim(),
        shopEmail:   _shopEmailCtrl.text.trim(),
        shopGstin:   _shopGstinCtrl.text.trim(),
        shopStateCode: _shopStateCodeCtrl.text.trim(),
        addrLine1:   _addrLine1Ctrl.text.trim(),
        addrLine2:   _addrLine2Ctrl.text.trim(),
        addrCity:    _addrCityCtrl.text.trim(),
        addrState:   _addrStateCtrl.text.trim(),
        addrPin:     _addrPinCtrl.text.trim(),
        addrCountry: _addrCountryCtrl.text.trim(),
        serverUrl:   _serverUrlCtrl.text.trim(),
        apiKey:      _apiKeyCtrl.text.trim(),
        requireDeliveryPhoto: _requireDeliveryPhoto,
      );
      try {
        await getIt<SyncService>().updateDeliveryPhotoRequirement(
          requireDeliveryPhoto: _requireDeliveryPhoto,
        );
      } catch (_) {
        // Ignore sync errors here; local settings are still saved.
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    for (final c in [
      _shopNameCtrl, _shopPhoneCtrl, _shopEmailCtrl,
      _shopGstinCtrl, _shopStateCodeCtrl,
      _addrLine1Ctrl, _addrLine2Ctrl, _addrCityCtrl,
      _addrStateCtrl, _addrPinCtrl, _addrCountryCtrl,
      _serverUrlCtrl, _apiKeyCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
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
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
            ),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    child: Form(
                      key: _formKey,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Header ─────────────────────────────────────
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Settings', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold)),
                                    Text('Establishment info & cloud sync configuration',
                                        style: GoogleFonts.inter(fontSize: 14, color: Colors.grey)),
                                  ],
                                ),
                                ElevatedButton.icon(
                                  onPressed: _saving ? null : _save,
                                  icon: _saving
                                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                      : const Icon(Icons.save_outlined, size: 18),
                                  label: Text(_saving ? 'Saving…' : 'Save Settings'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // ── Section 1: Establishment ────────────────────
                            _sectionHeader(Icons.store_outlined, 'Establishment'),
                            const SizedBox(height: 16),
                            _field(_shopNameCtrl, 'Shop / Business Name',
                                validator: (v) => v!.trim().isEmpty ? 'Required' : null),
                            const SizedBox(height: 14),
                            Row(children: [
                              Expanded(child: _phoneField()),
              const SizedBox(width: 16),
                              Expanded(child: _field(_shopEmailCtrl, 'Email Address', keyboardType: TextInputType.emailAddress)),
                            ]),
                            const SizedBox(height: 14),
                            Row(children: [
                              Expanded(child: _field(_shopGstinCtrl, 'GSTIN')),
                              const SizedBox(width: 16),
                              Expanded(child: _field(_shopStateCodeCtrl, 'State Code')),
                            ]),
                            const SizedBox(height: 28),

                            // ── Section 2: Address ──────────────────────────
                            _sectionHeader(Icons.location_on_outlined, 'Address'),
                            const SizedBox(height: 16),
                            _field(_addrLine1Ctrl, 'Address Line 1 (Building / Street)'),
                            const SizedBox(height: 14),
                            _field(_addrLine2Ctrl, 'Address Line 2 (Landmark / Area)'),
                            const SizedBox(height: 14),
                            Row(children: [
                              Expanded(flex: 2, child: _field(_addrCityCtrl, 'City')),
                              const SizedBox(width: 16),
                              Expanded(flex: 2, child: _field(_addrStateCtrl, 'State')),
                              const SizedBox(width: 16),
                              Expanded(flex: 1, child: _field(_addrPinCtrl, 'PIN Code',
                                  keyboardType: TextInputType.number,
                                  validator: (v) {
                                    if (v != null && v.isNotEmpty && v.trim().length != 6) {
                                      return '6 digits';
                                    }
                                    return null;
                                  })),
                            ]),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: 240,
                              child: _field(_addrCountryCtrl, 'Country'),
                            ),
                            const SizedBox(height: 28),

                            // ── Section 3: Cloud Sync ───────────────────────
                            _sectionHeader(Icons.cloud_outlined, 'Cloud Sync'),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue.shade100),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, size: 16, color: Colors.blue.shade700),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Enter the URL of your Django server and the API key set in your server .env file.',
                                      style: GoogleFonts.inter(fontSize: 12, color: Colors.blue.shade700),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            _field(_serverUrlCtrl, 'Server URL',
                                hint: 'e.g. http://192.168.1.10:8000/api/v1',
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return null; // optional
                                  if (!v.startsWith('http')) return 'Must start with http:// or https://';
                                  return null;
                                }),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _apiKeyCtrl,
                              obscureText: !_showApiKey,
                              style: GoogleFonts.inter(fontSize: 14),
                              decoration: InputDecoration(
                                labelText: 'API Key',
                                labelStyle: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                suffixIcon: IconButton(
                                  icon: Icon(_showApiKey ? Icons.visibility_off : Icons.visibility, size: 18, color: Colors.grey),
                                  onPressed: () => setState(() => _showApiKey = !_showApiKey),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            SwitchListTile(
                              title: Text(
                                'Require delivery photo',
                                style: GoogleFonts.inter(fontSize: 13),
                              ),
                              subtitle: Text(
                                'Delivery agents must upload at least one photo to complete delivery.',
                                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                              ),
                              value: _requireDeliveryPhoto,
                              onChanged: (value) {
                                setState(() => _requireDeliveryPhoto = value);
                              },
                            ),
                            const SizedBox(height: 48),

                            _sectionHeader(Icons.warning_amber_outlined, 'Danger Zone'),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade100),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reset Webfront Products & Inventory',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'This will wipe products and inventory on the webfront and replace them with the desktop data. Customers and sales are preserved.',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.red.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: _resetting ? null : _confirmReset,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.shade700,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: _resetting
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text('Reset Webfront Data'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Widget _phoneField() {
    return TextFormField(
      controller: _shopPhoneCtrl,
      keyboardType: TextInputType.number,
      maxLength: 10,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (v) {
        if (v == null || v.trim().isEmpty) return null;
        if (v.trim().length != 10) return 'Must be 10 digits';
        return null;
      },
      style: GoogleFonts.inter(fontSize: 14),
      decoration: InputDecoration(
        labelText: 'Phone Number',
        counterText: '', // hide the default 10/10 counter
        labelStyle: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.red)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black),
        const SizedBox(width: 8),
        Text(title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(width: 12),
        Expanded(child: Divider(color: Colors.grey.shade200)),
      ],
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label, {
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.inter(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
        hintStyle: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade400),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.red)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  Future<void> _confirmReset() async {
    final auth = getIt<AuthService>();
    final user = auth.currentUser.value;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No user logged in.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final passwordCtrl = TextEditingController();
    bool confirmed = false;

    final proceed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Reset'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your password to reset webfront products and inventory.',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                confirmed = passwordCtrl.text == user.password;
                Navigator.pop(context, confirmed);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    passwordCtrl.dispose();

    if (proceed != true || !confirmed) {
      if (proceed == false && mounted) return;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password incorrect.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() => _resetting = true);
    try {
      await getIt<SyncService>().nuclearResetWebfront();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Webfront products and inventory reset successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reset failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _resetting = false);
    }
  }
}
