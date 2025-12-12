class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? address;
  final DateTime registeredAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    required this.registeredAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      registeredAt: DateTime.parse(json['registeredAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'registeredAt': registeredAt.toIso8601String(),
    };
  }
}