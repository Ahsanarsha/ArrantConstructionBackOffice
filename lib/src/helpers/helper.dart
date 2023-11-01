import 'dart:async';
import 'package:arrant_construction_bo/src/common/widgets/custom_circular_progress_indicator.dart';
import 'package:arrant_construction_bo/src/models/vendor_category.dart';
// import 'package:arrant_construction_client/src/models/vendor_service.dart';

import '../helpers/app_constants.dart' as constants;
import '../repositories/user_repo.dart' as user_repo;
import '../common/widgets/custom_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Helper {
  late BuildContext context;
  static List<VendorCategory> _vendorServices = [];

  Helper.of(BuildContext _context) {
    context = _context;
  }

  static SlideTransition slideRightToLeftTransition(
      Widget child, Animation animation,
      {Curve curve = Curves.ease}) {
    const begin = Offset(1.0, 0);
    const end = Offset.zero;
    const curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  static SlideTransition bottomToTopTransition(
      Widget child, Animation animation,
      {Curve curve = Curves.ease}) {
    const begin = Offset(0, 1);
    const end = Offset.zero;
    const curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  // for mapping data retrieved from json array
  static getData(Map<String, dynamic> data) {
    // print(data);
    return data['data'] ?? [];
  }

  static Uri getUri(String path) {
    String _path = Uri.parse(constants.apiBaseUrl).path;
    if (!_path.endsWith('/')) {
      _path += '/';
    }
    Uri uri = Uri(
        scheme: Uri.parse(constants.apiBaseUrl).scheme,
        host: Uri.parse(constants.apiBaseUrl).host,
        port: Uri.parse(constants.apiBaseUrl).port,
        path: _path + path);
    return uri;
  }

  static setVendorServices(List<VendorCategory> services) {
    _vendorServices = services;
  }

  static List<VendorCategory> getVendorServices() {
    return _vendorServices;
  }

  static String getUserAuthToken() {
    return user_repo.currentUser.value.authToken != null &&
            user_repo.currentUser.value.authToken!.isNotEmpty
        ? user_repo.currentUser.value.authToken ?? ''
        : '';
  }

  RichText getPriceRichText(
    double price, {
    Color color = Colors.black,
    double size = 12,
    FontWeight weight = FontWeight.bold,
  }) {
    return RichText(
      text: TextSpan(
        // text: 'Hello ',
        // style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
            text: '\$',
            style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          TextSpan(
            text: price.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size,
              color: color,
              fontWeight: weight,
            ),
          ),
        ],
      ),
    );
  }

  // remove new line '\n' from string
  static String trimNewLine(String input) {
    String result = "";
    if (!input.contains('\n')) {
      return input;
    } else {
      for (int i = 0; i < input.length; i++) {
        if (input[i] != '\n') {
          result += input[i];
        }
      }
      return result;
    }
  }

  static OverlayEntry overlayLoader(context) {
    OverlayEntry loader = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(
          // set opacity of color to make
          // background screen blur type
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          child: const CustomCircularProgressIndicator(
            height: 200,
          ),
        ),
      );
    });
    return loader;
  }

  static hideLoader(OverlayEntry loader) {
    Timer(const Duration(milliseconds: 500), () {
      try {
        loader.remove();
      } catch (e) {
        print("Hide progress indicator error: $e");
      }
    });
  }

  // returns the regular expression
  // for having any special character
  static RegExp specialCharacterRegex() {
    return RegExp(r'[_!@#$%^&*(),.?~":{}|<>]');
  }

  // return the RE
  // for alphanumeric characters
  static RegExp alphanumericRegex() {
    return RegExp(r'[a-zA-Z0-9]');
  }
}
