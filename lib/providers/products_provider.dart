import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _searchQuery = '';
  String _selectedType = 'Все';
  String _selectedViscosity = 'Все';
  double _minPrice = 0;
  double _maxPrice = 10000;
  String _sortBy = 'default'; // Добавляем переменную для сортировки
  bool _isLoading = false;

  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _products;
  bool get isLoading => _isLoading;
  String get sortBy => _sortBy;
  
  List<String> get types => ['Все', 'Синтетическое', 'Полусинтетическое', 'Минеральное'];
  List<String> get viscosities => ['Все', '0W-20', '5W-30', '5W-40', '10W-40', '15W-40'];

  ProductsProvider() {
    _loadProducts();
  }

  void _loadProducts() {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      _products = [
        Product(
          id: 1,
          title: 'Mobil 1 ESP 5W-30',
          description: 'Полностью синтетическое моторное масло с улучшенными характеристиками',
          price: 2999,
          imageUrl: 'https://via.placeholder.com/300x300?text=Mobil+1',
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
          imageUrl: 'https://via.placeholder.com/300x300?text=Castrol',
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
          imageUrl: 'https://via.placeholder.com/300x300?text=Shell',
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
          imageUrl: 'https://via.placeholder.com/300x300?text=Lukoil',
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
          imageUrl: 'https://via.placeholder.com/300x300?text=Rosneft',
          type: 'Минеральное',
          viscosity: '15W-40',
          brand: 'Rosneft',
          stock: 40,
          specifications: ['API CF-4', 'ACEA B2', '5L'],
        ),
        Product(
          id: 6,
          title: 'ZIC X9 0W-20',
          description: 'Синтетическое масло с низкой вязкостью',
          price: 3499,
          imageUrl: 'https://via.placeholder.com/300x300?text=ZIC',
          type: 'Синтетическое',
          viscosity: '0W-20',
          brand: 'ZIC',
          stock: 10,
          specifications: ['API SP', 'ILSAC GF-6', '4L'],
        ),
      ];
      
      _filteredProducts = List.from(_products);
      _isLoading = false;
      notifyListeners();
    });
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByType(String type) {
    _selectedType = type;
    _applyFilters();
  }

  void filterByViscosity(String viscosity) {
    _selectedViscosity = viscosity;
    _applyFilters();
  }

  void filterByPrice(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
  }

  void sortByOption(String option) {
    _sortBy = option;
    _applyFilters();
  }

  void _applyFilters() {
    // Фильтрация
    _filteredProducts = _products.where((product) {
      bool matchesSearch = _searchQuery.isEmpty ||
          product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.brand.toLowerCase().contains(_searchQuery.toLowerCase());
      
      bool matchesType = _selectedType == 'Все' || product.type == _selectedType;
      bool matchesViscosity = _selectedViscosity == 'Все' || product.viscosity == _selectedViscosity;
      bool matchesPrice = product.price >= _minPrice && product.price <= _maxPrice;
      
      return matchesSearch && matchesType && matchesViscosity && matchesPrice;
    }).toList();
    
    // Сортировка
    switch (_sortBy) {
      case 'price_asc':
        _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'name_asc':
        _filteredProducts.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'name_desc':
        _filteredProducts.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'default':
      default:
        // По умолчанию - по ID (как в базе)
        _filteredProducts.sort((a, b) => a.id.compareTo(b.id));
        break;
    }
    
    notifyListeners();
  }

  Product getProductById(int id) {
    return _products.firstWhere((product) => product.id == id);
  }
}