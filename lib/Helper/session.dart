



import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var value;

  static Future<String> getEmail() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString("email");
  }

  static Future<String> getRole() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString("role");
  }

  static Future<String> getLevel() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString("level");
  }

  static Future<int> getValue() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getInt("value");
  }

  static Future<String> legalCode() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString("legalCode");
  }

  static Future<String> legalName() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString("legalName");
  }
  static Future<String> legalId() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString("legalId");
  }

  static Future<String> namaUser() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString("namaUser");
  }
  static Future<String> legalPhone() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString("legalPhone");
  }

  static Future<String> userId() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString("userId");
  }

  static Future<String> legalIdCode() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString("legalIdCode");
  }

  static Future<String> serverName() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString("serverName");
  }

  static Future<String> serverCode() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString("serverCode");
  }

}