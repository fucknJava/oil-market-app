import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AppHelpers {
  // Форматирование цены
  static String formatPrice(double price, [String currency = '₽']) {
    final formatter = NumberFormat('#,##0', 'ru_RU');
    return '${formatter.format(price)} $currency';
  }

  // Форматирование даты
  static String formatDate(DateTime date, [String format = 'dd.MM.yyyy']) {
    return DateFormat(format, 'ru_RU').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd.MM.yyyy HH:mm', 'ru_RU').format(date);
  }

  // Форматирование номера телефона
  static String formatPhone(String phone) {
    if (phone.length == 11) {
      return '+7 (${phone.substring(1, 4)}) ${phone.substring(4, 7)}-${phone.substring(7, 9)}-${phone.substring(9)}';
    }
    return phone;
  }

  // Валидация email
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  // Валидация телефона
  static bool isValidPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    return cleaned.length >= 10;
  }

  // Получение инициалов из имени
  static String getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  // Расчет скидки
  static double calculateDiscount(double originalPrice, double discountPercent) {
    return originalPrice * (1 - discountPercent / 100);
  }

  // Получение цвета для типа масла
  static Color getOilTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'синтетическое':
        return const Color(0xFF1a237e);
      case 'полусинтетическое':
        return const Color(0xFF2196F3);
      case 'минеральное':
        return const Color(0xFF4CAF50);
      default:
        return Colors.grey;
    }
  }

  // Получение иконки для типа масла
  static IconData getOilTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'синтетическое':
        return Icons.oil_barrel;
      case 'полусинтетическое':
        return Icons.local_gas_station;
      case 'минеральное':
        return Icons.settings;
      default:
        return Icons.liquor;
    }
  }

  // Обработка ошибок сети
  static String getNetworkErrorMessage(dynamic error) {
    if (error is String) return error;
    
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('timeout')) {
      return 'Время ожидания истекло. Проверьте подключение к интернету.';
    } else if (errorString.contains('socket')) {
      return 'Нет подключения к интернету.';
    } else if (errorString.contains('404')) {
      return 'Ресурс не найден.';
    } else if (errorString.contains('500')) {
      return 'Ошибка сервера. Попробуйте позже.';
    } else {
      return 'Произошла ошибка. Попробуйте еще раз.';
    }
  }

  // Сокращение длинного текста
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }

  // Получение статуса наличия товара
  static String getStockStatus(int stock) {
    if (stock <= 0) return 'Нет в наличии';
    if (stock <= 5) return 'Мало';
    if (stock <= 10) return 'В наличии';
    return 'В наличии';
  }

  static Color getStockStatusColor(int stock) {
    if (stock <= 0) return Colors.red;
    if (stock <= 5) return Colors.orange;
    return Colors.green;
  }

  // Расчет стоимости доставки
  static double calculateDeliveryCost(String method, String city) {
    switch (method) {
      case 'pickup':
        return 0;
      case 'city':
        return 300;
      case 'russia':
        return city.toLowerCase().contains('москва') ||
                city.toLowerCase().contains('санкт-петербург')
            ? 500
            : 800;
      default:
        return 0;
    }
  }

  // Получение времени доставки
  static String getDeliveryTime(String method, String city) {
    switch (method) {
      case 'pickup':
        return 'Сегодня';
      case 'city':
        return '1-2 дня';
      case 'russia':
        return city.toLowerCase().contains('примор')
            ? '3-5 дней'
            : '5-7 дней';
      default:
        return '1-3 дня';
    }
  }

  // Проверка на пустую строку
  static bool isNullOrEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  // Генерация ID заказа
  static String generateOrderId() {
    final now = DateTime.now();
    final random = now.millisecondsSinceEpoch % 10000;
    return 'ORD${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${random.toString().padLeft(4, '0')}';
  }

  // Форматирование размера файла
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  // Копирование в буфер обмена с уведомлением
  static Future<void> copyToClipboard(
    BuildContext context,
    String text, [
    String message = 'Скопировано в буфер обмена',
  ]) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  // Открытие URL
  static Future<void> openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  // Показать подтверждающий диалог
  static Future<bool?> showConfirmDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Подтвердить'),
          ),
        ],
      ),
    );
  }

  // Показать информационный диалог
  static Future<void> showInfoDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}