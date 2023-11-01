import 'dart:io';

class ProjectMediaLibrary {
  String? id;
  String? name;
  String? url;
  String? projectId;
  int? mediaType; // 0 = image, 1 = video;
  int? status; // 0 = not active, 1 = active

  File? imageFile; // for internal use only, not included in api

  ProjectMediaLibrary();

  ProjectMediaLibrary.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : '';
      name = jsonMap['name'] ?? '';
      url = jsonMap['image_url'] ?? '';
      projectId =
          jsonMap['project_id'] != null ? jsonMap['project_id'].toString() : '';
      mediaType =
          jsonMap['type'] != null ? int.parse(jsonMap['type'].toString()) : 0;
      status = jsonMap['status'] != null
          ? int.parse(jsonMap['status'].toString())
          : 0;
    } catch (e) {
      print("Project Media Library Model Error: $e");
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map['project_id'] = projectId;
    return map;
  }
}
