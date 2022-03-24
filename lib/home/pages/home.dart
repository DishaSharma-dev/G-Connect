import 'dart:convert';
import 'package:gconnect/home/home_page.dart';
import 'package:gconnect/home/pages/user_details.dart';
import 'package:gconnect/services/user_services.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController scrollController = ScrollController();
  var latitude = 0.0, longitude = 0.0;
  int initialIndex = 0;
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> list = [];
  List<Map<String, dynamic>> originalContactList = [];
  late Future contactListFuture;
  @override
  void initState() {
    super.initState();
    contactListFuture = setContactList();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        initialIndex += 10;
        contactListFuture = setContactList();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasError) {
              return Center(
                child: Text(jsonEncode(snapshot.error)),
              );
            }

            if (snapshot.connectionState == ConnectionState.done &&
                !snapshot.hasError) {
              if (list.isEmpty) {
                return const Center(
                  child: Text("You don't have any contact"),
                );
              } else {
                return ListView.separated(
                  controller: scrollController,
                  itemCount: list.length,
                  shrinkWrap: true,
                  itemBuilder: (_, index) => ExpansionTile(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            list[index]['name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: const TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      UserService().deleteContact(
                                          list[index]['uid'],
                                          list[index]['isFavorite']);
                                      if (mounted) {
                                        setState(() {
                                          list[index]['isFavorite'] =
                                              !list[index]['isFavorite'];
                                        });
                                      }

                                      UserService().addContact(
                                          list[index]['uid'],
                                          list[index]['isFavorite']);

                                      UserService()
                                          .updateContactInSharedPreferences(
                                              list[index]['uid'],
                                              list[index]['isFavorite'],
                                              false);
                                    },
                                    icon: Icon(list[index]['isFavorite']
                                        ? Icons.favorite
                                        : Icons.favorite_outline_rounded),
                                    color: Colors.red),
                                IconButton(
                                    onPressed: () {
                                      UserService().deleteContact(
                                          list[index]['uid'],
                                          list[index][
                                              'isFavorite']); // deleted from server
                                      UserService()
                                          .updateContactInSharedPreferences(
                                              list[index]['uid'],
                                              list[index]['isFavorite'],
                                              true); // deleted from sharedPreferences
                                      if (mounted) {
                                        setState(() {
                                          list.removeWhere((element) =>
                                              element['uid'] ==
                                              list[index]['uid']);
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.delete)),
                              ])
                        ]),
                    leading: list[index]['user_image'] == ""
                        ? Image.asset(
                            "assets/images/avatar.png",
                            fit: BoxFit.fill,
                          )
                        : Image.network(
                            list[index]['user_image'],
                            fit: BoxFit.fill,
                          ),
                    children: [
                      ListTile(
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserDetail(
                                            userData: list[index],
                                            backCallback: () {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const HomePage(
                                                              currentPage: 0)),
                                                  (r) => false);
                                            },
                                          )));
                            },
                            icon:
                                const Icon(Icons.arrow_circle_right_outlined)),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              list[index]['mobile'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                            Text(
                              list[index]['email'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              list[index]['organisation'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                            Text(
                              list[index]['city'] +
                                  ", " +
                                  list[index]['state'] +
                                  ", " +
                                  list[index]['country'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      height: 1,
                    );
                  },
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          future: contactListFuture,
        ),
      ],
    );
  }

  Future setContactList() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    var contacts = [];
    contacts = jsonDecode(
        sharedPreferences.getString("user_data").toString())['contacts'];

    for (int i = initialIndex;
        i < (initialIndex + 10) && i < contacts.length;
        ++i) {
      Map<String, dynamic> data =
          await UserService().getUserProfile(contacts[i]['uid']);
      data['user_image'] = await UserService().getUserProfileImage(data['uid']);
      data['isFavorite'] = contacts[i]['isFavorite'];
      await getLatLong(data['city']);

      data['latitude'] = latitude;
      data['longitude'] = longitude;
      list.add(data);
      originalContactList.add(data);
    }
  }

  searchContact(String value) {
    if (mounted) {
      setState(() {
        list = originalContactList
            .where((element) =>
                element['name'].toString().toLowerCase().contains(value))
            .toList();
      });
    }
  }

  getLatLong(String address) async {
    if (address != "") {
      final searchResult = await Nominatim.searchByName(
        query: address,
        limit: 1,
        addressDetails: true,
        extraTags: true,
        nameDetails: true,
      );

      latitude = searchResult[0].lat;
      longitude = searchResult[0].lon;
    }
  }
}
