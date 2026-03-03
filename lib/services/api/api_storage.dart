import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tang_soo_karate/models/user_model.dart';

class ApiStorage {
  ApiStorage._();

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'auth_user';

  static Future<SharedPreferences> _prefs() async {
    return SharedPreferences.getInstance();
  }

  static Future<void> setToken(String? token) async {
    final prefs = await _prefs();
    if (token == null || token.isEmpty) {
      await prefs.remove(_tokenKey);
      return;
    }
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await _prefs();
    return prefs.getString(_tokenKey);
  }

  static Future<void> setRefreshToken(String? token) async {
    final prefs = await _prefs();
    if (token == null || token.isEmpty) {
      await prefs.remove(_refreshTokenKey);
      return;
    }
    await prefs.setString(_refreshTokenKey, token);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await _prefs();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<void> setUser(UserModel? user) async {
    final prefs = await _prefs();
    if (user == null) {
      await prefs.remove(_userKey);
      return;
    }
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getUser() async {
    final prefs = await _prefs();
    final raw = prefs.getString(_userKey);
    if (raw == null || raw.isEmpty) return null;

    final parsed = jsonDecode(raw);
    if (parsed is! Map<String, dynamic>) return null;
    return UserModel.fromJson(parsed);
  }

  static Future<void> clearAuth() async {
    final prefs = await _prefs();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userKey);
  }
}
