import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../account/login.dart';
import '../home/home.dart';
import '../models/UserModel.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final userReference = FirebaseFirestore.instance.collection("user");

Future<void> authenticateUser(BuildContext context) async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  var result = await FirebaseAuth.instance.signInWithCredential(credential);
  if (kDebugMode) {
    print(result);
  }
  if (result.user != null) {
    await createUserIfNotExist(context);

    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('isUser', true);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  } else {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignInScreen()));
  }
}

createUserIfNotExist(BuildContext context) async {
  var newUser = UserModel();
  newUser.image = auth.currentUser?.photoURL;
  newUser.email = auth.currentUser?.email;
  newUser.name = auth.currentUser?.displayName;
  newUser.mobile = auth.currentUser?.phoneNumber;
  newUser.uid = auth.currentUser?.uid;

  userReference.doc(auth.currentUser?.uid).set(newUser.toMap(), SetOptions(merge: true));
  
  final sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("user_name", auth.currentUser!.displayName!);
  sharedPreferences.setString("user_email", auth.currentUser!.email!);
  sharedPreferences.setString("user_uid", auth.currentUser!.uid);
  sharedPreferences.setString("user_image", auth.currentUser!.photoURL!);
}
