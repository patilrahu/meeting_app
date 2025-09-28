import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static const isLogin = "isLogin";
  static Future<void> saveValue(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else {
      await prefs.setString(key, value.toString());
    }
  }

  static Future<dynamic> getValue(String key, Type type) async {
    final prefs = await SharedPreferences.getInstance();

    if (type == String) {
      return prefs.getString(key) ?? '';
    } else if (type == bool) {
      return prefs.getBool(key) ?? false;
    } else if (type == int) {
      return prefs.getInt(key) ?? 0;
    } else if (type == double) {
      return prefs.getDouble(key) ?? 0.0;
    } else if (type == List<String>) {
      return prefs.getStringList(key) ?? [];
    } else {
      return prefs.getString(key);
    }
  }

  static Future<void> removeKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
