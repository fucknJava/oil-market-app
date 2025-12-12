import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'orders_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isAuthenticated) {
      return const Center(
        child: Text('Пожалуйста, войдите в систему'),
      );
    }

    final user = authProvider.user!;

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Заголовок профиля
            Container(
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF1a237e),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Color(0xFF1a237e),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Информация о пользователе
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Личная информация',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.person, 'Имя', user.name),
                    _buildInfoRow(Icons.email, 'Email', user.email),
                    _buildInfoRow(Icons.phone, 'Телефон', user.phone),
                    if (user.address != null)
                      _buildInfoRow(Icons.location_on, 'Адрес', user.address!),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Дата регистрации',
                      '${user.registeredAt.day}.${user.registeredAt.month}.${user.registeredAt.year}',
                    ),
                  ],
                ),
              ),
            ),

            // Меню профиля
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildMenuButton(
                    context,
                    Icons.shopping_bag,
                    'Мои заказы',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OrdersHistoryScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuButton(
                    context,
                    Icons.location_on,
                    'Адреса доставки',
                    () {},
                  ),
                  _buildMenuButton(
                    context,
                    Icons.settings,
                    'Настройки',
                    () {},
                  ),
                  _buildMenuButton(
                    context,
                    Icons.help,
                    'Помощь',
                    () {
                      _showHelpDialog(context);
                    },
                  ),
                  _buildMenuButton(
                    context,
                    Icons.logout,
                    'Выйти',
                    () {
                      authProvider.logout();
                    },
                    isLogout: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1a237e)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed, {
    bool isLogout = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : const Color(0xFF1a237e),
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isLogout ? Colors.red : null,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onPressed,
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Помощь'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Магазин моторного масла "Oil Market"',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('ул. Дзержинского, 4, стр. 7'),
              const Text('Большой Камень'),
              const SizedBox(height: 10),
              const Text('Телефон: +7 950 286 55 25'),
              const SizedBox(height: 20),
              const Text(
                'Часы работы:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('Пн-Пт: 9:00 - 19:00'),
              const Text('Сб-Вс: 10:00 - 18:00'),
              const SizedBox(height: 20),
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