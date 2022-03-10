import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gconnect/services/userServices.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/contact_card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>>? contactDataList;

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
        itemCount: contactDataList?.length,
        itemBuilder: (_, index) => ContactRow(data: contactDataList![index]),
      ),
    );
  }

  setContactList() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    var contacts = [];
    contacts = jsonDecode(
        sharedPreferences.getString("user_data").toString())['contacts'];

    List<Map<String, dynamic>>? contactList;

    contacts.forEach((element) async {
      Map<String, dynamic> data = await getUserProfile(element['uid']);
      data['userImage'] = await getUserProfileImage(data['uid']);
      data['isFavorite'] = element['isFavorite'];
      contactList?.add(data);
    });
    setState(() {
      contactDataList = contactList;
    });
  }
}
