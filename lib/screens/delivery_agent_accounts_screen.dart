import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../locator.dart';
import '../services/sync_service.dart';

class DeliveryAgentAccountsScreen extends StatefulWidget {
  const DeliveryAgentAccountsScreen({super.key});

  @override
  State<DeliveryAgentAccountsScreen> createState() =>
      _DeliveryAgentAccountsScreenState();
}

class _DeliveryAgentAccountsScreenState
    extends State<DeliveryAgentAccountsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();

  bool _submitting = false;
  bool _showPassword = false;
  bool _loadingAgents = false;
  List<Map<String, dynamic>> _agents = [];

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _fullNameCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadAgents();
  }

  Future<void> _loadAgents() async {
    if (_loadingAgents) return;
    setState(() => _loadingAgents = true);
    try {
      final agents = await getIt<SyncService>().listDeliveryAgents();
      if (!mounted) return;
      setState(() => _agents = agents);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load agents: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loadingAgents = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    try {
      await getIt<SyncService>().createDeliveryAgent(
        username: _usernameCtrl.text.trim(),
        password: _passwordCtrl.text,
        fullName: _toTitleCase(_fullNameCtrl.text.trim()),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Delivery agent created successfully.'),
          backgroundColor: Colors.green,
        ),
      );

      _usernameCtrl.clear();
      _passwordCtrl.clear();
      _fullNameCtrl.clear();
      await _loadAgents();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create agent: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _resetPassword(Map<String, dynamic> agent) async {
    final displayName = _agentDisplayName(agent);
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reset Password ($displayName)'),
          content: TextField(
            controller: controller,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'New password'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    final newPassword = controller.text.trim();
    controller.dispose();
    if (confirmed != true) return;
    if (newPassword.length < 6) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await getIt<SyncService>().resetDeliveryAgentPassword(
        id: agent['id'] as int,
        newPassword: newPassword,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reset password: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _toggleActive(Map<String, dynamic> agent) async {
    final isActive = agent['is_active'] == true;
    try {
      await getIt<SyncService>().setDeliveryAgentActive(
        id: agent['id'] as int,
        isActive: !isActive,
      );
      await _loadAgents();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            !isActive ? 'Agent enabled.' : 'Agent disabled.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update agent: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteAgent(Map<String, dynamic> agent) async {
    final displayName = _agentDisplayName(agent);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete $displayName?'),
          content: const Text('This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await getIt<SyncService>().deleteDeliveryAgent(
        id: agent['id'] as int,
      );
      await _loadAgents();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agent deleted.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete agent: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Delivery Agent',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'This creates a login for the webfront delivery console.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _field(
                    _fullNameCtrl,
                    'Full Name',
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _usernameCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (v.trim().length != 10) return 'Must be 10 digits';
                      return null;
                    },
                    style: GoogleFonts.inter(fontSize: 14),
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      counterText: '',
                      labelStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: !_showPassword,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Required';
                      }
                      if (v.length < 6) return 'Minimum 6 characters';
                      return null;
                    },
                    style: GoogleFonts.inter(fontSize: 14),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword ? Icons.visibility_off : Icons.visibility,
                          size: 18,
                          color: Colors.grey,
                        ),
                        onPressed: () =>
                            setState(() => _showPassword = !_showPassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  ElevatedButton.icon(
                    onPressed: _submitting ? null : _submit,
                    icon: _submitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.person_add_alt_1, size: 18),
                    label: Text(_submitting ? 'Creating...' : 'Create Agent'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Agents can sign in at /delivery/signin on the webfront.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Existing Agents',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _loadingAgents ? null : _loadAgents,
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Refresh'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_loadingAgents)
                    const Center(child: CircularProgressIndicator())
                  else if (_agents.isEmpty)
                    Text(
                      'No delivery agents created yet.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    )
                  else
                    Column(
                      children: _agents.map(_buildAgentCard).toList(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label, {
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      validator: validator,
      style: GoogleFonts.inter(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  Widget _buildAgentCard(Map<String, dynamic> agent) {
    final name = _toTitleCase((agent['full_name'] ?? '').toString().trim());
    final username = (agent['username'] ?? '').toString();
    final isActive = agent['is_active'] == true;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.isEmpty ? username : name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (name.isNotEmpty)
                    Text(
                      username,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        isActive ? Colors.green.shade200 : Colors.red.shade200,
                  ),
                ),
                child: Text(
                  isActive ? 'Active' : 'Disabled',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color:
                        isActive ? Colors.green.shade700 : Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              TextButton(
                onPressed: () => _resetPassword(agent),
                child: const Text('Reset Password'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => _toggleActive(agent),
                child: Text(isActive ? 'Disable' : 'Enable'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => _deleteAgent(agent),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _agentDisplayName(Map<String, dynamic> agent) {
    final name = _toTitleCase((agent['full_name'] ?? '').toString().trim());
    final username = (agent['username'] ?? '').toString();
    return name.isEmpty ? username : name;
  }

  String _toTitleCase(String input) {
    if (input.isEmpty) return input;
    return input
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map((part) =>
            part[0].toUpperCase() + (part.length > 1 ? part.substring(1).toLowerCase() : ''))
        .join(' ');
  }
}
