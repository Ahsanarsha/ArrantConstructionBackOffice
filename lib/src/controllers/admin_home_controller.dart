import 'package:arrant_construction_bo/src/helpers/helper.dart';
import 'package:arrant_construction_bo/src/models/project.dart';
import 'package:arrant_construction_bo/src/models/user.dart';
import 'package:arrant_construction_bo/src/models/vendor.dart';
import 'package:arrant_construction_bo/src/models/vendor_business_detail.dart';
import 'package:arrant_construction_bo/src/models/vendor_category.dart';
import 'package:arrant_construction_bo/src/repositories/project_repo.dart'
    as project_repo;
import 'package:arrant_construction_bo/src/repositories/user_repo.dart'
    as user_repo;
import 'package:arrant_construction_bo/src/repositories/vendor_repo.dart'
    as vendor_repo;

import 'package:get/get.dart';

class AdminHomeController extends GetxController {
  var projectRequests = <Project>[].obs;
  var projectsPendingApproval = <Project>[].obs;
  var ongoingProjects = <Project>[].obs;
  var totalVendors = <Vendor>[].obs;
  var totalManagers = <User>[].obs;
  List<VendorCategory> vendorServices = <VendorCategory>[];

  // progress variables
  var doneFetchingProjects = false.obs;
  var doneFetchingVendors = false.obs;
  var doneFetchingManagers = false.obs;

  // Error String
  final String errorString = "Home Controller Error :";

  Future<void> getAllProjects() async {
    doneFetchingProjects.value = false;
    projectRequests.clear();
    ongoingProjects.clear();
    projectsPendingApproval.clear();

    Stream<Project> stream = await project_repo.getAdminProjects();
    stream.listen((Project _p) {
      if (_p.id != null && _p.id!.isNotEmpty) {
        switch (_p.status) {
          case 1:
            {
              projectRequests.add(_p);
            }
            break;
          case 2:
            {
              projectsPendingApproval.add(_p);
            }
            break;
          case 3:
            {
              ongoingProjects.add(_p);
            }
            break;
          default:
            {
              print("project is null");
            }
            break;
        }
      }
    }, onError: (e) {
      print(errorString + e.toString());
    }, onDone: () {
      doneFetchingProjects.value = true;
    });
  }

  Future<void> getAllVendors(String vendorCategoryId) async {
    doneFetchingVendors.value = false;
    totalVendors.clear();
    Stream<Vendor> stream = await vendor_repo.getAllVendors(vendorCategoryId);
    stream.listen((Vendor _v) {
      if (_v.id != null && _v.id!.isNotEmpty) {
        totalVendors.add(_v);
      }
    }, onError: (e) {
      print(errorString + e);
    }, onDone: () {
      doneFetchingVendors.value = true;
    });
  }

  Future<void> getAllManagers() async {
    doneFetchingManagers.value = false;
    totalManagers.clear();
    Stream<User> stream = await user_repo.getAllManagers();
    stream.listen((User _manager) {
      if (_manager.id != null && _manager.id!.isNotEmpty) {
        totalManagers.add(_manager);
      }
    }, onError: (e) {
      print(errorString + e);
    }, onDone: () {
      doneFetchingManagers.value = true;
    });
  }

  Future<void> refreshProjects() async {
    getAllProjects();
  }

  Future<void> refreshVendors() async {
    getAllVendors("0");
  }

  Future<void> refreshManagers() async {
    getAllManagers();
  }

  Future<void> refrestHome() async {
    getAllManagers();
    getAllProjects();
    getAllVendors("0");
  }
}
