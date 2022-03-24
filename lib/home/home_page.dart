import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:gconnect/constants.dart';
import 'package:gconnect/screens/account/login.dart';
import 'package:gconnect/services/auth_service.dart';
import 'package:gconnect/services/user_services.dart';
import 'package:gconnect/themes.dart';
import 'pages/favorite.dart';
import 'pages/home.dart';
import 'pages/mine_qr.dart';
import 'pages/profile.dart';

class HomePage extends StatefulWidget {
  final int currentPage;
  const HomePage({Key? key, required this.currentPage}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState(currentPage);
}

class _HomePageState extends State<HomePage> {
  int currentPage;
  final PageController _pageController = PageController();

  _HomePageState(this.currentPage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(ConstantTexts().appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode_outlined),
            onPressed: () {
              currentTheme.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                  (r) => false);
            },
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () => Future.sync(onWillPop),
        child: PageView(
          controller: _pageController,
          children: const <Widget>[Home(), Favorite(), MineQR(), Profile()],
          onPageChanged: (index) {
            setState(() => currentPage = index);
          },
        ),
      ),
      floatingActionButton: FabCircularMenu(
        ringColor: Theme.of(context).primaryColor,
        children: <Widget>[
        menuItem(Icons.home_outlined, "Home", 0),
        menuItem(Icons.favorite_border_outlined, "Favorite", 1),
        menuItem(Icons.qr_code_outlined, "Mine QR", 2),
        menuItem(Icons.person_outline_sharp, "Profile", 3),
        menuItem(Icons.qr_code_scanner_outlined, "Scan QR", 4),
      ]),
    );
  }

  Widget menuItem(IconData icon, String title, int index) {
    return RawMaterialButton(
      onPressed: () {
        setState(() {
          if (index == 4) {
            qrScanner();
          } else {
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.ease);
          }
        });
      },
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(24.0),
      child: Icon(icon, color: Theme.of(context).iconTheme.color),
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
    var result = await BarcodeScanner.scan(
      options: const ScanOptions(
        strings: {
          'cancel': "Back"
        },
        android: AndroidOptions(
          aspectTolerance: 1
        ),
      ),
    );
    UserService().addContact(result.rawContent, false);
  }
}
