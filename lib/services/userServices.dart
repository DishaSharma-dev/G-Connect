import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gconnect/shared/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../account/login.dart';
import '../home/home.dart';
import '../models/UserModel.dart';
import 'dart:async';

import 'package:flutter/services.dart' show rootBundle;
import '../shared/constants.dart';
import '../shared/snackbar_response.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final userReference = FirebaseFirestore.instance.collection("user");
final FirebaseStorage storage = FirebaseStorage.instance;

final List<Map<String, dynamic>> contactDataListOriginal = [];
final List<Map<String, dynamic>> contactDataList = [];

Future<void> authenticateUser(BuildContext context) async {
  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  UserCredential result =
      await FirebaseAuth.instance.signInWithCredential(credential);

  if (result.user != null) {
    await createUserIfNotExist(context);

    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('isUser', true);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const HomePage(currentPage: 0)));
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

addUserInContactList(String uid, bool isFavorite) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  String userUID =
      jsonDecode(sharedPreferences.getString("user_data").toString())['uid'];
  userReference.doc(uid).get().then((value) => {
        if (value.exists)
          {
            userReference
                .doc(userUID)
                .update({
                  "contacts": FieldValue.arrayUnion([
                    {"uid": uid, "isFavorite": isFavorite}
                  ])
                })
                .whenComplete(() => {})
                .catchError((e) => {})
          }
        else
          {}
      });
  updateFavoriteInSharedPreferences(uid, isFavorite, false);
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
    BuildContext context,
    String name,
    String mobile,
    String profession,
    String organisation,
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
        "organisation": organisation,
        "street": street,
        "country": country,
        "state": state,
        "city": city,
        "pincode": pincode
      })
      .then((snapshot) => showResponse(context, updateProfileSuccessMessage,
          const Color.fromARGB(253, 18, 177, 58)))
      .catchError((onError) => showResponse(context, updateProfileFailedMessage,
          const Color.fromARGB(252, 238, 36, 36)));
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

deleteContact(String uid, bool isFavorite) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  String userUID =
      jsonDecode(sharedPreferences.getString("user_data").toString())['uid'];

  await userReference.doc(userUID).update({
    "contacts": FieldValue.arrayRemove([
      {"uid": uid, "isFavorite": isFavorite}
    ])
  });
}

updateFavoriteInSharedPreferences(String uid, bool isFavorite, bool del) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Map<String, dynamic> userData = {};
  userData = jsonDecode(sharedPreferences.getString("user_data").toString());

  var contacts = [];
  contacts = userData['contacts'];

  if (del) {
    contacts.removeWhere((element) => element['uid'] == uid);
  } else {
    int index = contacts.indexWhere((element) => element['uid'] == uid);
    if (index != -1) {
      contacts[index]['isFavorite'] = isFavorite;
    } else {
      contacts.add({uid: uid, isFavorite: isFavorite});
    }
  }

  userData['contacts'] = contacts;

  sharedPreferences.setString("user_data", jsonEncode(userData));
}
