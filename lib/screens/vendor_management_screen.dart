import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' as drift;
import '../locator.dart';
import '../data/database/app_database.dart';
import '../models/vendor.dart' as model; // Alias the model
import 'vendor_details_view.dart';
import 'add_vendor_form.dart';

class VendorManagementScreen extends StatefulWidget {
  const VendorManagementScreen({super.key});

  @override
  State<VendorManagementScreen> createState() => _VendorManagementScreenState();
}

class _VendorManagementScreenState extends State<VendorManagementScreen> {
  // Database Reference
  final AppDatabase _db = getIt<AppDatabase>();

  // Navigation State
  model.Vendor? _selectedVendor; // Use model Vendor for details view for now
  bool _isAddingVendor = false;
  model.Vendor? _editingVendor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 600;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.white, // Moved to Material
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: _isAddingVendor
                  ? AddVendorForm(
                      vendorToEdit: _editingVendor,
                      onSave: (newVendorModel) async {
                        // Convert model.Vendor to DB Insert
                        // Note: DB table 'vendors' has fewer fields currently.
                        // Mapping what we have.
                        final companion = VendorsCompanion(
                          id: drift.Value(newVendorModel.id),
                          name: drift.Value(newVendorModel.name),
                          address: drift.Value(newVendorModel.address),
                          contact: drift.Value(
                            newVendorModel.mobileNumber,
                          ), // Map mobile to contact
                          email: drift.Value(newVendorModel.email),
                          gstin: drift.Value(newVendorModel.gstin),
                          stateCode: drift.Value(newVendorModel.stateCode),
                          isActive: const drift.Value(true),
                        );

                        if (_editingVendor != null) {
                          // Update
                          await (_db.update(_db.vendors)..where(
                                (tbl) => tbl.id.equals(_editingVendor!.id),
                              ))
                              .write(companion);
                        } else {
                          // Insert
                          await _db.into(_db.vendors).insert(companion);
                        }

                        setState(() {
                          _isAddingVendor = false;
                          _editingVendor = null;
                        });
                      },
                      onCancel: () {
                        setState(() {
                          _isAddingVendor = false;
                          _editingVendor = null;
                        });
                      },
                    )
                  : _selectedVendor != null
                  ? VendorDetailsView(
                      vendor: _selectedVendor!,
                      onBack: () {
                        setState(() {
                          _selectedVendor = null;
                        });
                      },
                    )
                  : Column(
                      children: [
                        // Custom Header replacing AppBar
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Vendor Management',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isAddingVendor = true;
                                    _editingVendor = null;
                                    _selectedVendor = null;
                                  });
                                },
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey.shade100),

                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(12),
                            ),
                            child: StreamBuilder<List<Vendor>>(
                              // DB Vendor class
                              stream: _db.select(_db.vendors).watch(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                }
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                final vendors = snapshot.data!;

                                if (vendors.isEmpty) {
                                  return Center(
                                    child: Text(
                                      'No vendors found. Add one!',
                                      style: GoogleFonts.inter(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                }

                                return ListView.separated(
                                  itemCount: vendors.length,
                                  separatorBuilder: (context, index) => Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Colors.grey.shade100,
                                  ),
                                  itemBuilder: (context, index) {
                                    final dbVendor = vendors[index];
                                    return _buildVendorListItem(
                                      dbVendor,
                                      isSmall,
                                    );
                                  },
                                );
                              },
                            ),
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

  Widget _buildVendorListItem(Vendor dbVendor, bool isSmall) {
    // Map DB Vendor to Model for UI logic if needed, or use directly
    // The previous UI logic used 'balance' which we don't have in DB yet.
    // We'll skip balance display or show 0.

    return InkWell(
      onTap: () {
        // Convert DB Vendor to Model Vendor for Detail View
        // Missing fields will be defaulted or empty
        final modelVendor = model.Vendor(
          id: dbVendor.id,
          name: dbVendor.name,
          description: '',
          balance: '0',
          service: '',
          contactPerson: dbVendor.contact, // Using contact as contactPerson
          mobileNumber: dbVendor
              .contact, // Using contact as mobileNumber too? Or we need separate fields in DB later.
          email: dbVendor.email ?? '',
          address: dbVendor.address,
          gstin: dbVendor.gstin ?? '',
          stateCode: dbVendor.stateCode ?? '',
        );

        setState(() {
          _selectedVendor = modelVendor;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Vendor Initials
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              alignment: Alignment.center,
              child: Text(
                dbVendor.name.isNotEmpty
                    ? dbVendor.name.substring(0, 1).toUpperCase()
                    : '?',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Name and Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        dbVendor.name,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      StreamBuilder<double>(
                        stream: getIt<AppDatabase>().watchVendorBalance(
                          dbVendor.id,
                        ),
                        builder: (context, snapshot) {
                          final balance = snapshot.data ?? 0.0;
                          if (balance.abs() < 1) return const SizedBox.shrink();
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: balance > 0
                                  ? Colors.red.shade50
                                  : Colors.green.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '₹${balance.abs().toStringAsFixed(0)}',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: balance > 0
                                    ? Colors.red.shade700
                                    : Colors.green.shade700,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 12,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dbVendor.contact,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (!isSmall) ...[
                        const SizedBox(width: 12),
                        Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            dbVendor.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Actions - Edit
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  onPressed: () {
                    // Prepare model for editing
                    final modelVendor = model.Vendor(
                      id: dbVendor.id,
                      name: dbVendor.name,
                      description: '',
                      balance: '0',
                      service: '',
                      contactPerson: dbVendor.contact,
                      mobileNumber: dbVendor.contact,
                      email: dbVendor.email ?? '',
                      address: dbVendor.address,
                      gstin: dbVendor.gstin ?? '',
                      stateCode: dbVendor.stateCode ?? '',
                    );
                    setState(() {
                      _editingVendor = modelVendor;
                      _isAddingVendor = true;
                    });
                  },
                  tooltip: 'Edit',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
