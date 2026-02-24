class ContactPerson {
  final String name;
  final String role;
  final String phone;
  final String email;
  final String? avatarUrl;

  ContactPerson({
    required this.name,
    required this.role,
    required this.phone,
    required this.email,
    this.avatarUrl,
  });
}

class Vendor {
  final String id; // UUID
  final String name;
  final String description;
  final String balance;
  final String service;
  final String
  contactPerson; // Primary contact (kept for backward compat or list view)
  final String mobileNumber;

  // New Fields
  final String gstin;
  final String email;
  final String address;
  final String type; // e.g., "Wholesaler", "Manufacturer"
  final String? stateCode;
  final List<ContactPerson> additionalContacts;

  final VendorBankDetails? bankDetails;

  Vendor({
    required this.id,
    required this.name,
    required this.description,
    required this.balance,
    required this.service,
    required this.contactPerson,
    required this.mobileNumber,
    this.gstin = '29ABCDE1234F1Z5',
    this.email = 'vendor@example.com',
    this.address = '123, Market Yard, Bangalore, Karnataka - 560001',
    this.type = 'Wholesaler',
    this.stateCode,
    this.additionalContacts = const [],
    this.bankDetails,
  });
}

class VendorBankDetails {
  final String accountNumber;
  final String ifscCode;
  final String bankName;
  final String upiId;

  VendorBankDetails({
    required this.accountNumber,
    required this.ifscCode,
    required this.bankName,
    required this.upiId,
  });
}
