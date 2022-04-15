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
  List<Map<String, dynamic>> contacts = [];

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.mobile,
      required this.profession,
      required this.organisation,
      required this.description,
      required this.street,
      required this.country,
      required this.state,
      required this.city,
      required this.pincode,
      required this.contacts});

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    profession = json['profession'];
    organisation = json['organisation'];
    description = json['description'];
    street = json['street'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    pincode = json['pincode'];
    contacts = json['contacts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['profession'] = profession;
    data['organisation'] = organisation;
    data['description'] = description;
    data['street'] = street;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['pincode'] = pincode;
    data['contacts'] = contacts;
    return data;
  }
}
