import 'dart:io';

class ProjectComment {
  String? id;
  String? text;
  String? imageUrl;
  String? projectId;
  String? date;
  String? time;
  String? senderId;
  String? senderName;
  String? senderImageUrl;

  int? senderType; // 1,2,3,4 Client, Vendor, Manager, Super Admin
  int? isVisibleToClient;
  int? isVisibleToVendor;
  int? isVisibleToManager;

  File? imageFile; // not for api

  ProjectComment();

  ProjectComment.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : '';
      text = jsonMap['text'] ?? '';
      imageUrl = jsonMap['image_url'] ?? '';
      projectId =
          jsonMap['project_id'] != null ? jsonMap['project_id'].toString() : '';
      date = jsonMap['date'] ?? '';
      time = jsonMap['time'] ?? '';
      senderId =
          jsonMap['sender_id'] != null ? jsonMap['sender_id'].toString() : '';
      senderName = jsonMap['sender_name'] ?? '';
      senderImageUrl = jsonMap['sender_image_url'] ?? '';
      senderType = jsonMap['sender_type'] != null
          ? int.parse(jsonMap['sender_type'].toString())
          : 0;
      isVisibleToClient = jsonMap['is_visible_to_client'] != null
          ? int.parse(jsonMap['is_visible_to_client'].toString())
          : 0;
      isVisibleToManager = jsonMap['is_visible_to_manager'] != null
          ? int.parse(jsonMap['is_visible_to_manager'].toString())
          : 0;
      isVisibleToVendor = jsonMap['is_visible_to_vendor'] != null
          ? int.parse(jsonMap['is_visible_to_vendor'].toString())
          : 0;
    } catch (e) {
      print("Project Comment Model Error: $e");
    }
  }

  Map<String, String> toMap() {
    var map = <String, String>{};
    map['project_id'] = projectId ?? "";
    map['text'] = text ?? '';
    map['sender_type'] = senderType.toString();
    map['is_visible_to_client'] = isVisibleToClient.toString();
    map['is_visible_to_vendor'] = isVisibleToVendor.toString();
    map['is_visible_to_manager'] = isVisibleToManager.toString();
    return map;
  }
}
