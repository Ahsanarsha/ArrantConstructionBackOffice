class Client {
  String? id;
  String? name;
  String? contactNumber;
  String? imageUrl;
  String? email;

  Client();

  Client.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : '';
      name = jsonMap['name'] ?? '';
      email = jsonMap['email'] ?? '';
      imageUrl = jsonMap['image_url'] ?? '';
      contactNumber =
          jsonMap['contact_no'] != null ? jsonMap['contact_no'].toString() : '';
    } catch (e) {
      print("Client Model Error: $e");
    }
  }
}
