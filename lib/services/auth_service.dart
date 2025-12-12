import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

class AuthService {
  static const String _baseUrl = 'https://fucknjava.github.io/api';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const Duration _timeout = Duration(seconds: 10);

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  Future<User?> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final User user = User.fromJson(data['user']);
        final String token = data['token'];

        await _saveAuthData(user, token);
        return user;
      } else {
        // Для демо: если API недоступно, создаем мокового пользователя
        if (email.isNotEmpty && password.isNotEmpty) {
          final User mockUser = User(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: email.split('@').first,
            email: email,
            phone: '+7 900 000 00 00',
            registeredAt: DateTime.now(),
          );
          
          await _saveAuthData(mockUser, 'mock_token');
          return mockUser;
        }
        return null;
      }
    } catch (e) {
      // Для демо: создаем мокового пользователя
      if (email.isNotEmpty && password.isNotEmpty) {
        final User mockUser = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: email.split('@').first,
          email: email,
          phone: '+7 900 000 00 00',
          registeredAt: DateTime.now(),
        );
        
        await _saveAuthData(mockUser, 'mock_token');
        return mockUser;
      }
      return null;
    }
  }

  Future<User?> register(String name, String email, String phone, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'name': name,
              'email': email,
              'phone': phone,
              'password': password,
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        final User user = User.fromJson(data['user']);
        final String token = data['token'];

        await _saveAuthData(user, token);
        return user;
      } else {
        // Для демо: создаем мокового пользователя
        final User mockUser = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          email: email,
          phone: phone,
          registeredAt: DateTime.now(),
        );
        
        await _saveAuthData(mockUser, 'mock_token');
        return mockUser;
      }
    } catch (e) {
      // Для демо: создаем мокового пользователя
      final User mockUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phone: phone,
        registeredAt: DateTime.now(),
      );
      
      await _saveAuthData(mockUser, 'mock_token');
      return mockUser;
    }
  }

  Future<void> _saveAuthData(User user, String token) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userKey, value: json.encode(user.toJson()));
  }

  Future<User?> getCurrentUser() async {
    try {
      final String? userData = await _storage.read(key: _userKey);
      if (userData != null) {
        return User.fromJson(json.decode(userData));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final String? token = await getToken();
    return token != null;
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }

  Future<void> updateProfile(User user) async {
    try {
      final String? token = await getToken();
      
      final response = await http
          .put(
            Uri.parse('$_baseUrl/auth/profile'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode(user.toJson()),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        await _storage.write(key: _userKey, value: json.encode(user.toJson()));
      }
    } catch (e) {
      // Локальное сохранение для демо
      await _storage.write(key: _userKey, value: json.encode(user.toJson()));
    }
  }
}