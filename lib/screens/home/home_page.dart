import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gconnect/constants.dart';
import 'package:gconnect/screens/account/login.dart';
import 'package:gconnect/services/auth_service.dart';
import 'package:gconnect/services/user_services.dart';
import 'package:gconnect/shared/custom_dialog.dart';
import 'package:gconnect/themes.dart';
import 'pages/favorite.dart';
import 'pages/home.dart';
import 'pages/mine_qr.dart';
import 'pages/profile.dart';
import 'package:provider/provider.dart';

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
        title: Text(ConstantTexts().appTitle),
        actions: [
          Consumer<ThemeNotifier>(
            builder: (context, notifier, child) => IconButton(
              icon: Icon(notifier.darkTheme
                  ? Icons.brightness_5_outlined
                  : Icons.brightness_4_outlined),
              onPressed: () {
                notifier.toggleTheme();
              },
            ),
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
            WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
          },
        ),
      ),
      floatingActionButton: FabCircularMenu(
          fabColor: ThemeNotifier().darkTheme ? Colors.deepPurpleAccent.shade700 : Colors.grey.shade800,
          ringColor: ThemeNotifier().darkTheme ? Colors.deepPurpleAccent.shade700 : Colors.grey.shade800,
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
      onPressed: () async {
        if (index == 4) {
          await qrScanner();
        } else {
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 200), curve: Curves.ease);
        }
      },
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(24.0),
      child: Icon(icon, color: Theme.of(context).iconTheme.color),
    );
  }

  bool onWillPop() {
    if (currentPage == 0) {
      SystemNavigator.pop();
    }
    _pageController.previousPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease,
    );
    --currentPage;
    return false;
  }

  Future qrScanner() async {
    try {
      final result = await BarcodeScanner.scan(
        options: const ScanOptions(
          strings: {'cancel': "Back"},
          android: AndroidOptions(
            aspectTolerance: 1,
            useAutoFocus: true,
          ),
        ),
      );
      if (result.rawContent.length == 28) {
        await UserService()
            .addContact(result.rawContent, false)
            .then((value) => {
                  showDialog(
                      context: context,
                      builder: (BuildContext buildContext) {
                        return const CustomDialogBox(
                          title: 'Success',
                          descriptions: "Profile updated successfully",
                          text: 'OK',
                          imagePath: 'assets/images/correct.png',
                          currentPage: "-2",
                        );
                      }),
                })
            .onError((error, stackTrace) => {
                  showDialog(
                      context: context,
                      builder: (BuildContext buildContext) {
                        return CustomDialogBox(
                          title: 'Failed',
                          descriptions: error.toString(),
                          text: 'OK',
                          imagePath: 'assets/images/wrong.png',
                          currentPage: "-2",
                        );
                      })
                });
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
