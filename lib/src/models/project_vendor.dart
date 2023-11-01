import 'package:arrant_construction_bo/src/models/vendor.dart';

class ProjectVendor {
  String? id;
  String? projectId;
  String? vendorId;
  String? dateAssigned;
  int? status; // if still working, then 1 else 0
  Vendor? vendor;

  ProjectVendor();

  ProjectVendor.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : '';
      projectId =
          jsonMap['project_id'] != null ? jsonMap['project_id'].toString() : '';
      vendorId =
          jsonMap['vendor_id'] != null ? jsonMap['vendor_id'].toString() : '';
      dateAssigned = jsonMap['date_assigned'] ?? '';
      status = jsonMap['status'] != null
          ? int.parse(jsonMap['status'].toString())
          : 0;
      vendor = jsonMap['vendor'] != null
          ? Vendor.fromJSON(jsonMap['vendor'])
          : Vendor.fromJSON({});
    } catch (e) {
      print("Project Vendor Model Error: $e");
    }
  }
}
