import 'dart:io';

class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? contactNumber;
  String? imageUrl;
  String? deviceToken;
  String? authToken;
  int? userType; // 1 = super admin, 2 = manager
  int? status;
  File? imageFile; // not for api use

  User();

  User.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : '';
      name = jsonMap['name'] ?? '';
      email = jsonMap['email'] ?? '';
      contactNumber =
          jsonMap['contact_no'] != null ? jsonMap['contact_no'].toString() : '';

      imageUrl = jsonMap['profile_url'] ?? '';
      deviceToken = jsonMap['device_token'] ?? '';
      authToken = jsonMap['access_token'] ?? '';
      userType = jsonMap['user_type'] != null
          ? int.parse(jsonMap['user_type'].toString())
          : 0;
      status = jsonMap['status'] != null
          ? int.parse(jsonMap['status'].toString())
          : 0;
    } catch (e) {
      print("User Model Error: $e");
    }
  }
}
