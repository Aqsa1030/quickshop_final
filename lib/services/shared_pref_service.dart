import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  // First Launch
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstLaunch') ?? true;
  }

  static Future<void> setFirstLaunch(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', value);
  }

  // Login Status
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
  }

  // Theme
  static Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('themeMode') ?? 'light';
  }

  static Future<void> setThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode);
  }

  // User Data - Fixed to use proper IDs
  static Future<void> saveUserData(String id, String email, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', id);
    await prefs.setString('userEmail', email);
    await prefs.setString('userName', name);
    await prefs.setBool('isLoggedIn', true);
  }

  static Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString('user_id') ?? '',
      'email': prefs.getString('userEmail') ?? '',
      'name': prefs.getString('userName') ?? '',
    };
  }

  // Clear user data
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('userEmail');
    await prefs.remove('userName');
    await prefs.setBool('isLoggedIn', false);
  }

  // Clear all data
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}