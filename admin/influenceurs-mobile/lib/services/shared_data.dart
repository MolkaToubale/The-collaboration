import 'package:shared_preferences/shared_preferences.dart';

class DataPrefrences {
  static late SharedPreferences _preferences;
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future<void> setLogin(String value) async =>
      await _preferences.setString("login", value);

  static String getLogin() => _preferences.getString('login') ?? "";

  static Future<void> setPassword(String value) async =>
      await _preferences.setString("password", value);

  static String getPassword() => _preferences.getString('password') ?? "";

  static Future<void> setDarkMode(bool value) async =>
      await _preferences.setBool("darkMode", value);

  static bool getDarkMode() => _preferences.getBool('darkMode') ?? false;

  static Future<void> setNotification(bool value) async =>
      await _preferences.setBool("notification", value);

  static bool getNotification() => _preferences.getBool('notification') ?? true;



}
