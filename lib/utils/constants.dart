import 'package:flutter/material.dart';

class AppConstants {
  // Цвета приложения
  static const primaryColor = 0xFF1a237e;
  static const primaryColorLight = 0xFF534bae;
  static const primaryColorDark = 0xFF000051;
  static const secondaryColor = 0xFFff9800;
  static const backgroundColor = 0xFFf5f5f5;
  static const textColor = 0xFF333333;
  static const textLightColor = 0xFF666666;
  static const errorColor = 0xFFd32f2f;
  static const successColor = 0xFF388e3c;
  static const warningColor = 0xFFf57c00;
  static const infoColor = 0xFF1976d2;

  // Текст
  static const appName = 'Oil Market';
  static const appSlogan = 'Качественные моторные масла';
  static const storeAddress = 'ул. Дзержинского, 4, стр. 7';
  static const storeCity = 'Большой Камень, Приморский край';
  static const storePhone = '+7 950 286 55 25';
  static const storeEmail = 'info@oil-market.ru';

  // API константы
  static const apiBaseUrl = 'https://fucknjava.github.io/api';
  static const productsEndpoint = '/products';
  static const ordersEndpoint = '/orders';
  static const authEndpoint = '/auth';

  // Настройки приложения
  static const defaultCurrency = '₽';
  static const defaultLanguage = 'ru';
  static const defaultCountry = 'RU';
  static const itemsPerPage = 20;
  static const cacheDuration = Duration(hours: 1);

  // Локальное хранилище ключи
  static const authTokenKey = 'auth_token';
  static const userDataKey = 'user_data';
  static const cartDataKey = 'cart_data';
  static const favoritesKey = 'favorites_data';
  static const themeKey = 'app_theme';
  static const localeKey = 'app_locale';

  // URL изображений-заглушек
  static const placeholderImage = 'https://via.placeholder.com/300x300?text=Oil+Market';
  static const logoUrl = 'https://via.placeholder.com/150x50?text=Oil+Market+Logo';

  // Списки для фильтров
  static const List<String> oilTypes = [
    'Все',
    'Синтетическое',
    'Полусинтетическое',
    'Минеральное',
  ];

  static const List<String> oilViscosities = [
    'Все',
    '0W-20',
    '5W-30',
    '5W-40',
    '10W-40',
    '15W-40',
  ];

  static const List<String> oilBrands = [
    'Все',
    'Mobil',
    'Castrol',
    'Shell',
    'Lukoil',
    'Rosneft',
    'ZIC',
    'Toyota',
    'Total',
  ];

  static const List<String> oilStandards = [
    'API SN Plus',
    'API SN',
    'API SP',
    'ACEA A3/B4',
    'ACEA C3',
    'ILSAC GF-6',
    'ILSAC GF-5',
  ];

  static const List<String> oilVolumes = [
    '1L',
    '4L',
    '5L',
    '10L',
    '20L',
    '60L',
    '208L',
  ];

  // Ценовые диапазоны
  static const minPrice = 0;
  static const maxPrice = 10000;
  static const priceSteps = [500, 1000, 2000, 5000];

  // Статусы заказов
  static const Map<String, String> orderStatuses = {
    'pending': 'Ожидает обработки',
    'processing': 'В обработке',
    'shipped': 'Отправлен',
    'delivered': 'Доставлен',
    'cancelled': 'Отменен',
  };

  static const Map<String, Color> orderStatusColors = {
    'pending': Colors.orange,
    'processing': Colors.blue,
    'shipped': Colors.purple,
    'delivered': Colors.green,
    'cancelled': Colors.red,
  };

  // Способы доставки
  static const Map<String, String> deliveryMethods = {
    'pickup': 'Самовывоз',
    'city': 'Курьером по городу',
    'russia': 'По России',
  };

  static const Map<String, double> deliveryPrices = {
    'pickup': 0,
    'city': 300,
    'russia': 500,
  };

  // Способы оплаты
  static const Map<String, String> paymentMethods = {
    'card': 'Банковской картой онлайн',
    'cash': 'Наличными при получении',
    'card_delivery': 'Картой при получении',
  };
}

// Класс для работы с путями навигации
class AppRoutes {
  static const home = '/';
  static const catalog = '/catalog';
  static const productDetail = '/product';
  static const cart = '/cart';
  static const favorites = '/favorites';
  static const profile = '/profile';
  static const auth = '/auth';
  static const order = '/order';
  static const ordersHistory = '/orders';
  static const deliveryInfo = '/delivery';
  static const about = '/about';
  static const settings = '/settings';
}

// Класс для работы с локализацией
class AppStrings {
  static const welcome = 'Добро пожаловать в Oil Market';
  static const popularProducts = 'Популярные товары';
  static const allProducts = 'Все товары';
  static const addToCart = 'Добавить в корзину';
  static const inCart = 'В корзине';
  static const orderNow = 'Оформить заказ';
  static const continueShopping = 'Продолжить покупки';
  static const emptyCart = 'Корзина пуста';
  static const emptyFavorites = 'Нет избранных товаров';
  static const searchHint = 'Поиск моторных масел...';
  static const filter = 'Фильтры';
  static const sort = 'Сортировка';
  static const priceLowToHigh = 'По возрастанию цены';
  static const priceHighToLow = 'По убыванию цены';
  static const nameAZ = 'По названию (А-Я)';
  static const nameZA = 'По названию (Я-А)';
  static const loading = 'Загрузка...';
  static const error = 'Ошибка';
  static const retry = 'Повторить';
  static const noInternet = 'Нет подключения к интернету';
  static const checkConnection = 'Проверьте подключение и повторите попытку';
}