import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          IconButton(
            icon: Icon(
              favoritesProvider.isFavorite(product.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              favoritesProvider.toggleFavorite(product.id);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение товара
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[100],
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.contain,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Название и цена
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '${product.price} руб.',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1a237e),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Бренд и тип
                  Row(
                    children: [
                      Chip(
                        label: Text(product.brand),
                        backgroundColor: const Color(0xFF1a237e),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Chip(
                        label: Text(product.type),
                        backgroundColor: Colors.blue[100],
                      ),
                      const SizedBox(width: 10),
                      Chip(
                        label: Text(product.viscosity),
                        backgroundColor: Colors.amber[100],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Наличие
                  Row(
                    children: [
                      Icon(
                        product.stock > 0 ? Icons.check_circle : Icons.error,
                        color: product.stock > 0 ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        product.stock > 0 
                          ? 'В наличии: ${product.stock} шт.'
                          : 'Нет в наличии',
                        style: TextStyle(
                          fontSize: 16,
                          color: product.stock > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Описание
                  const Text(
                    'Описание',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),

                  const SizedBox(height: 20),

                  // Характеристики
                  const Text(
                    'Характеристики',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: product.specifications.map((spec) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 16),
                            const SizedBox(width: 8),
                            Expanded(child: Text(spec)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[300]!)),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: product.stock > 0 ? () {
                  cartProvider.addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.title} добавлен в корзину'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } : null,
                icon: const Icon(Icons.shopping_cart),
                label: Text(
                  product.stock > 0
                    ? cartProvider.isInCart(product.id)
                        ? 'В корзине'
                        : 'Добавить в корзину'
                    : 'Нет в наличии',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: product.stock > 0 
                    ? const Color(0xFF1a237e)
                    : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}