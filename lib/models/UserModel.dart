class UserModel {
  String uid = "";
  String name = "";
  String email = "";
  String image = "";
  String mobile = "";
  String location = "";
  String profession = "";
  String organisation = "";
  String description = "";
  String street = "";
  String country = "";
  String state = "";
  String city = "";
  String pincode = "";
  List<dynamic> contacts = [];

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'image': image,
      'mobile': mobile,
      'location': location,
      'profession': profession,
      'organisation': organisation,
      'description': description,
      'pincode': pincode,
      'street': street,
      'country': country,
      'state': state,
      'city': city,
      'contacts': contacts
    };
  }
}
