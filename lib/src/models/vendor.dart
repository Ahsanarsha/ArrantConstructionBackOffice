import 'package:arrant_construction_bo/src/models/vendor_business_detail.dart';

class Vendor {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? shopAddress;
  String? imageUrl;
  String? contactNumber;
  // String? authToken;
  String? pastExperience;
  int? status;
  // bool? isApproved;
  List<VendorBusinessDetails>? businessDetailsList;

  Vendor();

  Vendor.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : '';
      firstName = jsonMap['first_name'] ?? '';
      lastName = jsonMap['last_name'] ?? '';
      email = jsonMap['email'] ?? '';
      shopAddress = jsonMap['shop_address'] ?? '';
      imageUrl = jsonMap['profile_url'] ?? '';
      contactNumber =
          jsonMap['contact_no'] != null ? jsonMap['contact_no'].toString() : '';
      pastExperience = jsonMap['past_experience'] ?? '';
      status = jsonMap['status'] != null
          ? int.parse(jsonMap['status'].toString())
          : 0;
      // isApproved = jsonMap['is_approved'] != null &&
      //         jsonMap['is_approved'].toString() == '1'
      //     ? true
      //     : false;
      businessDetailsList = jsonMap['vendor_business_detail'] != null &&
              (jsonMap['vendor_business_detail'] as List).isNotEmpty
          ? List.from(jsonMap['vendor_business_detail'])
              .map((element) => VendorBusinessDetails.fromJSON(element))
              .toList()
          : [];
    } catch (e) {
      print("Vendor Model Error: $e");
    }
  }

  Map toMap(String vendorServiceId) {
    var map = <String, dynamic>{};

    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['email'] = email;
    map['contact_no'] = contactNumber;
    map['shop_address'] = shopAddress;
    map['past_experience'] = pastExperience;
    map['password'] = password;
    map['vendor_service_id'] = vendorServiceId;
    return map;
  }
}
