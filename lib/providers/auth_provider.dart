import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Имитация успешного входа
    if (email.isNotEmpty && password.isNotEmpty) {
      _user = User(
        id: '1',
        name: 'Пользователь',
        email: email,
        phone: '+7 900 000 00 00',
        registeredAt: DateTime.now(),
      );
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', email);
    } else {
      _error = 'Неверные данные';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(String name, String email, String phone, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Имитация успешной регистрации
    _user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      phone: phone,
      registeredAt: DateTime.now(),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', email);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userEmail');
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final email = prefs.getString('userEmail');

    if (isLoggedIn && email != null) {
      _user = User(
        id: '1',
        name: 'Пользователь',
        email: email,
        phone: '+7 900 000 00 00',
        registeredAt: DateTime.now(),
      );
      notifyListeners();
    }
  }
}