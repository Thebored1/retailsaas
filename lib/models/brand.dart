class Brand {
  final String id;
  final String name;
  final String? description;
  final bool isActive;

  Brand({
    required this.id,
    required this.name,
    this.description,
    this.isActive = true,
  });

  // JSON Serialization
  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'is_active': isActive,
    };
  }
}
