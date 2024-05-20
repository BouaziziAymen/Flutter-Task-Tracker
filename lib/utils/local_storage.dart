import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late final SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveString(String key, String value) async {
    await prefs.setString(key, value);
  }

  static String? readString(String key) {
    return prefs.getString(key);
  }
}
