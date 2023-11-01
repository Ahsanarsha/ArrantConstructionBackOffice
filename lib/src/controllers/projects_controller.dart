import 'package:arrant_construction_bo/src/helpers/helper.dart';
import 'package:arrant_construction_bo/src/models/project.dart';
import 'package:arrant_construction_bo/src/models/project_vendor.dart';
import 'package:arrant_construction_bo/src/models/vendor.dart';
import 'package:arrant_construction_bo/src/repositories/project_repo.dart'
    as project_repo;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ProjectsController extends GetxController {
  final String errorString = "Projects Controller Error";
  final String disposingString = "Projects Controller Disposed";
  var assignedVendors = <Vendor>[].obs;

  @override
  void onClose() {
    print(disposingString);
    super.onClose();
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   print("controller created");
  // }

  Future<bool> sendProjectEstimate(
      BuildContext context, Project project) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)?.insert(loader);
    bool isEstimateSent = false;
    await project_repo.sendProjectEstimates(project).then((Project _p) {
      if (_p.estimatedCost != 0.0) {
        isEstimateSent = true;
        Fluttertoast.showToast(msg: "Estimate Sent!");
      }
    }).onError((error, stackTrace) {
      // isEstimateSent = false;
      print("$errorString $error");
      Fluttertoast.showToast(msg: "Failed! Check internet connection");
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
    return isEstimateSent;
  }

  Future<bool> assignManager(BuildContext context,
      {required String managerId, required String projectId}) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)?.insert(loader);
    bool isAssigned = false;
    await project_repo
        .assignManagerToProject(managerId, projectId)
        .then((Project _p) {
      if (_p.managerId != null &&
          _p.managerId!.isNotEmpty &&
          _p.manager!.name!.isNotEmpty) {
        isAssigned = true;
        Fluttertoast.showToast(msg: "Manager Assigned!");
      }
    }).onError((error, stackTrace) {
      print("$errorString $error");
      Fluttertoast.showToast(msg: "Failed! Check internet connection");
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
    return isAssigned;
  }

  Future assignVendorOnProject(String projectId, Vendor vendor) async {
    assignedVendors.clear();
    Stream<ProjectVendor> stream =
        await project_repo.assignVendorOnProject(projectId, vendor.id ?? '');
    stream.listen((ProjectVendor _projectVendor) {
      if (_projectVendor.vendor!.id!.isNotEmpty) {
        print(_projectVendor.vendor!.id ?? "null");
        print(assignedVendors.length);
        assignedVendors.add(_projectVendor.vendor!);
      }
    }, onError: (e) {
      print(errorString + e);
    }, onDone: () {});
  }

  Future removeVendorFromProject(String projectId, Vendor vendor) async {
    await project_repo
        .removeVendorFromProject(projectId, vendor.id!)
        .then((value) {
      if (value) {
        assignedVendors.removeWhere((Vendor _element) {
          return _element.id == vendor.id;
        });
        Fluttertoast.showToast(msg: "Removed");
      }
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: "Failed");
    }).whenComplete(() {});
  }

  // utility function
  List<Vendor> getVendorsFromProjectVendors(
      List<ProjectVendor> projectVendors) {
    List<Vendor> vendors = [];
    for (var pv in projectVendors) {
      vendors.add(pv.vendor ?? Vendor());
    }
    return vendors;
  }
}
