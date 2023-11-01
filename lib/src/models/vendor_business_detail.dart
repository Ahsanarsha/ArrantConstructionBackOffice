import 'package:arrant_construction_bo/src/models/vendor.dart';
import 'package:arrant_construction_bo/src/models/vendor_category.dart';

class VendorBusinessDetails {
  String? id;
  String? vendorId;
  String? vendorCategoryId;
  // Vendor? vendor;
  VendorCategory? vendorCategory;

  VendorBusinessDetails();

  VendorBusinessDetails.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : '';
      vendorId =
          jsonMap['vendor_id'] != null ? jsonMap['vendor_id'].toString() : '';
      vendorCategoryId =
          jsonMap['category_id'] != null ? jsonMap['category_id'] : '';
      // vendor = jsonMap['vendor'] != null
      //     ? Vendor.fromJSON(jsonMap['vendor'])
      //     : Vendor.fromJSON({});
      vendorCategory = jsonMap['vendor_service'] != null
          ? VendorCategory.fromJSON(jsonMap['vendor_service'])
          : VendorCategory.fromJSON({});
    } catch (e) {
      print("Vendor Business Details Model Error: $e");
    }
  }
}
