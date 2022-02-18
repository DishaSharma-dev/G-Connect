import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gconnect/account/login.dart';
import 'package:gconnect/home/home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final userReference = FirebaseFirestore.instance.collection("user");


Future<void> signup(BuildContext context) async {
  //final GoogleSignIn googleSignIn = GoogleSignIn();
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
  
  if(result.user != null) 
  {
    await saveDataToFirestore(context);
     final pref = await SharedPreferences.getInstance();
     pref.setBool('isUser', true);
     Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }else{
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignInScreen()));
  }
}

saveDataToFirestore(BuildContext context) async{
  final GoogleSignInAccount? gCurrentUser = GoogleSignIn().currentUser;
  DocumentSnapshot documentSnapshot = await userReference.doc(gCurrentUser?.id).get();
  if(!documentSnapshot.exists){
   userReference.add({'id' : auth.currentUser?.uid, 
   'name' : auth.currentUser?.displayName,
   'email' : auth.currentUser?.email, 
   'profilePhoto' : auth.currentUser?.photoURL,
   'mobile' : auth.currentUser?.phoneNumber});
  }
}
