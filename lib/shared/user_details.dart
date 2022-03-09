import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class UserDetail extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String userImg;
  const UserDetail({Key? key, required this.userData, required this.userImg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.6;
    final panelHeightClosed = MediaQuery.of(context).size.width * 0.4;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: const Text(
          "Details",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 10,
        backgroundColor: Colors.white,
      ),
      body: SlidingUpPanel(
        backdropColor: Colors.white,
        maxHeight: panelHeightOpen,
        minHeight: panelHeightClosed,
        panelBuilder: (controller) => PanelWidget(
          controller: controller,
          userData: userData,
          userImg: userImg,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
    );
  }
}

class PanelWidget extends StatelessWidget {
  final ScrollController controller;
  final Map<String, dynamic> userData;
  final String userImg;
  const PanelWidget(
      {Key? key,
      required this.controller,
      required this.userData,
      required this.userImg})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(children: <Widget>[
        CircleAvatar(
          radius: 50,
          child: Container( 
      width: 90.0,
      height: 90.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
            userImg,
            fit: BoxFit.fill,
          )),
    ),
        ),
        Text(
          userData['name'],
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.purpleAccent,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  leading: Icon(Icons.email_outlined),
                  title: Text(userData['email']),
                  visualDensity: VisualDensity(horizontal: 0, vertical: -3),
                ),
                ListTile(
                  leading: Icon(Icons.phone_android_outlined),
                  title: Text(userData['mobile']),
                  visualDensity: VisualDensity(horizontal: 0, vertical: -3),
                ),
                ListTile(
                  leading: Icon(Icons.location_city_outlined),
                  title: Text(userData['city'] + ", " + userData['country']),
                  visualDensity: VisualDensity(horizontal: 0, vertical: -3),
                ),
                ListTile(
                  leading: Icon(Icons.work_outline),
                  title: Text(userData['profession']),
                  visualDensity: VisualDensity(horizontal: 0, vertical: -3),
                ),
                ListTile(
                  leading: Icon(Icons.workspaces),
                  title: Text(userData['organization']),
                  visualDensity: VisualDensity(horizontal: 0, vertical: -3),
                ),
              ],
            )),
      ]);
}
