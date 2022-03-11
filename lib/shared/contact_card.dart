import 'package:flutter/material.dart';
import 'package:gconnect/home/home_pages/home.dart';
import 'package:gconnect/services/userServices.dart';
import 'package:gconnect/shared/user_details.dart';


class ContactRow extends StatelessWidget {
  final DataCallback onContactdeleted;
  final Map<String, dynamic> data;
  const ContactRow({Key? key,required this.onContactdeleted,required this.data}) : super(key: key);

  static const Color contactCard = Color.fromARGB(255, 178, 133, 255);
  static const Color contactPageBackground = Color.fromRGBO(179, 136, 255, 1);
  static const Color contactTitle = Color(0xFFFFFFFF);
  static const Color contactProfession = Color(0x66FFFFFF);
  static const Color contactPhone = Color(0x66FFFFFF);

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
            data['userImage'],
            fit: BoxFit.fill,
          )),
    );

    final contactCardMenu = Container(
        alignment: Alignment.topRight,
        margin: const EdgeInsets.only(right: 18),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  deleteContact(data['uid'], data['isFavorite']);
                  // setState(() {
                  //   data['isFavorite'] = !data['isFavorite'];
                  // });
                  addUserInContactList(data['uid'], data['isFavorite']);

                  updateFavoriteInSharedPreferences(
                      data['uid'], data['isFavorite'], false);
                },
                icon: Icon(
                  data['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                  color: data['isFavorite'] ? Colors.red : Colors.black,
                )),
            IconButton(
                onPressed: () {
                  deleteContact(data['uid'], data['isFavorite']); // deleted from server
                  updateFavoriteInSharedPreferences(
                      data['uid'], data['isFavorite'], true); // deleted from sharedPreferences
                  onContactdeleted(data['uid']);
                },

                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
          ],
        ));

    final planetCard = Container(
      margin: const EdgeInsets.only(left: 55.0, right: 18.0),
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
        margin: const EdgeInsets.only(top: 16.0, left: 60.0, right: 15),
        constraints: const BoxConstraints.expand(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Flexible(
                  flex: 1,
                  child: Text(data['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
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
                child: Text(data['profession'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          text: TextSpan(children: [
                            const WidgetSpan(
                              child: Icon(
                                Icons.phone_outlined,
                                size: 20,
                              ),
                            ),
                            TextSpan(
                                text: data['mobile'],
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          text: TextSpan(children: [
                            const WidgetSpan(
                              style: TextStyle(),
                              child: Icon(
                                Icons.location_on_outlined,
                                size: 20,
                              ),
                            ),
                            TextSpan(
                                text: data['city'] + ", " + data['country'],
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
        onPressed: () => {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => UserDetail(userData: data)))
        },
        child: Stack(
          children: <Widget>[
            planetCard,
            contactCardMenu,
            planetThumbnail,
          ],
        ),
      ),
    );
  }
}

typedef DataCallback = void Function(String uid);

// class ContactRow extends StatefulWidget {
//   const ContactRow({Key? key, required this.data}) : super(key: key);
//   final Map<String, dynamic> data;

//   @override
//   State<ContactRow> createState() => _ContactRowState(data);
// }

// class _ContactRowState extends State<ContactRow> {
//   static const Color contactCard = Color.fromARGB(255, 178, 133, 255);
//   static const Color contactPageBackground = Color.fromRGBO(179, 136, 255, 1);
//   static const Color contactTitle = Color(0xFFFFFFFF);
//   static const Color contactProfession = Color(0x66FFFFFF);
//   static const Color contactPhone = Color(0x66FFFFFF);
//   final Map<String, dynamic> data;
//   _ContactRowState(this.data);

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
    
//   }
// }
