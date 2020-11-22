import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> getPrefsEmailPassword() async {
  Map item = Map<String, dynamic>();
  var prefs = await SharedPreferences.getInstance();
  item["email"] = prefs.getString("email");
  item["password"] = prefs.getString("password");
  return item;
}

void setPrefsEmailPassword(String email, String password) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString("email", email);
  prefs.setString("password", password);
}

void resetPrefsEmailPassword() async {
  var prefs = await SharedPreferences.getInstance();
  prefs.remove("email");
  prefs.remove("password");
}
