import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' as drift;
import '../locator.dart';
import '../data/database/app_database.dart';
import '../models/customer.dart' as model;
import 'add_customer_form.dart';

class CustomerManagementScreen extends StatefulWidget {
  const CustomerManagementScreen({super.key});

  @override
  State<CustomerManagementScreen> createState() => _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  final AppDatabase _db = getIt<AppDatabase>();
  
  bool _isAddingCustomer = false;
  model.Customer? _editingCustomer;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 600;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
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
              child: _isAddingCustomer
                  ? AddCustomerForm(
                      customerToEdit: _editingCustomer,
                      onSave: (newCustomer) async {
                        final companion = CustomersCompanion(
                          id: drift.Value(newCustomer.id),
                          name: drift.Value(newCustomer.name),
                          phone: drift.Value(newCustomer.phone),
                          email: drift.Value(newCustomer.email.isEmpty ? null : newCustomer.email),
                          address: drift.Value(newCustomer.address),
                          createdAt: drift.Value(newCustomer.createdAt),
                          updatedAt: drift.Value(DateTime.now()),
                        );

                        if (_editingCustomer != null) {
                          await (_db.update(_db.customers)..where((tbl) => tbl.id.equals(_editingCustomer!.id)))
                              .write(companion);
                        } else {
                          await _db.into(_db.customers).insert(companion);
                        }

                        setState(() {
                          _isAddingCustomer = false;
                          _editingCustomer = null;
                        });
                      },
                      onCancel: () {
                        setState(() {
                          _isAddingCustomer = false;
                          _editingCustomer = null;
                        });
                      },
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Online Customers',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isAddingCustomer = true;
                                    _editingCustomer = null;
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
                          child: StreamBuilder<List<Customer>>(
                            stream: _db.select(_db.customers).watch(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              }
                              if (!snapshot.hasData) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              final customersList = snapshot.data!;
                              if (customersList.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No customers found. Add one!',
                                    style: GoogleFonts.inter(color: Colors.grey),
                                  ),
                                );
                              }

                              return ListView.separated(
                                itemCount: customersList.length,
                                separatorBuilder: (context, index) => Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Colors.grey.shade100,
                                ),
                                itemBuilder: (context, index) {
                                  final dbCust = customersList[index];
                                  return _buildCustomerItem(dbCust, isSmall);
                                },
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

  Widget _buildCustomerItem(Customer dbCust, bool isSmall) {
    return InkWell(
      onTap: () {
        // Details view omitted for brevity, we could expand this later.
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
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
                dbCust.name.isNotEmpty ? dbCust.name.substring(0, 1).toUpperCase() : '?',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dbCust.name,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.fingerprint, size: 12, color: Colors.grey.shade400),
                      const SizedBox(width: 4),
                      Text(
                        'ID: ${dbCust.id.split('-').first}', // Shortened UUID for display
                        style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.phone_outlined, size: 12, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        dbCust.phone.toString(),
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      if (!isSmall) ...[
                        const SizedBox(width: 12),
                        Icon(Icons.location_on_outlined, size: 12, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            dbCust.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  _buildCustomerHistory(dbCust),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: Colors.grey.shade400, size: 20),
                  onPressed: () {
                    final modelCust = model.Customer(
                      id: dbCust.id,
                      phone: dbCust.phone,
                      name: dbCust.name,
                      email: dbCust.email ?? '',
                      address: dbCust.address,
                      createdAt: dbCust.createdAt,
                      updatedAt: dbCust.updatedAt,
                    );
                    setState(() {
                      _editingCustomer = modelCust;
                      _isAddingCustomer = true;
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

  Widget _buildCustomerHistory(Customer dbCust) {
    final query = _db.select(_db.salesBills)
      ..where((t) => t.customerId.equals(dbCust.id))
      ..orderBy([(t) => drift.OrderingTerm.desc(t.date)]);

    return FutureBuilder<List<SalesBill>>(
      future: query.get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(
            'Loading history...',
            style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500),
          );
        }

        final bills = snapshot.data ?? [];
        if (bills.isEmpty) {
          return Text(
            'No purchase history yet.',
            style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500),
          );
        }

        final ongoing = bills.firstWhere(
          (b) => b.paymentStatus.toUpperCase() != 'PAID',
          orElse: () => bills.first,
        );
        final hasOngoing = ongoing.paymentStatus.toUpperCase() != 'PAID';
        final recent = bills.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hasOngoing
                  ? 'Ongoing: INR ${ongoing.grandTotal.toStringAsFixed(0)} (${ongoing.paymentStatus})'
                  : 'Ongoing: none',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: hasOngoing ? Colors.orange.shade700 : Colors.grey.shade500,
                fontWeight: hasOngoing ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Recent: ${recent.map(_formatBillSummary).join(' • ')}',
              style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        );
      },
    );
  }

  String _formatBillSummary(SalesBill bill) {
    final date = bill.date;
    final dateLabel =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    return '$dateLabel - INR ${bill.grandTotal.toStringAsFixed(0)}';
  }
}
