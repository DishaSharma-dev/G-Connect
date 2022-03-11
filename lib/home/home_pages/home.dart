import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gconnect/services/userServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/contact_card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> contactDataListOriginal = [];
  List<Map<String, dynamic>> contactDataList = [];
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    setContactList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 30, left: 25, right: 25, bottom: 5),
            child: TextFormField(
                controller: searchController,
                onChanged: (value) => {searchContact(value)},
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  floatingLabelStyle:
                      TextStyle(color: Color.fromARGB(255, 179, 136, 255)),
                  labelText: "Search",
                  suffixIcon: Icon(
                    Icons.search_outlined,
                    color: Color.fromARGB(255, 179, 136, 255),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.deepPurpleAccent, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 179, 136, 255), width: 1)),
                )),
          ),
          ListView.builder(
            itemExtent: 160.0,
            shrinkWrap: true,
            itemCount: contactDataList.length,
            itemBuilder: (_, index) => ContactRow(
                onContactdeleted: (String uid) {
                  setState(() {
                    contactDataList
                        .removeWhere((element) => element['uid'] == uid);
                  });
                },
                data: contactDataList[index]),
          ),
        ],
      ),
    );
  }

  setContactList() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    var contacts = [];
    contacts = jsonDecode(
        sharedPreferences.getString("user_data").toString())['contacts'];

    contacts.forEach((element) async {
      Map<String, dynamic> data = await getUserProfile(element['uid']);
      data['userImage'] = await getUserProfileImage(data['uid']);
      data['isFavorite'] = element['isFavorite'];
      setState(() {
        contactDataList.add(data);
        contactDataListOriginal.add(data);
        contactDataList.sort();
      });
    });
  }

  searchContact(String value) {
    setState(() {
      contactDataList = contactDataListOriginal
          .where((element) =>
              element['name'].toString().toLowerCase().contains(value))
          .toList();
    });
  }
}
