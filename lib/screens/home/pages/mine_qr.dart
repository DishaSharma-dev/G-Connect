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
  late Future mineQRFuture;
  @override
  void initState() {
    super.initState();
    mineQRFuture = setMineQRValue();
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
                    height: MediaQuery.of(context).size.height / 1.55,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary,
                            offset: const Offset(
                              0.5,
                              0.5,
                            ),
                            blurRadius: 6.0,
                            spreadRadius: 1.0,
                          ),
                          const BoxShadow(
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
                              width: 75,
                              height: 75,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 2,
                                      style: BorderStyle.solid,
                                      color: Colors.white)),
                              child: CircleAvatar(
                                radius: 30.0,
                                backgroundImage:
                                    renderImage(data['user_image']),
                                backgroundColor: Colors.transparent,
                              )),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(data["name"],
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(data["email"],
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme.primary,
                                    )),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: QrImage(
                              data: data["uid"],
                              version: QrVersions.auto,
                              size: 200.0,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "Anyone can scan this QR to add you to therir contact list.",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.share_sharp,
                    size: 30.0,
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).buttonColor),
                  ),
                  label: const Text('Share QR'),
                  onPressed: () async {
                    await takePicture(data['name']);
                  },
                )
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        future: mineQRFuture);
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
