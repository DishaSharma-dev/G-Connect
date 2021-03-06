import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gconnect/home/home.dart';
import 'package:gconnect/intro_slider/intro_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final pref = await SharedPreferences.getInstance();

  if (pref.getBool('isUser') == true) {
    runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));
  } else {
    runApp(
      const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroSlider(),
    );
  }
}
