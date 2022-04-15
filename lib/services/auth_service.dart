import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gconnect/models/user_model.dart';
import 'package:gconnect/screens/account/login.dart';
import 'package:gconnect/screens/home/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final userReference = FirebaseFirestore.instance.collection("user");

  // For signin User
  Future<void> signIn(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleUser.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      UserCredential result =
          await firebaseAuth.signInWithCredential(authCredential);

      if (result.user != null) {
        Map<String, dynamic>? result =
            await isUserExist(firebaseAuth.currentUser!.uid);
        result ??= await signUp();

        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("user_data", jsonEncode(result));

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage(currentPage: 0)));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));
      }
    }
  }

  //For signup user
  Future<Map<String, dynamic>> signUp() async {
    var newUser = UserModel(
        uid: firebaseAuth.currentUser!.uid,
        name: firebaseAuth.currentUser!.displayName!,
        email: firebaseAuth.currentUser!.email!,
        mobile: '',
        profession: '',
        organisation: '',
        description: '',
        street: '',
        country: '',
        state: '',
        city: '',
        pincode: '',
        contacts: []);

    Map<String, dynamic> userData = newUser.toJson();
    userReference.doc(firebaseAuth.currentUser?.uid).set(newUser.toJson());
    return userData;
  }

  //For checking user is exist or not
  Future isUserExist(String uid) async {
    Map<String, dynamic>? data;
    await userReference
        .doc(firebaseAuth.currentUser?.uid)
        .get()
        .then((snapshot) async => {
              if (snapshot.exists)
                {data = snapshot.data() as Map<String, dynamic>}
              else
                {data = null}
            });
    return data;
  }

  //For signout
  signOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }

}
