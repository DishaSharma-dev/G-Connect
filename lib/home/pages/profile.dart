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
                  Container(
                    color: Colors.white,
                    child: Column(
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
                                      backgroundColor: Colors.deepPurpleAccent,
                                      radius: 25.0,
                                      child: IconButton(
                                        icon: const Icon(Icons.camera_alt),
                                        color: Colors.white,
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
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const <Widget>[
                                      Text(
                                        'Parsonal Information',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      getEditIcon(),
                                    ],
                                  )
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
                              Icons.mail_outline_outlined,
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
      child: const CircleAvatar(
        backgroundColor: Colors.deepPurpleAccent,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
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
          style: TextStyle(color: isEnabled ? Colors.black : Colors.grey),
          keyboardAppearance: Brightness.light,
          cursorColor: const Color.fromARGB(255, 179, 136, 255),
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              floatingLabelStyle:
                  const TextStyle(color: Color.fromARGB(255, 179, 136, 255)),
              labelText: label,
              isDense: true,
              suffixIcon: Icon(icon,
                  color: isEnabled
                      ? const Color.fromARGB(255, 179, 136, 255)
                      : Colors.grey),
              focusedBorder: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.deepPurpleAccent, width: 1)),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 179, 136, 255), width: 1)),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1))),
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
            textFieldInputBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromARGB(255, 179, 136, 255), width: 1)),
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
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
                ),
                onPressed: () {
                  final bool isValid = _formKey.currentState!.validate();
                  if (isValid) {
                    UserService().updateUserProfile(
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
                  }
                  if (imageFile != null) {
                    UserService().uploadProfileImage(imageFile!);
                  }
                  if (mounted) {
                    setState(() {
                      data['_status'] = !data['_status'];
                    });
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
}
