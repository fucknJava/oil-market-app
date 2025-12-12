class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String type;
  final String viscosity;
  final String brand;
  final int stock;
  final List<String> specifications;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.type,
    required this.viscosity,
    required this.brand,
    this.stock = 10,
    this.specifications = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      type: json['type'],
      viscosity: json['viscosity'],
      brand: json['brand'],
      stock: json['stock'] ?? 10,
      specifications: List<String>.from(json['specifications'] ?? []),
    );
  }
}