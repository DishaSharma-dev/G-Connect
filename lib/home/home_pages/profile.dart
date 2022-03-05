import 'dart:convert';
import 'dart:io';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';
import 'package:gconnect/services/userServices.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  String profileImage = "";

  @override
  void initState() {
    super.initState();
    getProfileImage();
    getProfile();
  }

  final picker = ImagePicker();
  File? _imageFile;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: ListView(
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
                                  child: _imageFile != null
                                      ? Image.file(
                                          _imageFile!,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.network(
                                          profileImage,
                                          fit: BoxFit.fill,
                                        )),
                            ),
                          ],
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.only(top: 90.0, right: 100.0),
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
              Container(
                color: const Color(0xffFFFFFF),
                child: Padding(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    _getEditIcon(),
                                  ],
                                )
                              ],
                            )),
                        formField("Full Name", Icons.person_outline_outlined,
                            _status, nameController, TextInputType.name),
                        formField("Email Address", Icons.mail_outline_outlined,
                            false, emailController, TextInputType.emailAddress),
                        formField("Mobile Number", Icons.phone_outlined,
                            _status, mobileController, TextInputType.phone),
                        formField("Profession", Icons.maps_home_work_outlined,
                            _status, professionController, TextInputType.text),
                        formField(
                            "Organisation",
                            Icons.apartment_outlined,
                            _status,
                            organisationController,
                            TextInputType.text),
                        formField("Street", Icons.add_road_outlined, _status,
                            streetController, TextInputType.streetAddress),
                        cscPicker(),
                        formField("PIN Code", Icons.code, _status,
                            pincodeController, TextInputType.number),
                        _status ? _getActionButtons() : Container(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget formField(String label, IconData icon, bool isEnabled,
      TextEditingController controller, TextInputType inputType) {
    return Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 10),
        child: Flexible(
          flex: 1,
          child: TextFormField(
            enabled: isEnabled,
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: inputType,
            style: TextStyle(
              color: isEnabled ? Colors.black : Colors.grey
            ),
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
          ),
        ));
  }

  Widget cscPicker() {
    return Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
        child: Flexible(
          flex: 1,
          child: AbsorbPointer(
            absorbing: !_status,
            child: CountryStateCityPicker(
              country: countryController,
              state: stateController,
              city: cityController,
              textFieldInputBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 179, 136, 255), width: 1)),
            ),
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
                    updateUserProfile(
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
                  if (_imageFile != null) {
                    uploadProfileImage(_imageFile!);
                  }
                  setState(() {
                    _status = !_status;
                  });
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
                  setState(() {
                    _status = false;
                  });
                },
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
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
        setState(() {
          _status = !_status;
        });
      },
    );
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  getProfileImage() async {
    String img = await getUserProfileImage();
    setState(() {
      profileImage = img;
    });
  }

  getProfile() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String userUID =
        jsonDecode(sharedPreferences.getString("user_data").toString())['uid'];
    Map<String, dynamic> profile = await getUserProfile(userUID);
    if (profile.isNotEmpty) {
      setState(() {
        nameController.text = profile['name'];
        emailController.text = profile['email'];
        mobileController.text = profile['mobile'];
        professionController.text = profile['profession'];
        organisationController.text = profile['organization'];
        streetController.text = profile['street'];
        countryController.text = profile['country'];
        stateController.text = profile['state'];
        cityController.text = profile['city'];
        pincodeController.text = profile['pincode'];
      });
    }
  }
}
