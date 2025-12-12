import 'package:flutter/foundation.dart';
import '../models/product.dart';

class FavoritesProvider with ChangeNotifier {
  final List<int> _favoriteIds = [];

  List<int> get favoriteIds => _favoriteIds;
  List<Product> get favorites => [];

  void toggleFavorite(int productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }

  bool isFavorite(int productId) {
    return _favoriteIds.contains(productId);
  }
}