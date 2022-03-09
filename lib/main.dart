import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gconnect/home/home.dart';
import 'package:gconnect/intro_slider/intro_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_preview/device_preview.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final pref = await SharedPreferences.getInstance();

  if (pref.getBool('isUser') == true) {
    runApp(
      DevicePreview(
        enabled: true,
        builder: (context) => const MaterialApp(
          useInheritedMediaQuery: true,
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        ),
      ),
    );
  } else {
    runApp(
      DevicePreview(
        enabled: true,
        builder: (context) => const MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      home: IntroSlider(),
    );
  }
}
