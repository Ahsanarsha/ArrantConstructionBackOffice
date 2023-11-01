import 'package:arrant_construction_bo/src/models/project.dart';
import 'package:arrant_construction_bo/src/models/user.dart';
import 'package:arrant_construction_bo/src/repositories/project_repo.dart'
    as project_repo;
import 'package:get/get.dart';

class ManagersController extends GetxController {
  final String errorString = "Manager Controller Error: ";
  var managerOngoingProjects = <Project>[].obs;
  var managerCompletedProjects = <Project>[].obs;

  // progress variables
  var doneFetchingManagerProjects = false.obs;

  Future<void> getManagerProjects(String managerId) async {
    managerOngoingProjects.clear();
    managerCompletedProjects.clear();
    doneFetchingManagerProjects.value = false;
    Stream<Project> stream = await project_repo.getManagerProjects(managerId);
    stream.listen((Project _p) {
      if (_p.status == 3) {
        managerOngoingProjects.add(_p);
      }
    }, onError: (e) {
      print(errorString + e);
    }, onDone: () {
      doneFetchingManagerProjects.value = true;
    });
  }

  Future<void> refreshProjects(String managerId) async {
    getManagerProjects(managerId);
  }
}
