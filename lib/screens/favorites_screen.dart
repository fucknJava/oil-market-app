import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);

    final favoriteProducts = productsProvider.allProducts
        .where((product) => favoritesProvider.isFavorite(product.id))
        .toList();

    if (favoriteProducts.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Избранное')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border, size: 80, color: Colors.grey),
              SizedBox(height: 20),
              Text(
                'Нет избранных товаров',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Избранное')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: favoriteProducts.length,
        itemBuilder: (context, index) {
          return ProductCard(product: favoriteProducts[index]);
        },
      ),
    );
  }
}