class UserModel {
  String uid = "";
  String name = "";
  String email = "";
  String mobile = "";
  String profession = "";
  String organisation = "";
  String description = "";
  String street = "";
  String country = "";
  String state = "";
  String city = "";
  String pincode = "";
  List<String> contacts ;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'mobile': mobile,
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

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.mobile,
      required this.profession,
      required this.organisation,
      required this.description,
      required  this.pincode,
      required  this.street,
      required  this.country,
      required  this.state,
      required  this.city,
      required  this.contacts});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],
        profession: json["profession"],
        organisation: json["organisation"],
        description: json["description"],
        pincode: json["pincode"],
        street: json["street"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        contacts: json["contacts"],
      );
}
