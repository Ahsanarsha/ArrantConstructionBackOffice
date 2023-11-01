import 'package:arrant_construction_bo/src/common/pages/login.dart';
import 'package:arrant_construction_bo/src/helpers/helper.dart';
import 'package:arrant_construction_bo/src/models/user.dart';
import 'package:arrant_construction_bo/src/repositories/user_repo.dart'
    as user_repo;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  User user = User();

  // Error string
  final String errorString = "User Controller Error :";

  Future<void> login(BuildContext context) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)?.insert(loader);

    user_repo.login(user).then((User _user) {
      if (_user.authToken != null && _user.authToken!.isNotEmpty) {
        if (_user.userType == 1) {
          print("User is an Admin");
          Get.offAllNamed('/SaBottomNavPage/1');
        } else if (_user.userType == 2) {
          print("User is a manager");

          Get.offAllNamed('/MgrBottomNavPage/0');
        }
      } else {
        Fluttertoast.showToast(msg: "Failed! No record found");
      }
    }).onError((error, stackTrace) {
      print("$errorString $error");
      Fluttertoast.showToast(msg: "Failed! Check internet connection");
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
  }

  Future updateUser(BuildContext context, User currentUser,
      {File? imageFile}) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)?.insert(loader);
    await user_repo
        .updateUser(currentUser, imageFile: imageFile)
        .then((User _updatedUser) {
      if (_updatedUser.id!.isNotEmpty) {
        user_repo.currentUser.value = _updatedUser;
        Fluttertoast.showToast(msg: "Updated");
      }
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: "Failed");
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
  }

  Future<void> logoutUser() async {
    user_repo.removeCurrentUser().then(
      (value) {
        if (value) {
          Get.offAll(
            const LoginPage(),
          );
        }
      },
    ).onError((error, stackTrace) {
      print("$errorString $error");
    }).whenComplete(() {});
  }
}
