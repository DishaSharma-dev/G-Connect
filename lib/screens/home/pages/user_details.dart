import 'package:flutter/material.dart';
//import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:universe/universe.dart';

class UserDetail extends StatelessWidget {
  final BackCallback backCallback;
  final Map<String, dynamic> userData;
  const UserDetail(
      {Key? key, required this.userData, required this.backCallback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.7;
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.25;
     

    return WillPopScope(
      onWillPop: () => Future.sync(onWillPop),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                backCallback();
              },
              icon: const Icon(Icons.arrow_back)),
          title: const Text("Details"),
          centerTitle: true,
          elevation: 10,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
        body: SlidingUpPanel(
          color: Theme.of(context).cardColor,
          maxHeight: panelHeightOpen,
          minHeight: panelHeightClosed,
          parallaxEnabled: true,
          parallaxOffset: .5,
          body: U.OpenStreetMap(
            center: [userData['latitude'], userData['longitude']],
            type: OpenStreetMapType.Mapnik,
            
            markers: U.MarkerLayer([
              // marker icon
              U.Marker([userData['latitude'], userData['longitude']],
                  widget: const MarkerIcon(
                    icon: Icons.location_on,
                    color: Colors.red,
                  )),
            ]),
            zoom: 15,
          ),
          
          panelBuilder: (controller) =>
              PanelWidget(controller: controller, userData: userData),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        ),
      ),
    );
  }

  bool onWillPop() {
    backCallback();
    return false;
  }
}

class PanelWidget extends StatelessWidget {
  final ScrollController controller;
  final Map<String, dynamic> userData;
  const PanelWidget(
      {Key? key, required this.controller, required this.userData})
      : super(key: key);

  Widget tileView(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary,),
      title: Text(title),
      visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      const SizedBox(
        height: 12,
      ),
      Center(
        child: Container(
            width: 30,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            )),
      ),
      const SizedBox(
        height: 18,
      ),
      CircleAvatar(
        radius: 50,
        backgroundColor : Theme.of(context).cardColor,
        child: Container(
          width: 90.0,
          height: 90.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: userData['user_image'] != ""
                  ? Image.network(
                      userData['user_image'],
                      fit: BoxFit.fill,
                    )
                  : Image.asset(
                      "assets/images/avatar.png",
                      fit: BoxFit.fill,
                    )),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(
          userData['name'],
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).buttonColor,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              tileView(Icons.email_outlined, userData['email'], context),
              tileView(Icons.phone_android_outlined, userData['mobile'], context),
              tileView(Icons.location_city_outlined,
                  userData['city'] + ", " + userData['country'], context),
              tileView(Icons.work_outline, userData['profession'], context),
              tileView(Icons.workspaces, userData['organisation'], context),
            ],
          )),
    ]);
  }
}

typedef BackCallback = void Function();
