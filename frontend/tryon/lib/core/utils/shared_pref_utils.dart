import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils {
  static SharedPreferences? _prefs;

  /// Initialize prefs (call once in main)
  static Future init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Save string value
  static Future setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  /// Get string value
  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  /// Save bool value
  static Future setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  /// Get bool value
  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  /// Save int value
  static Future setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  /// Get int value
  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  /// Save any object (encoded as JSON)
  static Future setObject(String key, Object value) async {
    final jsonString = jsonEncode(value);
    await _prefs?.setString(key, jsonString);
  }

  /// Get any object (decoded JSON)
  static Map<String, dynamic>? getObject(String key) {
    final jsonString = _prefs?.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }

  /// Remove a specific key
  static Future remove(String key) async {
    await _prefs?.remove(key);
  }

  /// Clear all stored data
  static Future clear() async {
    await _prefs?.clear();
  }
}
