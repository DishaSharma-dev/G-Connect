import 'dart:convert';
import 'dart:io';

import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';
import 'package:gconnect/services/user_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final picker = ImagePicker();
  Map<String, dynamic> data = {"_status": false};
  File? imageFile;
  late Future getProfileFuture;

  @override
  void initState() {
    super.initState();
    //getProfileFuture = getProfile();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController organisationController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasData) {
          return const Center(
            child: Text("User not present"),
          );
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          data.addAll(snapshot.data as Map<String, dynamic>);
          nameController.text = data['name'];
          emailController.text = data['email'];
          mobileController.text = data['mobile'];
          professionController.text = data['profession'];
          organisationController.text = data['organisation'];
          streetController.text = data['street'];
          countryController.text = data['country'];
          stateController.text = data['state'];
          cityController.text = data['city'];
          pincodeController.text = data['pincode'];
          return Scaffold(
              body: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Stack(fit: StackFit.loose, children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 140.0,
                                height: 140.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: imageFile != null
                                      ? Image.file(imageFile!)
                                      : renderImage(data['user_image'] ?? ""),
                                ),
                              )
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 90.0, right: 100.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Theme.of(context)
                                        .appBarTheme
                                        .backgroundColor,
                                    radius: 25.0,
                                    child: IconButton(
                                      icon: const Icon(Icons.camera_alt),
                                      color: Theme.of(context).iconTheme.color,
                                      onPressed: () {
                                        pickImage();
                                      },
                                    ),
                                  )
                                ],
                              )),
                        ]),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0, top: 15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0,
                                  right: 25.0,
                                  top: 25.0,
                                  bottom: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Parsonal Information',
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  getEditIcon(),
                                ],
                              )),
                          formField(
                              "Full Name",
                              Icons.person_outline_outlined,
                              data['_status'],
                              nameController,
                              TextInputType.name),
                          formField(
                              "Email Address",
                              Icons.mail_outline_rounded,
                              false,
                              emailController,
                              TextInputType.emailAddress),
                          formField(
                              "Mobile Number",
                              Icons.phone_outlined,
                              data['_status'],
                              mobileController,
                              TextInputType.phone),
                          formField(
                              "Profession",
                              Icons.maps_home_work_outlined,
                              data['_status'],
                              professionController,
                              TextInputType.text),
                          formField(
                              "Organisation",
                              Icons.apartment_outlined,
                              data['_status'],
                              organisationController,
                              TextInputType.text),
                          formField(
                              "Street",
                              Icons.add_road_outlined,
                              data['_status'],
                              streetController,
                              TextInputType.streetAddress),
                          cscPicker(),
                          formField("PIN Code", Icons.code, data['_status'],
                              pincodeController, TextInputType.number),
                          data['_status'] ? _getActionButtons() : Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ));
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: getProfile(),
    );
  }

  renderImage(String image) {
    if (image == "") {
      return Image.asset(
        "assets/images/avatar.png",
        fit: BoxFit.fill,
      );
    }
    return Image.network(
      image,
      fit: BoxFit.fill,
    );
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (mounted) {
      setState(() {
        imageFile = File(pickedFile!.path);
      });
    }
  }

  Widget getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          size: 16.0,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
      onTap: () {
        if (mounted) {
          setState(() {
            data['_status'] = !data['_status'];
          });
        }
      },
    );
  }

  Widget formField(String label, IconData icon, bool isEnabled,
      TextEditingController controller, TextInputType inputType) {
    return Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 10),
        child: TextFormField(
          enabled: isEnabled,
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: inputType,
          style: TextStyle(
              color: isEnabled
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary),
          keyboardAppearance: Brightness.light,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              floatingLabelStyle: TextStyle(
                  color: isEnabled
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary),
              labelText: label,
              labelStyle:
                  TextStyle(color: Theme.of(context).colorScheme.primary),
              isDense: true,
              suffixIcon: Icon(icon,
                  color: isEnabled
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 2)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 1)),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error, width: 1))),
        ));
  }

  Widget cscPicker() {
    return Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
        child: AbsorbPointer(
          absorbing: !data['_status'],
          child: CountryStateCityPicker(
            country: countryController,
            state: stateController,
            city: cityController,
            textFieldInputBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: !data['_status']
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
                    width: 1)),
          ),
        ));
  }

  Widget _getActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: ElevatedButton(
                child: const Text("Save"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).buttonColor),
                ),
                onPressed: () async {
                  final bool isValid = _formKey.currentState!.validate();
                  if (isValid) {
                    await UserService().updateUserProfile(
                      context,
                      nameController.text,
                      mobileController.text,
                      professionController.text,
                      organisationController.text,
                      streetController.text,
                      pincodeController.text,
                      countryController.text,
                      stateController.text,
                      cityController.text,
                    );
                    await updateProfileInSharedPrefrences(
                        nameController.text,
                        mobileController.text,
                        professionController.text,
                        organisationController.text,
                        streetController.text,
                        pincodeController.text,
                        countryController.text,
                        stateController.text,
                        cityController.text);
                  }
                  if (imageFile != null) {
                    await UserService().uploadProfileImage(imageFile!);
                  }
                },
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ElevatedButton(
                child: const Text("Cancel"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.redAccent.shade200),
                ),
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      data['_status'] = false;
                    });
                  }
                },
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> getProfile() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String userUID =
        jsonDecode(sharedPreferences.getString("user_data").toString())['uid'];
    Map<String, dynamic> profile = await UserService().getUserProfile(userUID);

    return profile;
  }

  updateProfileInSharedPrefrences(
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
    Map<String, dynamic> profile =
        jsonDecode(sharedPreferences.getString("user_data").toString());
    profile['name'] = name;
    profile['mobile'] = mobile;
    profile['profession'] = profession;
    profile['organisation'] = organisation;
    profile['street'] = street;
    profile['pincode'] = pincode;
    profile['country'] = country;
    profile['city'] = city;
    profile['state'] = state;

    await sharedPreferences.setString("user_data", jsonEncode(profile));
    setState(() {
      data['_status'] = false;
    });
  }
}
