import 'package:arrant_construction_bo/src/helpers/helper.dart';
import 'package:arrant_construction_bo/src/models/project.dart';
import 'package:arrant_construction_bo/src/models/vendor.dart';
import 'package:arrant_construction_bo/src/models/vendor_category.dart';
import 'package:arrant_construction_bo/src/repositories/project_repo.dart'
    as project_repo;
import 'package:arrant_construction_bo/src/repositories/vendor_repo.dart'
    as vendor_repo;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

class VendorController extends GetxController {
  final String errorString = "Vendor Controller Error: ";
  var vendorProjects = <Project>[].obs;

  // progress variables
  var doneFetchingVendorProjects = false.obs;

  Future<void> getVendorProjects(String vendorId) async {
    vendorProjects.clear();
    doneFetchingVendorProjects.value = false;
    Stream<Project> stream = await project_repo.getVendorProjects(vendorId);
    stream.listen((Project _p) {
      if (_p.status == 3) {
        vendorProjects.add(_p);
      }
    }, onError: (e) {
      print(errorString + e);
    }, onDone: () {
      doneFetchingVendorProjects.value = true;
    });
  }

  void registerVendor(
      BuildContext context, Vendor vendor, String categoryId) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)?.insert(loader);
    await vendor_repo.registerVendor(vendor, categoryId).then((Vendor _vendor) {
      if (_vendor.id!.isNotEmpty) {
        Fluttertoast.showToast(msg: "Vendor registered!");
        Navigator.pop(context);
      }
    }).onError((error, stackTrace) {
      print(errorString + error.toString());
      Helper.hideLoader(loader);
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
  }

  Future<void> refreshVendorProjects(String vendorId) async {
    getVendorProjects(vendorId);
  }
}
