import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../account/login.dart';
import '../home/home.dart';
import '../models/UserModel.dart';
import 'dart:async';

import 'package:flutter/services.dart' show rootBundle;

final FirebaseAuth auth = FirebaseAuth.instance;
final userReference = FirebaseFirestore.instance.collection("user");

final FirebaseStorage storage = FirebaseStorage.instance;

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
  var newUser = UserModel(
      city: '',
      contacts: [],
      country: '',
      description: '',
      email: auth.currentUser!.email!,
      mobile: '',
      name: auth.currentUser!.displayName!,
      organisation: '',
      pincode: '',
      profession: '',
      state: '',
      street: '',
      uid: auth.currentUser!.uid);

  Map<String, dynamic> userData = newUser.toMap();

  File newUserImage = await getImageFileFromAssets('avatar.png');
  final sharedPreferences = await SharedPreferences.getInstance();
  userReference.doc(auth.currentUser?.uid).get().then((snapshot) => {
        if (snapshot.exists)
          {
            userData = snapshot.data() as Map<String, dynamic>,
            sharedPreferences.setString("user_data", jsonEncode(userData))
          }
        else
          {
            userReference
                .doc(auth.currentUser?.uid)
                .set(newUser.toMap())
                .whenComplete(() => {uploadProfileImage(newUserImage)})
          }
      });
  sharedPreferences.setString("user_data", jsonEncode(userData));
}

addUserInContactList(BuildContext context, String uid) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  String userUID =
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

Future<Map<String, dynamic>> getUserProfile(String uid) async {
  Map<String, dynamic> profile = {};
  await userReference.doc(uid).get().then((snapshot) => {
        if (snapshot.exists)
          {
            profile = snapshot.data()!,
          }
      });
  return profile;
}

updateUserProfile(
    String name,
    String mobile,
    String profession,
    String organization,
    String street,
    String pincode,
    String country,
    String state,
    String city) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  String userUID =
      jsonDecode(sharedPreferences.getString("user_data").toString())['uid'];
  userReference
      .doc(userUID)
      .update({
        "name": name,
        "mobile": mobile,
        "profession": profession,
        "organization": organization,
        "street": street,
        "country": country,
        "state": state,
        "city": city,
        "pincode": pincode
      })
      .then((snapshot) => debugPrint("success"))
      .catchError((onError) => {debugPrint("error")});
}

uploadProfileImage(File image) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  String userUID =
      jsonDecode(sharedPreferences.getString("user_data").toString())['uid'];

  storage.ref().child('profiles/$userUID').putFile(image);
}

Future<String> getUserProfileImage(String userUID) async {
  return await storage.ref().child('profiles/$userUID').getDownloadURL();
}

Future<File> getImageFileFromAssets(String imageName) async {
  final byteData = await rootBundle.load('assets/images/$imageName');
  final file = File('${(await getTemporaryDirectory()).path}/$imageName');
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}
