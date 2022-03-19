import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:gconnect/account/login.dart';
import 'package:gconnect/home/home_pages/Favorite.dart';
import 'package:gconnect/home/home_pages/home.dart';
import 'package:gconnect/home/home_pages/mine_qr.dart';
import 'package:gconnect/home/home_pages/profile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';

import '../services/userServices.dart';

import 'dart:async';

class HomePage extends StatefulWidget {
  final int currentPage;
  const HomePage({Key? key, required this.currentPage}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(currentPage);
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final int currentPage;
  PageController _pageController = PageController();

  _HomePageState(this.currentPage);

  @override
  void initState() {
    _currentIndex = currentPage;
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  BottomNavyBarItem navigationItem(IconData icon, String title) {
    return BottomNavyBarItem(
      icon: Icon(icon),
      title: Text(title),
      activeColor: Colors.black,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "G-Connect",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                await auth.signOut();
                await googleSignIn.signOut();
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.clear();
                await Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()),
                    (r) => false);
              },
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.black,
              ))
        ],
      ),
      body: WillPopScope(
        onWillPop: () => Future.sync(onWillPop),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            if (mounted) {
              setState(() => _currentIndex = index);
            }
          },
          children: const <Widget>[Home(), Favorite(), MineQR(), ProfilePage()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {qrScanner()},
        tooltip: 'Scan QR',
        child: const Icon(Icons.qr_code_scanner_outlined),
        backgroundColor: Colors.purple,
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) => {
          if (mounted)
            {
              setState(() {
                _currentIndex = index;
                _pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.ease);
              })
            }
        },
        items: <BottomNavyBarItem>[
          navigationItem(Icons.home_outlined, "Home"),
          navigationItem(Icons.favorite_border_outlined, "Favorite"),
          navigationItem(Icons.qr_code_2_outlined, "My QR"),
          navigationItem(Icons.person_outline_outlined, "Profile")
        ],
      ),
    );
  }

  bool onWillPop() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease,
    );
    return false;
  }

  Future qrScanner() async {
    var cameraStatus = await Permission.camera.status;
    String? uid;
    if (cameraStatus.isGranted) {
      uid = await scanner.scan();
    } else {
      var isGrant = await Permission.camera.request();
      if (isGrant.isGranted) {
        uid = await scanner.scan();
      }
    }
    if (mounted && uid != null) {
      setState(() {
        addUserInContactList(uid!, false);
      });
    }
  }
}