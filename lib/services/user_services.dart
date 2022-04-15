import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gconnect/shared/custom_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final userReference = FirebaseFirestore.instance.collection("user");
  final FirebaseStorage storage = FirebaseStorage.instance;

  // For adding user in contact list
  Future addContact(String uid, bool isFavorite) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String userUID =
        jsonDecode(sharedPreferences.getString("user_data").toString())['uid'];
    await userReference.doc(uid).get().then((value) async => {
          if (value.exists)
            {
              await userReference.doc(userUID).update({
                "contacts": FieldValue.arrayUnion([
                  {"uid": uid, "isFavorite": isFavorite}
                ])
              }).then((value) => {})
            }
        });
    updateContactInSharedPreferences(uid, isFavorite, false);
  }

  // For updating contact in shared prefrences
  updateContactInSharedPreferences(
      String uid, bool isFavorite, bool del) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> userData =
        jsonDecode(sharedPreferences.getString("user_data").toString());

    if (del) {
      userData['contacts'].removeWhere((element) => element['uid'] == uid);
    } else {
      int index =
          userData['contacts'].indexWhere((element) => element['uid'] == uid);
      if (index != -1) {
        userData['contacts'][index]['isFavorite'] = isFavorite;
      } else {
        Map<String, dynamic> newContact = {
          "uid" : uid,
          "isFavorite" : isFavorite
        };
        userData['contacts'].add(newContact);
      }
    }
    print(userData);
    print(userData.toString());
    sharedPreferences.setString("user_data", jsonEncode(userData));
  }

  //For updating user profile
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
    await userReference
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
        .then((value) => {
              showDialog(
                  context: context,
                  builder: (BuildContext buildContext) {
                    return const CustomDialogBox(
                      title: 'Success',
                      descriptions: "Profile updated successfully",
                      text: 'OK',
                      imagePath: 'assets/images/correct.png',
                      currentPage: "-1",
                    );
                  })
            })
        .onError((error, stackTrace) => {
              showDialog(
                  context: context,
                  builder: (BuildContext buildContext) {
                    return CustomDialogBox(
                      title: 'Failed',
                      descriptions: error.toString(),
                      text: 'OK',
                      imagePath: 'assets/images/wrong.png',
                      currentPage: "-1"
                    );
                  })
            });
  }

  //For updating user image
  uploadProfileImage(File image) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String userUID =
        jsonDecode(sharedPreferences.getString("user_data").toString())['uid'];

    await storage.ref().child('profiles/$userUID').putFile(image);
  }

  //For getting user frofile image
  Future<String> getUserProfileImage(String userUID) async {
    String image = "";
    await storage
        .ref()
        .child('profiles/$userUID')
        .getDownloadURL()
        .then((value) => image = value)
        .onError((error, stackTrace) => image = "");
    return image;
  }

  //For getting user profile
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

  //For deleting user
  Future deleteContact(String uid, bool isFavorite) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    var userUID =
        jsonDecode(sharedPreferences.getString("user_data").toString())['uid'];
    print(userUID);
    await userReference
        .doc(userUID)
        .update({
          "contacts": FieldValue.arrayRemove([
            {"uid": uid, "isFavorite": isFavorite}
          ])
        });
  }
}
