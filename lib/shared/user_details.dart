import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


class Favorite extends StatelessWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final panelHeightOpen = MediaQuery.of(context).size.height*0.6;
    final panelHeightClosed = MediaQuery.of(context).size.width*0.4;
    return Scaffold(
      body: SlidingUpPanel(backdropColor: Colors.white,
      maxHeight: panelHeightOpen,
      minHeight: panelHeightClosed,
      panelBuilder: (controller) => PanelWidget(
        controller : controller,
      ),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ) ,
    );
  }
}

class PanelWidget extends StatelessWidget {
  final ScrollController controller;
  const PanelWidget({ Key? key , required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context)  => ListView(
      children:  <Widget>[
       const CircleAvatar(
         radius: 50,
         child: Image(image: AssetImage('assets/images/avatar.png'),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
         ),
       ),
       const Text('Disha Sharma',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 20),
       ),
       Padding(
         padding: const EdgeInsets.only(top: 20.0),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: const [
            ListTile(
              leading: Icon(Icons.email_outlined),
              title: Text('sharmadisha681@gmail.com'),
              visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            ),  
            ListTile(
              leading: Icon(Icons.phone_android_outlined),
              title: Text('9810554720'),
              visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            ),
            ListTile(
              leading: Icon(Icons.location_city_outlined),
              title: Text('Delhi, India'),
              visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            ),
            ListTile(
              leading: Icon(Icons.work_outline),
              title: Text('Software Engineer'),
              visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            ),
             ListTile(
              leading: Icon(Icons.workspaces),
              title: Text('Google, Delhi'),
              visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            ),
           ],
         )
        ),
        
      ]
  );
}