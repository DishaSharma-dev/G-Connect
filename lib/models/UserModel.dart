class UserModel {
  String? uid = "";
  String? name = "";
  String? email = "";
  String? image = "";
  String? mobile = "";
  String? location = "";
  String? profession = "";
  String? organisation = "";
  String? description = "";
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
      'contacts': contacts
    };
  }
}
