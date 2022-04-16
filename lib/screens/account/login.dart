import 'package:flutter/material.dart';
import 'package:gconnect/services/auth_service.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_top.png",
              width: size.width * 0.3,
            ),
          ),
          Positioned(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Welcome To G-Connect",
                  style: TextStyle(
                      color: Colors.purpleAccent,
                      decoration: TextDecoration.none,
                      fontSize: 30,
                      fontFamily: 'Lato'),
                ),
                SizedBox(height: size.height * 0.05),
                Image.asset(
                  "assets/images/connect.png",
                  height: size.height * 0.45,
                ),
                SizedBox(height: size.height * 0.05),
                ElevatedButton.icon(
                  onPressed: () async {
                    await AuthService().signIn(context);
                  },
                  icon: const Icon(Icons.g_mobiledata),
                  label: const Text("Sign in with Google"),
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      primary: Colors.purpleAccent,
                      shadowColor: Colors.grey.shade400,
                      textStyle: const TextStyle(fontSize: 15)),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_bottom.png",
              width: size.width * 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
