

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gconnect/constants.dart';
import 'package:gconnect/screens/home/home_page.dart';
import 'package:gconnect/screens/intro_slider/intro_slider.dart';
import 'package:gconnect/services/auth_service.dart';
import 'package:gconnect/themes.dart';


Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            bool isLogged = snapshot.data as bool;
            if (isLogged) {
              return const HomePage(currentPage: 0);
            } else {
              return const IntroSlider();
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        future: getDestination(),
      ),
      title: ConstantTexts().appTitle,
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: currentTheme.currentTheme,
    );
  }

  Future<bool> getDestination() async {
    return await AuthService().googleSignIn.isSignedIn();
  }
}
