import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils {
  static SharedPreferences? _prefs;

  static const String _keyUserId = 'user_id';
  static const String _keyIsLoggedIn = 'is_logged_in';

  /// Initialize prefs (call once in main)
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ------------------ Generic Methods ------------------

  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static String? getString(String key) => _prefs?.getString(key);

  static Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  static bool? getBool(String key) => _prefs?.getBool(key);

  static Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  static int? getInt(String key) => _prefs?.getInt(key);

  static Future<void> setObject(String key, Object value) async {
    final jsonString = jsonEncode(value);
    await _prefs?.setString(key, jsonString);
  }

  static Map<String, dynamic>? getObject(String key) {
    final jsonString = _prefs?.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }

  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  static Future<void> clear() async {
    await _prefs?.clear();
  }

  // ------------------ Auth Helpers ------------------

  /// Save user login data (ID + flag)
  static Future<void> saveUserSession(String userId) async {
    await _prefs?.setString(_keyUserId, userId);
    await _prefs?.setBool(_keyIsLoggedIn, true);
  }

  /// Get saved user ID
  static String? getUserId() => _prefs?.getString(_keyUserId);

  /// Check login state
  static bool isLoggedIn() => _prefs?.getBool(_keyIsLoggedIn) ?? false;

  /// Logout user
  static Future<void> clearUserSession() async {
    await _prefs?.remove(_keyUserId);
    await _prefs?.setBool(_keyIsLoggedIn, false);
  }
}
