import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.deepPurpleAccent.shade700,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.deepPurpleAccent,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.black87,
          secondary: Colors.black45,
          error: Colors.red,
          background: Colors.white,
          onBackground: Colors.deepPurpleAccent.shade100),
      textTheme: TextTheme(
        headline6: const TextStyle(
          color: Colors.black,
        ),
        subtitle1: TextStyle(
          color: Colors.grey.shade500,
        ),
        subtitle2: TextStyle(
          color: Colors.grey.shade600,
        ),
      ),
      cardColor: Colors.white,
      buttonColor: Colors.deepPurpleAccent.shade200,
    );

ThemeData dark = ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade800),
        backgroundColor: Colors.grey.shade900,
        cardColor: Colors.grey.shade800,
        scaffoldBackgroundColor: Colors.grey.shade900,
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.white60,
            secondary: Colors.white54,
            error: Colors.red,
            background: Colors.grey.shade800,
            onBackground: Colors.white54),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.grey.shade800,
      ),
        textTheme: TextTheme(
          headline6: const TextStyle(
            color: Colors.white60,
          ),
          subtitle1: TextStyle(
            color: Colors.grey.shade500,
          ),
          subtitle2: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
        buttonColor: Colors.grey.shade500,
        iconTheme: const IconThemeData(color: Colors.white));
  

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences? _prefs;
  bool _darkTheme = true;

  bool get darkTheme => _darkTheme;
  
  ThemeNotifier() {
    _darkTheme = true;
    _loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if(_prefs == null)
      _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _prefs?.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs()async {
    await _initPrefs();
    _prefs?.setBool(key, _darkTheme);
  }

}