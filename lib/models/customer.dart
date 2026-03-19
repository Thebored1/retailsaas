class Customer {
  final String id;
  final int phone; // 10 digit number used for login explicitly
  final String name;
  final String email;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;

  Customer({
    required this.id,
    required this.phone,
    required this.name,
    this.email = '',
    required this.address,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
        
  // Easy getter for display purposes to format as a string
  String get phoneString => phone.toString();
}
