import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gconnect/services/userServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:osm_nominatim/osm_nominatim.dart';
import '../../shared/contact_card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> contactDataListOriginal = [];
  List<Map<String, dynamic>> contactDataList = [];
  var latitude = 0.0, longitude = 0.0;
  int starting = 0, ending = 10;
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 30, left: 25, right: 25, bottom: 5),
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
                        borderSide: BorderSide(
                            color: Colors.deepPurpleAccent, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 179, 136, 255),
                            width: 1)),
                  )),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.7,
              child: contactDataList.isNotEmpty
                  ? ListView.builder(
                      itemExtent: 170.0,
                      shrinkWrap: true,
                      itemCount: contactDataList.length,
                      itemBuilder: (_, index) => ContactRow(
                        onContactdeleted: (String uid) {
                          if (mounted) {
                            setState(() {
                              contactDataList.removeWhere(
                                  (element) => element['uid'] == uid);
                            });
                          }
                        },
                        data: contactDataList[index],
                        page: 0,
                        toggleFavorite: () {
                          if (mounted) {
                            setState(() {
                              contactDataList[index]['isFavorite'] =
                                  !contactDataList[index]['isFavorite'];
                            });
                          }
                        },
                      ),
                    )
                  : const Center(
                      child: Text("You don't have any contacts"),
                    ),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      if (starting != 0) {
                        if (mounted) {
                          setState(() {
                            starting -= 10;
                            ending -= 10;
                          });
                        }
                        updateContactList();
                      }
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: starting != 0
                          ? Colors.deepPurpleAccent
                          : Colors.grey[300],
                    )),
                IconButton(
                    onPressed: () {
                      if (contactDataList.length > ending) {
                        if (mounted) {
                          setState(() {
                            starting += 10;
                            ending += 10;
                          });
                        }
                        updateContactList();
                      }
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: starting != 0
                          ? Colors.deepPurpleAccent
                          : Colors.grey[300],
                    )),
              ],
            )
          ],
        ),
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
      await getLatLong(data['city']);

      data['latitude'] = latitude;
      data['longitude'] = longitude;
      if (mounted) {
        setState(() {
          //contactDataList.add(data);
          contactDataListOriginal.add(data);
          updateContactList();
        });
      }
    });
  }

  updateContactList() {
    contactDataList.clear();
    for (int i = starting;
        i < ending && i < contactDataListOriginal.length;
        ++i) {
      if (mounted) {
        setState(() {
          contactDataList.add(contactDataListOriginal[i]);
        });
      }
    }
  }

  searchContact(String value) {
    if (mounted) {
      setState(() {
        contactDataList = contactDataListOriginal
            .where((element) =>
                element['name'].toString().toLowerCase().contains(value))
            .toList();
      });
    }
  }

  getLatLong(String address) async {
    final searchResult = await Nominatim.searchByName(
      query: address,
      limit: 1,
      addressDetails: true,
      extraTags: true,
      nameDetails: true,
    );
    if (mounted) {
      setState(() {
        latitude = searchResult[0].lat;
        longitude = searchResult[0].lon;
      });
    }
  }
}
