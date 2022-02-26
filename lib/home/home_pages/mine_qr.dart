// ignore_for_file: unnecessary_new


import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MineQR extends StatefulWidget {
  MineQR({Key? key}) : super(key: key);

  @override
  State<MineQR> createState() => _MineQRState();
}

class _MineQRState extends State<MineQR> {
  String name = "", email = "", image = "", uid = "";

  Future<void> setSharedPreferenceValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString("user_name")!;
    email = prefs.getString("user_email")!;
    image = prefs.getString("user_image")!;
    uid = prefs.getString("user_uid")!;
  }

  @override
  initState() {
    super.initState();
    setSharedPreferenceValue();
  }

  @override
  Widget build(BuildContext context) {
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
                  backgroundImage: NetworkImage(image),
                  backgroundColor: Colors.transparent,
                )),
            Column(
              children: [
                Text(name),
                Text(email),
              ],
            ),
            QrImage(
              data: uid,
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
              onPressed: () {
              },
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
}
