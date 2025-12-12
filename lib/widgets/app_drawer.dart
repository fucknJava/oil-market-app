import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Drawer(
      child: Column(
        children: [
          // Заголовок
          UserAccountsDrawerHeader(
            accountName: Text(
              user?.name ?? 'Гость',
              style: const TextStyle(fontSize: 18),
            ),
            accountEmail: Text(
              user?.email ?? 'Войдите в аккаунт',
              style: const TextStyle(fontSize: 14),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                user != null ? Icons.person : Icons.person_outline,
                color: const Color(0xFF1a237e),
                size: 40,
              ),
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1a237e),
            ),
          ),

          // Основное меню
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                if (user != null) ...[
                  _buildDrawerItem(
                    context,
                    Icons.person,
                    'Мой профиль',
                    () {
                      Navigator.pop(context);
                      // Навигация в профиль
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.shopping_bag,
                    'Мои заказы',
                    () {
                      Navigator.pop(context);
                      // Навигация к заказам
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.favorite,
                    'Избранное',
                    () {
                      Navigator.pop(context);
                      // Навигация к избранному
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.location_on,
                    'Адреса доставки',
                    () {
                      Navigator.pop(context);
                      // Навигация к адресам
                    },
                  ),
                  const Divider(),
                ],

                // Общие пункты
                _buildDrawerItem(
                  context,
                  Icons.store,
                  'О магазине',
                  () {
                    Navigator.pop(context);
                    _showAboutDialog(context);
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.local_shipping,
                  'Доставка и оплата',
                  () {
                    Navigator.pop(context);
                    _showDeliveryInfoDialog(context);
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.contact_support,
                  'Контакты',
                  () {
                    Navigator.pop(context);
                    _showContactsDialog(context);
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.help,
                  'Помощь',
                  () {
                    Navigator.pop(context);
                    _showHelpDialog(context);
                  },
                ),

                const Divider(),

                // Настройки
                _buildDrawerItem(
                  context,
                  Icons.settings,
                  'Настройки',
                  () {
                    Navigator.pop(context);
                    // Навигация к настройкам
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.info,
                  'О приложении',
                  () {
                    Navigator.pop(context);
                    _showAppInfoDialog(context);
                  },
                ),

                const Divider(),

                // Вход/выход
                if (user != null)
                  _buildDrawerItem(
                    context,
                    Icons.logout,
                    'Выйти',
                    () {
                      authProvider.logout();
                      Navigator.pop(context);
                    },
                    color: Colors.red,
                  )
                else
                  _buildDrawerItem(
                    context,
                    Icons.login,
                    'Войти',
                    () {
                      Navigator.pop(context);
                      // Навигация к экрану входа
                    },
                  ),
              ],
            ),
          ),

          // Футер
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              children: [
                const Text(
                  'Oil Market v1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '© ${DateTime.now().year} Все права защищены',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? const Color(0xFF1a237e),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.black87,
        ),
      ),
      trailing: color == null
          ? const Icon(Icons.chevron_right, color: Colors.grey)
          : null,
      onTap: onTap,
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('О магазине'),
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
              const Text(
                'Мы специализируемся на продаже качественных моторных масел ведущих мировых и российских производителей.',
              ),
              const SizedBox(height: 10),
              const Text(
                'Наш ассортимент включает:',
              ),
              const SizedBox(height: 5),
              const Text('• Синтетические масла'),
              const Text('• Полусинтетические масла'),
              const Text('• Минеральные масла'),
              const Text('• Специальные масла для дизельных двигателей'),
              const SizedBox(height: 10),
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

  void _showDeliveryInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Доставка и оплата'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Способы доставки:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text('• Самовывоз: бесплатно'),
              const Text('• Курьером по городу: 300 руб.'),
              const Text('• По России: от 500 руб.'),
              const SizedBox(height: 10),
              const Text(
                'Способы оплаты:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text('• Банковской картой онлайн'),
              const Text('• Наличными при получении'),
              const Text('• Картой при получении'),
              const SizedBox(height: 10),
              const Text(
                'Сроки доставки:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text('• Самовывоз: в день заказа'),
              const Text('• Курьером: 1-2 дня'),
              const Text('• По России: 3-7 дней'),
              const SizedBox(height: 10),
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

  void _showContactsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Контакты'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Наши контакты:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('📍 Адрес:'),
              const Text('ул. Дзержинского, 4, стр. 7'),
              const Text('Большой Камень, Приморский край'),
              const SizedBox(height: 10),
              const Text('📞 Телефон:'),
              const Text('+7 950 286 55 25'),
              const SizedBox(height: 10),
              const Text('📧 Email:'),
              const Text('info@oil-market.ru'),
              const SizedBox(height: 10),
              const Text('🕒 Часы работы:'),
              const Text('Пн-Пт: 9:00 - 19:00'),
              const Text('Сб-Вс: 10:00 - 18:00'),
              const SizedBox(height: 10),
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
                'Часто задаваемые вопросы:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Q: Как выбрать моторное масло?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                  'A: Ориентируйтесь на рекомендации производителя вашего автомобиля.'),
              const SizedBox(height: 10),
              const Text(
                'Q: Как оформить заказ?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                  'A: Добавьте товары в корзину, перейдите в корзину и нажмите "Оформить заказ".'),
              const SizedBox(height: 10),
              const Text(
                'Q: Можно ли вернуть товар?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                  'A: Да, в течение 14 дней при сохранении товарного вида.'),
              const SizedBox(height: 10),
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

  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('О приложении'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Oil Market - магазин моторных масел',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('Версия: 1.0.0'),
              const Text('Сборка: 2023122501'),
              const SizedBox(height: 10),
              const Text(
                'Разработчик:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('ООО "Oil Market"'),
              const SizedBox(height: 10),
              const Text(
                'Контакт для технической поддержки:',
              ),
              const Text('support@oil-market.ru'),
              const SizedBox(height: 10),
              const Text(
                'Приложение разработано на Flutter',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 10),
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