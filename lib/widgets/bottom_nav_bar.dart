import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                Icons.home,
                'Главная',
                0,
                currentIndex == 0,
              ),
              _buildNavItem(
                context,
                Icons.category,
                'Каталог',
                1,
                currentIndex == 1,
              ),
              _buildCartNavItem(
                context,
                Icons.shopping_cart,
                'Корзина',
                2,
                currentIndex == 2,
                cartProvider.itemCount,
              ),
              _buildNavItem(
                context,
                Icons.favorite,
                'Избранное',
                3,
                currentIndex == 3,
                badgeCount: favoritesProvider.favoriteIds.length,
              ),
              _buildNavItem(
                context,
                Icons.person,
                'Профиль',
                4,
                currentIndex == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    bool isSelected, {
    int badgeCount = 0,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badgeCount > 0)
            badges.Badge(
              badgeContent: Text(
                badgeCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: Colors.red,
              ),
              child: Icon(
                icon,
                size: 24,
                color: isSelected ? const Color(0xFF1a237e) : Colors.grey,
              ),
            )
          else
            Icon(
              icon,
              size: 24,
              color: isSelected ? const Color(0xFF1a237e) : Colors.grey,
            ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? const Color(0xFF1a237e) : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    bool isSelected,
    int itemCount,
  ) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          badges.Badge(
            badgeContent: Text(
              itemCount.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
            badgeStyle: const badges.BadgeStyle(
              badgeColor: Colors.red,
            ),
            showBadge: itemCount > 0,
            child: Icon(
              icon,
              size: 24,
              color: isSelected ? const Color(0xFF1a237e) : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? const Color(0xFF1a237e) : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// Альтернативная версия с фиксированной высотой
class SimpleBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const SimpleBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xFF1a237e),
      unselectedItemColor: Colors.grey,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      onTap: onTap,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Главная',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Каталог',
        ),
        BottomNavigationBarItem(
          icon: Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return badges.Badge(
                badgeContent: Text(
                  cartProvider.itemCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                showBadge: cartProvider.itemCount > 0,
                child: const Icon(Icons.shopping_cart),
              );
            },
          ),
          label: 'Корзина',
        ),
        BottomNavigationBarItem(
          icon: Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              return badges.Badge(
                badgeContent: Text(
                  favoritesProvider.favoriteIds.length.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                showBadge: favoritesProvider.favoriteIds.isNotEmpty,
                child: const Icon(Icons.favorite),
              );
            },
          ),
          label: 'Избранное',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Профиль',
        ),
      ],
    );
  }
}