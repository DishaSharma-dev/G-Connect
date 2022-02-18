import 'package:flutter/material.dart';
import 'login_controller.dart';

class SignInScreen extends StatefulWidget {
const SignInScreen({ Key? key}) : super(key: key);

@override
_SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
@override
Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
    // ignore: sized_box_for_whitespace
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
              const Text(
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
              onPressed: () {
              signup(context);
            },
            icon: const Icon(Icons.g_mobiledata),
            label: const Text("Sign in with Google"),
            style: ElevatedButton.styleFrom(shape: const StadiumBorder(), primary: Colors.purple, shadowColor: Colors.purpleAccent, textStyle: const TextStyle(fontSize: 15)),
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
	// return Scaffold(
	// body: Container(
	// 	width: double.infinity,
	// 	height: double.infinity,
	// 	decoration: const BoxDecoration(
	// 	gradient: LinearGradient(
	// 		colors: [
	// 		Colors.blue,
	// 		Colors.red,
	// 		],
	// 	),
	// 	),
	// 	child: Card(
	// 	margin: const EdgeInsets.only(top: 200, bottom: 200, left: 30, right: 30),
	// 	elevation: 20,
	// 	child: Column(
	// 		mainAxisAlignment: MainAxisAlignment.spaceEvenly,
	// 		children: [
	// 		const Text(
	// 			"Welcome",
	// 			style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
	// 		),
	// 		Padding(
	// 			padding: const EdgeInsets.only(left: 20, right: 20),
	// 			child: MaterialButton(
	// 			color: Colors.teal[100],
	// 			elevation: 10,
	// 			child: Row(
	// 				mainAxisAlignment: MainAxisAlignment.start,
	// 				children: [
	// 				Container(
	// 					height: 30.0,
	// 					width: 30.0,
	// 					decoration: const BoxDecoration(
	// 					image: DecorationImage(
	// 						image:
	// 							AssetImage('assets/images/googleimage.png'),
	// 						fit: BoxFit.cover),
	// 					shape: BoxShape.circle,
	// 					),
	// 				),
	// 				const SizedBox(
	// 					width: 20,
	// 				),
	// 				const Text("Sign In with Google")
	// 				],
	// 			),
				
	// 			// by onpressed we call the function signup function
	// 			onPressed: () {
	// 				signup(context);
	// 			},
	// 			),
	// 		)
	// 		],
	// 	),
	// 	),
	// ),
	// );
}
}
