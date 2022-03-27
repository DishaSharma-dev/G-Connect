import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

CustomTheme currentTheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  ThemeMode appTheme = ThemeMode.light;
  ThemeMode get currentTheme {
    getTheme();
    return appTheme;
  }

  getTheme() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey('Theme')) {
      appTheme = pref.getBool('Theme') == false ? ThemeMode.dark : ThemeMode.light;
    }
    appTheme = ThemeMode.light;
    notifyListeners();
  }

  void toggleTheme() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('Theme')) {
      pref.setBool('Theme', false);
    }
    pref.setBool('Theme', pref.getBool('Theme') == true ? false : true);
    appTheme = appTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.deepPurpleAccent.shade700,
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
  }

  static ThemeData get darkTheme {
    return ThemeData(
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
  }
}
