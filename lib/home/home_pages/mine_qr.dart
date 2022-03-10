// ignore_for_file: unnecessary_new

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gconnect/services/userServices.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MineQR extends StatefulWidget {
  const MineQR({Key? key}) : super(key: key);

  @override
  State<MineQR> createState() => _MineQRState();
}

class _MineQRState extends State<MineQR> {
  Map<String, dynamic>? user_data;
  String? userImage;
  Future<void> setSharedPreferenceValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_data = jsonDecode(prefs.getString("user_data").toString())
        as Map<String, dynamic>;
    getUserImage();
  }

  @override
  initState() {
    super.initState();
    setSharedPreferenceValue();
  }

  @override
  Widget build(BuildContext context) {
    if(user_data != null && userImage != null)
    {
        return Container(
      margin: const EdgeInsets.all(25),
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.deepPurpleAccent,
              width: 1,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(
                1.0,
                1.0,
              ),
              blurRadius: 10.0,
              spreadRadius: 2.0,
            ), //BoxShadow
            BoxShadow(
              color: Colors.white,
              offset: Offset(0.0, 0.0),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            ), //BoxShadow
          ]),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                        width: 1,
                        style: BorderStyle.solid,
                        color: Colors.deepPurpleAccent)),
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(userImage!),
                  backgroundColor: Colors.transparent,
                )),
            Column(
              children: [
                Text(user_data!["name"]),
                Text(user_data!["email"]),
              ],
            ),
            QrImage(
              data: user_data!["uid"],
              version: QrVersions.auto,
              size: 200.0,
            ),
            const Text(
                "Anyone can scan this QR to add you to therir contact list."),
            ElevatedButton.icon(
              icon: const Icon(
                Icons.share_sharp,
                color: Colors.white,
                size: 30.0,
              ),
              label: const Text('Share QR'),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurpleAccent,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
    }
    return LoadingAnimationWidget.prograssiveDots(
      color: Colors.deepPurpleAccent,
      size: 50,
    );
}

  getUserImage() async {
      final sharedPreferences = await SharedPreferences.getInstance();
  String userUID =
      jsonDecode(sharedPreferences.getString("user_data").toString())['uid'];

    String img = await getUserProfileImage(userUID);

    setState(() {
      userImage = img;
    });
  }
}
