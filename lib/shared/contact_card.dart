import 'package:flutter/material.dart';
import 'package:gconnect/services/userServices.dart';

class ContactRow extends StatefulWidget {
  const ContactRow({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  State<ContactRow> createState() => _ContactRowState(uid);
}

class _ContactRowState extends State<ContactRow> {
  static const Color contactCard = Color.fromARGB(255, 178, 133, 255);
  static const Color contactPageBackground = Color.fromRGBO(179, 136, 255, 1);
  static const Color contactTitle = Color(0xFFFFFFFF);
  static const Color contactProfession = Color(0x66FFFFFF);
  static const Color contactPhone = Color(0x66FFFFFF);
  final String uid;
  _ContactRowState(this.uid);

  Map<String, dynamic> userData = {};
  String userImage = "";

  @override
  void initState() {
    super.initState();
    setProfileData(uid);
  }

  @override
  Widget build(BuildContext context) {
    final planetThumbnail = Container(
      margin: const EdgeInsets.only(left: 18.0, top: 24),
      width: 80.0,
      height: 80.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
            userImage,
            fit: BoxFit.fill,
          )),
    );

    final planetCard = Container(
      margin: const EdgeInsets.only(left: 50.0, right: 18.0),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent.shade200,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const <BoxShadow>[
          BoxShadow(
              color: Color.fromARGB(255, 179, 136, 255),
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0))
        ],
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 16.0, left: 60.0),
        constraints: const BoxConstraints.expand(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Flexible(
                  flex: 1,
                  child: Text(userData['name'],
                      style: const TextStyle(
                          color: contactTitle,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0)),
                )),
             Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Flexible(
                flex: 1,
                child: Text(userData['profession'],
                    style: const TextStyle(
                        color: contactProfession,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                        fontSize: 14.0)),
              ),
            ),
            Container(
                color: const Color.fromARGB(255, 134, 247, 255),
                width: 30.0,
                height: 1.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0)),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: RichText(
                          text: TextSpan(children: [
                        const WidgetSpan(
                          child: Icon(Icons.phone_outlined, size: 20,),
                        ),
                        TextSpan(
                            text: userData['mobile'],
                            style: const TextStyle(
                                color: contactPhone,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300,
                                fontSize: 12.0))
                      ])),
                    ),
                    Flexible(
                      flex: 1,
                      child: RichText(
                          text: TextSpan(children: [
                        const WidgetSpan(
                          style: TextStyle(),
                          child: Icon(Icons.location_on_outlined, size: 20,),
                        ),
                        TextSpan(
                            text: userData['city'] + ", " + userData['country'],
                            style: const TextStyle(
                                color: contactPhone,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300,
                                fontSize: 12.0))
                      ])),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );

    return Container(
      height: 120.0,
      margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: FlatButton(
        onPressed: () => {print("hello")},
        child: Stack(
          children: <Widget>[
            planetCard,
            planetThumbnail,
          ],
        ),
      ),
    );
  }

  setProfileData(String uid) async {
    Map<String, dynamic> data = await getUserProfile(uid);
    String img = await getUserProfileImage(uid);
    setState(() {
      userData = data;
      userImage = img;
    });
  }
}
