import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

MediaQueryData getSize(BuildContext context) {
  return MediaQuery.of(context);
}

extension TodoColorScheme on ColorScheme {
  Color get green => Color.fromARGB(255, 0, 255, 149);
  Color get red => Color.fromARGB(255, 255, 30, 90);
  Color get blue => Color.fromARGB(255, 15, 71, 184);
  Color get yellow => Color.fromARGB(255, 225, 255, 0);
  Color get purple => Color.fromARGB(255, 98, 0, 46);
  Color get orange => Color.fromARGB(255, 245, 100, 60);
}

final themeDark = ThemeData(
    backgroundColor: Color.fromARGB(255, 20, 30, 40),
    accentColor: Color.fromARGB(255, 25, 35, 45),
    primaryColor: Colors.white,
    brightness: Brightness.dark);

final themeLight = ThemeData(
    backgroundColor: Color.fromARGB(255, 230, 230, 230),
    accentColor: Color.fromARGB(255, 204, 204, 204),
    primaryColor: Color.fromARGB(255, 20, 30, 40),
    brightness: Brightness.light);

class TodoThemeMode with ChangeNotifier {
  static bool _isDark = true;

  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

final todoThemeMode = TodoThemeMode();
