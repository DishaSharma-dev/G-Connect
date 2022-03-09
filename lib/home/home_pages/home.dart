import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/contact_card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var contactsUID = [];

  @override
  void initState() {
    super.initState();
    setContactList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemExtent: 160.0,
        itemCount: contactsUID.length,
        itemBuilder: (_, index) => ContactRow(uid: contactsUID[index]['uid'], isFavorite: contactsUID[index]['isFavorite']),
      ),
    );
  }

  setContactList() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    var contacts = jsonDecode(
        sharedPreferences.getString("user_data").toString())['contacts'];
    setState(() {
      contactsUID = contacts;
    });

    
  }
}
