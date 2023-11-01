class VendorCategory {
  String? id;
  String? name;
  String? description;
  String? slug;
  int? status;

  VendorCategory();

  VendorCategory.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : '';
      name = jsonMap['name'] ?? '';
      description = jsonMap['description'] ?? '';
      slug = jsonMap['slug'] ?? '';
      status = jsonMap['status'] != null
          ? int.parse(jsonMap['status'].toString())
          : 0;
    } catch (e) {
      print("Vendor Category Model Error: $e");
    }
  }
}
