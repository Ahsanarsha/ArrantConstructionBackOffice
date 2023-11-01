import 'package:arrant_construction_bo/src/models/project_vendor.dart';

import '../helpers/helper.dart';
import '../models/project.dart';

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../helpers/app_constants.dart' as constants;

const String _errorString = "Project Repo Error: ";

Future<Stream<Project>> getAdminProjects() async {
  String url = "${constants.apiBaseUrl}admin/project/get";
  print("URI For Getting Admin Projects: $url");

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    "Authorization": "Bearer ${Helper.getUserAuthToken()}",
  };

  Uri uri = Uri.parse(url);

  final client = http.Client();
  try {
    // make request object with headers
    var request = http.Request('get', uri);
    request.headers.addAll(requestHeaders);

    final streamedRest = await client.send(request);

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) {
          // print(data);
          return Helper.getData(data as Map<String, dynamic>);
        })
        .expand((data) => (data as List))
        .map((data) {
          print("printing projects data");
          print(data);
          return Project.fromJSON(data);
        });
  } on SocketException {
    print("Project Repo Socket Exception: ");
    throw const SocketException("Socket exception");
  } catch (e) {
    // print("error caught");
    print("$_errorString$e");
    return Stream.value(Project.fromJSON({}));
  }
}

Future<Stream<Project>> getManagerProjects(String managerId) async {
  String url = "${constants.apiBaseUrl}admin/getManagerProjects/$managerId";
  print("URI For Getting Manager Projects: $url");

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    "Authorization": "Bearer ${Helper.getUserAuthToken()}",
  };

  Uri uri = Uri.parse(url);

  final client = http.Client();
  try {
    // make request object with headers
    var request = http.Request('get', uri);
    request.headers.addAll(requestHeaders);

    final streamedRest = await client.send(request);

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) {
          // print(data);
          return Helper.getData(data as Map<String, dynamic>);
        })
        .expand((data) => (data as List))
        .map((data) {
          print("printing projects data");
          print(data);
          return Project.fromJSON(data);
        });
  } on SocketException {
    print("Project Repo Socket Exception: ");
    throw const SocketException("Socket exception");
  } catch (e) {
    // print("error caught");
    print("$_errorString$e");
    return Stream.value(Project.fromJSON({}));
  }
}

Future<Stream<Project>> getVendorProjects(String vendorId) async {
  String url = "${constants.apiBaseUrl}admin/getVendorProjects/$vendorId";
  print("URI For Getting Vendor Projects: $url");

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    "Authorization": "Bearer ${Helper.getUserAuthToken()}",
  };

  Uri uri = Uri.parse(url);

  final client = http.Client();
  try {
    // make request object with headers
    var request = http.Request('get', uri);
    request.headers.addAll(requestHeaders);

    final streamedRest = await client.send(request);

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) {
          // print(data);
          return Helper.getData(data as Map<String, dynamic>);
        })
        .expand((data) => (data as List))
        .map((data) {
          print("printing projects data");
          print(data['project']);
          return Project.fromJSON(data['project']);
        });
  } on SocketException {
    print("Project Repo Socket Exception: ");
    throw const SocketException("Socket exception");
  } catch (e) {
    // print("error caught");
    print("$_errorString$e");
    return Stream.value(Project.fromJSON({}));
  }
}

Future<Project> sendProjectEstimates(Project project) async {
  String url = "${constants.apiBaseUrl}admin/project/update";
  Map<String, String> body = {
    "project_id": project.id ?? '',
    "estimated_start_date": project.estimatedStartDate ?? '',
    "estimated_end_date": project.estimatedEndDate ?? "",
    "estimated_cost": project.estimatedCost.toString(),
    "comment": project.backofficeComments ?? '',
    "status": project.status.toString(),
  };

  Uri uri = Uri.parse(url);
  final client = http.Client();
  try {
    final response = await client.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json;charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer ${Helper.getUserAuthToken()}'
      },
      body: json.encode(body),
    );
    print("URL For Sending Project Estimates: $url");
    print(body);
    print(response.statusCode);
    print(response.body);

    // Map jsonBody = json.decode(response.body);
    if (response.statusCode == 200) {
      return Project.fromJSON(json.decode(response.body)['data'][0]);
    } else {
      print("throws exception");
      return Project.fromJSON({});
    }
  } catch (e) {
    print(_errorString + e.toString());
    return Project.fromJSON({});
  }
}

Future<Project> assignManagerToProject(
    String managerId, String projectId) async {
  String url = "${constants.apiBaseUrl}admin/project/update";
  Map<String, String> body = {
    "project_id": projectId,
    "manager_id": managerId,
  };

  Uri uri = Uri.parse(url);
  final client = http.Client();
  try {
    final response = await client.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json;charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer ${Helper.getUserAuthToken()}'
      },
      body: json.encode(body),
    );
    print("URL For Assigning Manager To Project: $url");
    print(body);
    print(response.statusCode);
    print(response.body);

    // Map jsonBody = json.decode(response.body);
    if (response.statusCode == 200) {
      return Project.fromJSON(json.decode(response.body)['data'][0]);
    } else {
      print("throws exception");
      return Project.fromJSON({});
    }
  } catch (e) {
    print(_errorString + e.toString());
    return Project.fromJSON({});
  }
}

Future<Stream<ProjectVendor>> assignVendorOnProject(
    String projectId, String vendorId) async {
  String url = "${constants.apiBaseUrl}admin/project/assign-vendor";
  print("URI For Assigning Vendor On Project: $url");

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    "Authorization": "Bearer ${Helper.getUserAuthToken()}",
  };
  List<Map> vendorsList = [
    {"project_id": projectId, "vendor_id": vendorId, "status": "1"}
  ];
  var body = {"vendors": vendorsList};

  Uri uri = Uri.parse(url);

  final client = http.Client();
  try {
    // make request object with headers
    var request = http.Request('POST', uri);
    request.headers.addAll(requestHeaders);
    request.body = json.encode(body);

    final streamedRest = await client.send(request);

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) {
          // print(data);
          return Helper.getData(data as Map<String, dynamic>);
        })
        .expand((data) => (data as List))
        .map((data) {
          print("printing project vendors data");
          print(data);
          return ProjectVendor.fromJSON(data);
        });
  } on SocketException {
    print("Project Repo Socket Exception: ");
    throw const SocketException("Socket exception");
  } catch (e) {
    // print("error caught");
    print("$_errorString$e");
    return Stream.value(ProjectVendor.fromJSON({}));
  }
}

Future<bool> removeVendorFromProject(String projectId, String vendorId) async {
  String url = "${constants.apiBaseUrl}admin/project/vendor/destory";
  print("URL FOR DELETING Project Vendor: $url");

  Map<String, String> body = {
    "project_id": projectId,
    "vendor_id": vendorId,
  };
  try {
    Uri uri = Uri.parse(url);
    final client = new http.Client();
    final response = await client.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json;charset=utf-8',
        HttpHeaders.authorizationHeader: 'Bearer ${Helper.getUserAuthToken()}'
      },
      body: json.encode(body),
    );

    print(response.statusCode);
    // Map responseBody = json.decode(response.body);
    // //print(responseBody.containsKey("errors"));

    if (response.statusCode == 200) {
      //print("log deleted successfully");
      return true;
    } else {
      //print("throws exception");
      throw new Exception(response.body);
    }
    // return currentUser.value;
  } catch (e) {
    print("error caught");
    print("$_errorString $e");
    return false;
  }
}

// Future<Project> updateProjectStatus(String projectId, int status) async {
//   String url = "${constants.apiBaseUrl}client/projectUpdate";
//   Map<String, String> body = {
//     "project_id": projectId,
//     "status": status.toString()
//   };
//   Uri uri = Uri.parse(url);
//   var jsonBody = jsonEncode(body);

//   try {
//     final client = http.Client();
//     final response = await client.post(
//       uri,
//       headers: {
//         HttpHeaders.contentTypeHeader: 'application/json;charset=UTF-8',
//         HttpHeaders.authorizationHeader: 'Bearer ${Helper.getUserAuthToken()}'
//       },
//       body: jsonBody,
//     );

//     // print(body);

//     print(response.statusCode);
//     // print(json.decode(response.body));
//     // Map responseBody = json.decode(response.body);
//     // print(responseBody.containsKey("errors"));

//     if (response.statusCode == 200 &&
//         json.decode(response.body)['data'] != null) {
//       print("project status updated successfully");
//       return Project.fromJSON(json.decode(response.body)['data'][0]);
//     } else {
//       print("throws exception");
//       throw Exception(response.body);
//     }
//   } catch (e) {
//     // print("error caught");
//     print("$_errorString$e");
//     return Project.fromJSON({});
//   }
// }

