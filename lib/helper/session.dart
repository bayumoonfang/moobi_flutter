



import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var value;

  static Future<String> getEmail() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString("email");
  }

  static Future<int> getValue() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getInt("value");
  }


}