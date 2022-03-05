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

  Map<String, dynamic> userData = newUser.toMap();

  userReference.doc(auth.currentUser?.uid).get().then((snapshot) => {
        if (snapshot.exists)
          {userData = snapshot.data() as Map<String, String>}
        else
          {userReference.doc(auth.currentUser?.uid).set(newUser.toMap())}
      });

  final sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("user_data", jsonEncode(userData));
}

addUserInContactList(BuildContext context, String uid) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  String? userUID =
      jsonDecode(sharedPreferences.getString("user_data").toString())['uid'];
  debugPrint(userUID);
  userReference.doc(uid).get().then((value) => {
        if (value.exists)
          {
            userReference
                .doc(userUID)
                .update({
                  "contacts": FieldValue.arrayUnion([
                    {"uid": uid, "isFavorite": false}
                  ])
                })
                .whenComplete(() => {})
                .catchError((e) => {})
          }
        else
          {}
      });
}
