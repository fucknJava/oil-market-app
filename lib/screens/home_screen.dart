import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_card.dart';
import 'catalog_screen.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'auth_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<Widget> _screens = [
    const HomeContent(),
    const CatalogScreen(),
    const CartScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              title: const Text(
                'Oil Market',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.store, color: Colors.white),
                  onPressed: () {
                    // Информация о магазине
                    _showStoreInfo();
                  },
                ),
              ],
            )
          : null,
      body: authProvider.isAuthenticated || _selectedIndex == 4
          ? _screens[_selectedIndex]
          : const AuthScreen(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF1a237e),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Каталог',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }

  void _showStoreInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Магазин Oil Market'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'ул. Дзержинского, 4, стр. 7',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Большой Камень, Приморский край',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Телефон: +7 950 286 55 25',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Часы работы:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('Пн-Пт: 9:00 - 19:00'),
              const Text('Сб-Вс: 10:00 - 18:00'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Закрыть'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final featuredProducts = productsProvider.allProducts.take(4).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Баннер
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF1a237e),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Моторные масла\nвысокого качества',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Широкий ассортимент для любого автомобиля',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CatalogScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Перейти в каталог'),
                ),
              ],
            ),
          ),

          // Поиск
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск моторных масел...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                Provider.of<ProductsProvider>(context, listen: false).search(value);
              },
            ),
          ),

          const SizedBox(height: 20),

          // Категории
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Категории',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryCard('Синтетическое', Icons.oil_barrel, () {
                        Provider.of<ProductsProvider>(context, listen: false)
                            .filterByType('Синтетическое');
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CatalogScreen()),
                        );
                      }),
                      const SizedBox(width: 10),
                      _buildCategoryCard('Полусинтетическое', Icons.local_gas_station, () {
                        Provider.of<ProductsProvider>(context, listen: false)
                            .filterByType('Полусинтетическое');
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CatalogScreen()),
                        );
                      }),
                      const SizedBox(width: 10),
                      _buildCategoryCard('Минеральное', Icons.settings, () {
                        Provider.of<ProductsProvider>(context, listen: false)
                            .filterByType('Минеральное');
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CatalogScreen()),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Популярные товары
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Популярные товары',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: featuredProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: featuredProducts[index]);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFf5f5f5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: const Color(0xFF1a237e)),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}