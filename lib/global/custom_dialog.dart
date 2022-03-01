import 'package:flutter/material.dart';

Widget customDialog(BuildContext context, String title, String description,
    String btnText, IconData icon) {
  return Padding(
    padding: const EdgeInsets.all(25.0),
    child: Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height/3.50,
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/4),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // To make the card compact
            children: <Widget>[
              const SizedBox(height: 25.0),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black
                ),
              ),
              const SizedBox(height: 18.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black
                ),
              ),
              const SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // To close the dialog
                  },
                  child: Text(btnText, style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.deepPurpleAccent
                  )),
                ),
              ),
            ],
          ),
        ),
        const Positioned(
          left: 16,
          right: 16,
          height: 70,
          top: 120,  
          child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/images/check_icon.png'),
            radius: 100,
          ),
        ),
      ],
    ),
  );
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
