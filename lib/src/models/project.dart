import 'package:arrant_construction_bo/src/models/client.dart';
import 'package:arrant_construction_bo/src/models/project_media_library.dart';
import 'package:arrant_construction_bo/src/models/project_service.dart';
import 'package:arrant_construction_bo/src/models/project_vendor.dart';
import 'package:arrant_construction_bo/src/models/user.dart';
import 'package:arrant_construction_bo/src/models/vendor.dart';

class Project {
  String? id;
  String? name;
  String? description;
  String? location;
  String? clientId;
  String? managerId;
  String? requestDate;
  String? estimatedStartDate;
  String? estimatedEndDate;
  String? backofficeComments;

  // 0 = request/project cancel
  // 1 = project requested by client & received by BO
  // 2 = BO sent estimated cost and time & received by client
  // 3 = Client accepted the estimates & BO is being notified
  int? status;
  double? estimatedCost;

  User? manager;
  Client? client;
  List<ProjectMediaLibrary> mediaLibraryFiles = [];
  List<ProjectService> addedProjectServices = [];
  // late List<Vendor> vendors;
  List<ProjectVendor> projectVendors = [];

  Project();

  Project.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : '';
      name = jsonMap['name'] ?? '';
      description = jsonMap['description'] ?? '';
      location = jsonMap['location'] ?? '';
      clientId =
          jsonMap['client_id'] != null ? jsonMap['client_id'].toString() : '';
      managerId = managerId =
          jsonMap['manager_id'] != null ? jsonMap['manager_id'].toString() : '';
      requestDate = jsonMap['request_date'] ?? '';
      estimatedStartDate = jsonMap['estimated_start_date'] ?? '';
      estimatedEndDate = jsonMap['estimated_end_date'] ?? '';
      backofficeComments = jsonMap['comment'] ?? '';
      status = jsonMap['status'] != null
          ? int.parse(jsonMap['status'].toString())
          : 0;
      estimatedCost = jsonMap['estimated_cost'] != null
          ? double.parse(jsonMap['estimated_cost'].toString())
          : 0.0;
      manager = jsonMap['manager'] != null
          ? User.fromJSON(jsonMap['manager'])
          : User.fromJSON({});
      client = jsonMap['client'] != null
          ? Client.fromJSON(jsonMap['client'])
          : Client.fromJSON({});
      addedProjectServices = jsonMap['project_services'] != null &&
              (jsonMap['project_services'] as List).isNotEmpty
          ? List.from(jsonMap['project_services'])
              .map((element) => ProjectService.fromJSON(element))
              .toList()
          : [];
      mediaLibraryFiles = jsonMap['project_media_library'] != null &&
              (jsonMap['project_media_library'] as List).isNotEmpty
          ? List.from(jsonMap['project_media_library'])
              .map((element) => ProjectMediaLibrary.fromJSON(element))
              .toList()
          : [];
      projectVendors = jsonMap['project_vendor'] != null &&
              (jsonMap['project_vendor'] as List).isNotEmpty
          ? List.from(jsonMap['project_vendor'])
              .map((element) => ProjectVendor.fromJSON(element))
              .toList()
          : [];
    } catch (e) {
      print("Project Model Error: $e");
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['description'] = description;
    map['location'] = location;
    map['status'] = status.toString();
    return map;
  }
}
