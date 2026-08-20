class Contact {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final bool isFavorite;

  const Contact({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    this.isFavorite = false,
  });

  Contact copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    bool? isFavorite,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as int?,
      name: (map['name'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      address: (map['address'] ?? '') as String,
      isFavorite: (map['isFavorite'] ?? 0) == 1,
    );
  }
}
