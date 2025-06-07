import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  factory StorageService() {
    _instance ??= StorageService._();
    return _instance!;
  }

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Save data
  static Future<bool> saveData(String key, Map<String, dynamic> data) async {
    await init();
    final jsonString = jsonEncode(data);
    return await _prefs!.setString(key, jsonString);
  }

  // Get data
  static Future<Map<String, dynamic>?> getData(String key) async {
    await init();
    final jsonString = _prefs!.getString(key);
    if (jsonString != null) {
      try {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Save list
  static Future<bool> saveList(String key, List<Map<String, dynamic>> data) async {
    await init();
    final jsonString = jsonEncode(data);
    return await _prefs!.setString(key, jsonString);
  }

  // Get list
  static Future<List<Map<String, dynamic>>?> getList(String key) async {
    await init();
    final jsonString = _prefs!.getString(key);
    if (jsonString != null) {
      try {
        final List<dynamic> decoded = jsonDecode(jsonString);
        return decoded.cast<Map<String, dynamic>>();
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Remove data
  static Future<bool> remove(String key) async {
    await init();
    return await _prefs!.remove(key);
  }

  // Clear all
  static Future<bool> clear() async {
    await init();
    return await _prefs!.clear();
  }
}