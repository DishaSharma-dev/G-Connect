import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
    MapController controller = MapController(
                            initMapWithUserPosition: false,
                            initPosition: GeoPoint(latitude: userData['latitude'], longitude: userData['longitude']),
                       );
  

    return WillPopScope(
      onWillPop: () => Future.sync(onWillPop),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                backCallback();
              },
              icon: const Icon(Icons.arrow_back)),
          title: const Text("Details"),
          centerTitle: true,
          elevation: 10,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SlidingUpPanel(
          backdropColor: Colors.white,
          maxHeight: panelHeightOpen,
          minHeight: panelHeightClosed,
          parallaxEnabled: true,
          parallaxOffset: .5,
          // body: U.OpenStreetMap(
          //   center: [userData['latitude'], userData['longitude']],
          //   type: OpenStreetMapType.Mapnik,
          //   markers: U.MarkerLayer([

          //     // marker icon
          //     U.Marker([userData['latitude'], userData['longitude']],
          //         widget: const MarkerIcon(
          //           icon: Icons.location_on,
          //           color: Colors.red,
          //         )),
          //   ]),
          //   zoom: 15,
          // ),
          body: OSMFlutter(
            controller: controller,
            trackMyPosition: false,
            initZoom: 12,
            minZoomLevel: 8,
            maxZoomLevel: 14,
            stepZoom: 1.0,
            userLocationMarker: UserLocationMaker(
              personMarker: MarkerIcon(
                icon: Icon(
                  Icons.location_history_rounded,
                  color: Colors.red,
                  size: 48,
                ),
              ),
              directionArrowMarker: MarkerIcon(
                icon: Icon(
                  Icons.double_arrow,
                  size: 48,
                ),
              ),
            ),
           
            markerOption: MarkerOption(
                defaultMarker: MarkerIcon(
              icon: Icon(
                Icons.person_pin_circle,
                color: Colors.blue,
                size: 56,
              ),
            )),
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

  Widget tileView(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
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
        child: Container(
          width: 90.0,
          height: 90.0,
          decoration: const BoxDecoration(
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
          style: const TextStyle(
              color: Colors.purpleAccent,
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
              tileView(Icons.email_outlined, userData['email']),
              tileView(Icons.phone_android_outlined, userData['mobile']),
              tileView(Icons.location_city_outlined,
                  userData['city'] + ", " + userData['country']),
              tileView(Icons.work_outline, userData['profession']),
              tileView(Icons.workspaces, userData['organisation']),
            ],
          )),
    ]);
  }
}

typedef BackCallback = void Function();
