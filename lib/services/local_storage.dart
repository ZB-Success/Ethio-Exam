import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveUserAuth(String token, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
    await prefs.setString("email", email);
  }

  static Future<Map<String, String?>> getAuth() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "token": prefs.getString("token"),
      "email": prefs.getString("email"),
    };
  }

  static Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
