import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String _baseUrl = 'https://fucknjava.github.io/api';
  static const Duration _timeout = Duration(seconds: 10);

  Future<List<Product>> getProducts() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/products'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        return _getMockProducts();
      }
    } catch (e) {
      return _getMockProducts();
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/products/$id'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        return _getMockProducts().firstWhere((product) => product.id == id);
      }
    } catch (e) {
      throw Exception('Failed to load product');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/products/search?q=$query'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/orders'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(orderData),
          )
          .timeout(_timeout);

      if (response.statusCode != 201) {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      // Игнорируем ошибку для демо
    }
  }

  Future<List<Map<String, dynamic>>> getOrders(String userId) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/orders?userId=$userId'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  List<Product> _getMockProducts() {
    return [
      Product(
        id: 1,
        title: 'Mobil 1 ESP 5W-30',
        description: 'Полностью синтетическое моторное масло с улучшенными характеристиками',
        price: 2999,
        imageUrl: 'https://via.placeholder.com/300',
        type: 'Синтетическое',
        viscosity: '5W-30',
        brand: 'Mobil',
        stock: 15,
        specifications: ['API SN Plus', 'ACEA C3', '5L'],
      ),
      Product(
        id: 2,
        title: 'Castrol Magnatec 5W-40',
        description: 'Масло с технологией магнитной защиты двигателя',
        price: 2499,
        imageUrl: 'https://via.placeholder.com/300',
        type: 'Синтетическое',
        viscosity: '5W-40',
        brand: 'Castrol',
        stock: 20,
        specifications: ['API SN', 'ACEA A3/B4', '4L'],
      ),
      Product(
        id: 3,
        title: 'Shell Helix HX7 10W-40',
        description: 'Полусинтетическое моторное масло для всех типов двигателей',
        price: 1899,
        imageUrl: 'https://via.placeholder.com/300',
        type: 'Полусинтетическое',
        viscosity: '10W-40',
        brand: 'Shell',
        stock: 25,
        specifications: ['API SN', 'ACEA A3/B3', '4L'],
      ),
      Product(
        id: 4,
        title: 'Lukoil Genesis 5W-30',
        description: 'Синтетическое масло премиум-класса',
        price: 2199,
        imageUrl: 'https://via.placeholder.com/300',
        type: 'Синтетическое',
        viscosity: '5W-30',
        brand: 'Lukoil',
        stock: 30,
        specifications: ['API SN', 'ACEA C3', '4L'],
      ),
      Product(
        id: 5,
        title: 'Rosneft Maximum 15W-40',
        description: 'Минеральное масло для старых двигателей',
        price: 1499,
        imageUrl: 'https://via.placeholder.com/300',
        type: 'Минеральное',
        viscosity: '15W-40',
        brand: 'Rosneft',
        stock: 40,
        specifications: ['API CF-4', 'ACEA B2', '5L'],
      ),
    ];
  }
}