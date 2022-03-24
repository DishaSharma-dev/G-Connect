import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gconnect/services/user_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;


class MineQR extends StatefulWidget {
  const MineQR({Key? key}) : super(key: key);

  @override
  State<MineQR> createState() => _MineQRState();
}

class _MineQRState extends State<MineQR> {
  final GlobalKey genKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasData) {
            return const Center(
              child: Text("User not present"),
            );
          }
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError) {
            Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RepaintBoundary(
                  key: genKey,
                  child: Container(
                    margin: const EdgeInsets.all(25),
                    height: MediaQuery.of(context).size.height / 1.65,
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
                          ),
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
                                backgroundImage:
                                    renderImage(data['user_image']),
                                backgroundColor: Colors.transparent,
                              )),
                          Column(
                            children: [
                              Text(data["name"]),
                              Text(data["email"]),
                            ],
                          ),
                          QrImage(
                            data: data["uid"],
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                          const Text(
                              "Anyone can scan this QR to add you to therir contact list."),
                        ],
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.share_sharp,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  label: const Text('Share QR'),
                  onPressed: () async {
                    await takePicture(data['name']);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                )
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        future: setMineQRValue());
  }

  Future<Map<String, dynamic>> setMineQRValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> userData =
        jsonDecode(prefs.getString("user_data").toString())
            as Map<String, dynamic>;
    userData['user_image'] =
        await UserService().getUserProfileImage(userData['uid']);
    return userData;
  }

  renderImage(String image) {
    if (image == "") {
      return const AssetImage("assets/images/avatar.png");
    }
    return NetworkImage(image);
  }

  Future<void> takePicture(String name) async {
    RenderRepaintBoundary? boundary =
        genKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    ui.Image? image = await boundary?.toImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData? byteData =
        await image?.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();
    File imgFile = File('$directory/photo.png');
    await imgFile.writeAsBytes(pngBytes!);
    _onShare(context, imgFile.path, name);
  }

  void _onShare(BuildContext context, String path, String name) async {
    final box = context.findRenderObject() as RenderBox?;

    await Share.shareFiles([path],
        text: "G-Connect - Scan this QR to add " +
            name +
            " to your contact list.",
        subject: "QR CODE",
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }
}
