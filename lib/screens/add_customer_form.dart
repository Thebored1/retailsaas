import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../models/customer.dart';
import '../widgets/custom_text_field.dart';

class AddCustomerForm extends StatefulWidget {
  final Customer? customerToEdit;
  final Function(Customer) onSave;
  final VoidCallback onCancel;

  const AddCustomerForm({
    super.key,
    this.customerToEdit,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<AddCustomerForm> createState() => _AddCustomerFormState();
}

class _AddCustomerFormState extends State<AddCustomerForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  late TextEditingController _gstinController;
  late TextEditingController _stateCodeController;
  late TextEditingController _pinCodeController;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customerToEdit?.name);
    _phoneController = TextEditingController(
      text: widget.customerToEdit != null ? widget.customerToEdit!.phoneString : '',
    );
    _emailController = TextEditingController(text: widget.customerToEdit?.email);
    _addressController = TextEditingController(text: widget.customerToEdit?.address);
    _gstinController = TextEditingController(text: widget.customerToEdit?.gstin);
    _stateCodeController = TextEditingController(text: widget.customerToEdit?.stateCode);
    _pinCodeController = TextEditingController(text: widget.customerToEdit?.pinCode);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _gstinController.dispose();
    _stateCodeController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }

  void _saveCustomer() {
    if (_formKey.currentState!.validate()) {
      final phoneString = _phoneController.text.trim();
      final phone = int.parse(phoneString);
      
      // Title case the name
      final rawName = _nameController.text.trim();
      final titleCasedName = rawName.split(' ').map((word) {
        if (word.isEmpty) return '';
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join(' ');

      final newCustomer = Customer(
        id: widget.customerToEdit?.id ?? const Uuid().v4(),
        name: titleCasedName,
        phone: phone,
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        gstin: _gstinController.text.trim().isEmpty ? null : _gstinController.text.trim(),
        stateCode: _stateCodeController.text.trim().isEmpty ? null : _stateCodeController.text.trim(),
        pinCode: _pinCodeController.text.trim().isEmpty ? null : _pinCodeController.text.trim(),
        createdAt: widget.customerToEdit?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      widget.onSave(newCustomer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.customerToEdit == null ? 'Add New Customer' : 'Edit Customer',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  onPressed: widget.onCancel,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      label: 'Customer Name*',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _phoneController,
                      label: 'Phone Number (10 Digits)*',
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Phone is required';
                        }
                        if (value.trim().length != 10) {
                          return 'Phone number must be exactly 10 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email (Optional)',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _addressController,
                      label: 'Address*',
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Address is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _gstinController,
                      label: 'GSTIN (Optional)',
                      maxLength: 15,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _stateCodeController,
                            label: 'State Code (e.g. 27)',
                            maxLength: 2,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            controller: _pinCodeController,
                            label: 'PIN Code',
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onCancel,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(color: Colors.grey.shade700),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveCustomer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Save Customer',
                    style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
