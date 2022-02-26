import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart'; 
import 'package:gconnect/home/home_pages/Favorite.dart';
import 'package:gconnect/home/home_pages/home.dart';
import 'package:gconnect/home/home_pages/mine_qr.dart';
import 'package:gconnect/home/home_pages/profile.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../services/userServices.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  
  Future scanQR() async { 
     
  }

  BottomNavyBarItem navigationItem(IconData icon, String title)
  {
    return  BottomNavyBarItem(
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
        title: const Text("G-Connect"),
        backgroundColor: Colors.purple,
        actions: <Widget>[
          IconBadge(
            icon: const Icon(Icons.notifications_none),
            itemCount: 100,
            badgeColor: Colors.red,
            itemColor: Colors.white,
            maxCount: 99,
            hideZero: true,
            onTap: () {
            },
          ),
        ],
      ),
      body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Home(),
            Favorite(),
            MineQR(),
            Profile()
          ],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
        qrScanner()
        },
        tooltip: 'Scan QR',
        child: const Icon(Icons.qr_code_scanner_outlined),
        backgroundColor: Colors.purple,
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) => setState(() {
              _currentIndex = index;
              _pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }),
        items: <BottomNavyBarItem>[
          navigationItem(Icons.home_outlined, "Home"),
          navigationItem(Icons.favorite_border_outlined, "Favorite"),
          navigationItem(Icons.qr_code_2_outlined, "My QR"),
          navigationItem(Icons.person_outline_outlined, "Profile")
        ],
      ),
    );
  }

  Future qrScanner() async {
    var cameraStatus = await Permission.camera.status;
    String? uid;
    if(cameraStatus.isGranted)
    {
      uid = await scanner.scan();
    }
    else
    {
      var isGrant = await Permission.camera.request();
      if(isGrant.isGranted)
      {
        uid = await scanner.scan();
      }
    }
    
    if(uid != null)
    {
      addUserInContactList(uid);
    }
    else
    {

    }
  }
}