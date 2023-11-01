import 'package:arrant_construction_bo/src/models/vendor.dart';
import 'package:arrant_construction_bo/src/models/vendor_category.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../helpers/helper.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../helpers/app_constants.dart' as constants;

const String _errorString = "Vendor Repo Error: ";

Future<Stream<VendorCategory>> getVendorCategories() async {
  String url = "${constants.apiBaseUrl}getVendorServices";
  print("URI For Getting Vendor Categories/Services: $url");

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    // "Authorization": "Bearer ${Helper.getUserAuthToken()}",
  };
  try {
    Uri uri = Uri.parse(url);

    final client = http.Client();

    // make request object with headers
    var request = http.Request('get', uri);
    request.headers.addAll(requestHeaders);

    final streamedRest = await client.send(request);

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) {
          print(data);
          return Helper.getData(data as Map<String, dynamic>);
        })
        .expand((data) => (data as List))
        .map((data) {
          print("printing vendor services data");
          print(data);
          return VendorCategory.fromJSON(data);
        });
  } on SocketException {
    print("General Repo Socket Exception: ");
    throw const SocketException("Socket exception");
  } catch (e) {
    print("error caught");
    print("General Repo Error: $e");
    return Stream.value(VendorCategory.fromJSON({}));
  }
}

Future<Vendor> registerVendor(Vendor vendor, String categoryId) async {
  String url = "${constants.apiBaseUrl}admin/vendor-register";
  var body = vendor.toMap(categoryId);

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
    print("URL For Registering vendor: $url");
    print(body);
    print(response.statusCode);
    print(response.body);
    Map<String, dynamic> responseJson = json.decode(response.body);

    if (response.statusCode == 200) {
      if (responseJson['status'] == 200) {
        return Vendor.fromJSON(json.decode(response.body)['data'][0]);
      } else {
        Fluttertoast.showToast(msg: responseJson['message']);
        return Vendor.fromJSON({});
      }
    } else {
      print(response.reasonPhrase);
      Fluttertoast.showToast(msg: response.reasonPhrase!);
      return Vendor.fromJSON({});
    }
  } catch (e) {
    print(_errorString + e.toString());

    return Vendor.fromJSON({});
  }
}

Future<Stream<Vendor>> getAllVendors(String categoryId) async {
  String url =
      "${constants.apiBaseUrl}admin/project/get-vendors?category=$categoryId";
  print("URI For Getting Vendors: $url");

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
          print("printing vendors data");
          print(data);
          return Vendor.fromJSON(data);
        });
  } on SocketException {
    print("Vendor Repo Socket Exception: ");
    throw const SocketException("Socket exception");
  } catch (e) {
    // print("error caught");
    print("$_errorString$e");
    return Stream.value(Vendor.fromJSON({}));
  }
}
