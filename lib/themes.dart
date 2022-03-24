import 'package:flutter/material.dart';

CustomTheme currentTheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  static bool isDarkTheme = false;
  ThemeMode get currentTheme => isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: Colors.deepPurpleAccent,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        dividerColor: Colors.deepPurpleAccent.shade100,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurpleAccent,
        ),
        buttonTheme: ButtonThemeData(
            buttonColor: Colors.deepPurpleAccent,
            textTheme: ButtonTextTheme.normal),
            
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Colors.black,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    );
  }
}
