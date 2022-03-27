import 'dart:convert';
import 'package:gconnect/screens/home/home_page.dart';
import 'package:gconnect/screens/home/pages/user_details.dart';
import 'package:gconnect/services/user_services.dart';
import 'package:gconnect/shared/custom_dialog.dart';
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

  double latitude = 0.0, longitude = 0.0;

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
    return ListView(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 15, left: 25, right: 25, bottom: 15),
          child: TextFormField(
              controller: searchController,
              onChanged: (value) => {searchContact(value)},
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                floatingLabelStyle:
                    TextStyle(color: Theme.of(context).colorScheme.primary),
                labelText: "Search",
                labelStyle:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                suffixIcon: Icon(
                  Icons.search_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                isDense: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(100))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1)),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: FutureBuilder(
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
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.65,
                    child: Center(
                      child: Text("You don't have any favorite contact",
                          style: Theme.of(context).textTheme.headline6),
                    ),
                  );
                } else {
                  return ListView.separated(
                    controller: scrollController,
                    itemCount: list.length,
                    shrinkWrap: true,
                    itemBuilder: (_, index) => ExpansionTile(
                      backgroundColor:
                          Theme.of(context).colorScheme.onBackground,
                      collapsedBackgroundColor:
                          Theme.of(context).colorScheme.onBackground,
                      iconColor: Theme.of(context).iconTheme.color,
                      collapsedIconColor: Theme.of(context).iconTheme.color,
                      title: Text(
                        list[index]['name'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      subtitle: Text(
                        list[index]['profession'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.white),
                      ),
                      leading: list[index]['user_image'] == ""
                          ? Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset(
                                  "assets/images/avatar.png",
                                  fit: BoxFit.fill,
                                ),
                              ))
                          : Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  list[index]['user_image'],
                                  fit: BoxFit.fill,
                                ),
                              )),
                      children: [
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                list[index]['mobile'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                list[index]['email'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: Theme.of(context).textTheme.bodyMedium,
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
                                style: Theme.of(context).textTheme.bodySmall,
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
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

                                  UserService()
                                      .addContact(list[index]['uid'],
                                          list[index]['isFavorite'])
                                      .then((value) => {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                    buildContext) {
                                                  return CustomDialogBox(
                                                    title: 'Success',
                                                    descriptions: list[index]
                                                            ['isFavorite']
                                                        ? "Contact added to favorite list successfully"
                                                        : "Contact removed from favorite list successfully",
                                                    text: 'OK',
                                                    imagePath:
                                                        'assets/images/correct.png',
                                                  );
                                                })
                                          })
                                      .onError((error, stackTrace) => {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                    buildContext) {
                                                  return CustomDialogBox(
                                                    title: 'Failed',
                                                    descriptions:
                                                        error.toString(),
                                                    text: 'OK',
                                                    imagePath:
                                                        'assets/images/wrong.png',
                                                  );
                                                })
                                          });
                                  ;
                                },
                                icon: Icon(list[index]['isFavorite']
                                    ? Icons.favorite
                                    : Icons.favorite_outline_rounded),
                                color: Colors.red),
                            IconButton(
                                onPressed: () {
                                  UserService()
                                      .deleteContact(list[index]['uid'],
                                          list[index]['isFavorite'])
                                      .then((value) => {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                    buildContext) {
                                                  return const CustomDialogBox(
                                                    title: 'Success',
                                                    descriptions:
                                                        "Contact deleted successfully",
                                                    text: 'OK',
                                                    imagePath:
                                                        'assets/images/correct.png',
                                                  );
                                                })
                                          })
                                      .onError((error, stackTrace) => {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                    buildContext) {
                                                  return CustomDialogBox(
                                                    title: 'Failed',
                                                    descriptions:
                                                        error.toString(),
                                                    text: 'OK',
                                                    imagePath:
                                                        'assets/images/wrong.png',
                                                  );
                                                })
                                          }); // deleted from server

                                  UserService().updateContactInSharedPreferences(
                                      list[index]['uid'],
                                      list[index]['isFavorite'],
                                      true); // deleted from sharedPreferences
                                  if (mounted) {
                                    setState(() {
                                      list.removeWhere((element) =>
                                          element['uid'] == list[index]['uid']);
                                    });
                                  }
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                            IconButton(
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
                                                                  currentPage:
                                                                      0)),
                                                      (r) => false);
                                                },
                                              )));
                                },
                                icon: Icon(
                                  Icons.arrow_circle_right_outlined,
                                  color: Theme.of(context).iconTheme.color,
                                )),
                          ],
                        )
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
              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.5,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
            future: contactListFuture,
          ),
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
