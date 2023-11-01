import 'package:arrant_construction_bo/src/_manager/pages/mgr_project_details.dart';
import 'package:arrant_construction_bo/src/_super_admin/pages/project_details.dart';
import 'package:arrant_construction_bo/src/common/pages/show_projects_list_widget.dart';
import 'package:arrant_construction_bo/src/controllers/managers_controller.dart';
import 'package:arrant_construction_bo/src/helpers/helper.dart';
import 'package:arrant_construction_bo/src/models/project.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arrant_construction_bo/src/repositories/user_repo.dart'
    as user_repo;

class MgrOnGoingProjects extends StatefulWidget {
  const MgrOnGoingProjects({
    Key? key,
  }) : super(key: key);

  @override
  _MgrOnGoingProjectsState createState() => _MgrOnGoingProjectsState();
}

class _MgrOnGoingProjectsState extends State<MgrOnGoingProjects> {
  final ManagersController _con = Get.put(ManagersController());

  void onProjectClick(Project project) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return MgrProjectDetails(project);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Helper.slideRightToLeftTransition(child, animation);
        },
      ),
    );
  }

  @override
  void initState() {
    _con.getManagerProjects(user_repo.currentUser.value.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ongoing Projects"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          print("refresh");
          return _con.refreshProjects(user_repo.currentUser.value.id!);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Obx(() {
                return _con.managerOngoingProjects.isEmpty &&
                        _con.doneFetchingManagerProjects.value
                    ? _noProjectsToShow()
                    : _con.managerOngoingProjects.isEmpty &&
                            !_con.doneFetchingManagerProjects.value
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : ShowProjectsListWidget(
                            _con.managerOngoingProjects,
                            onProjectClick,
                          );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _noProjectsToShow() {
    Text noProjectsTextWidget =
        const Text("No projects to show! Tap to refresh.");
    IconButton refreshButton = IconButton(
      onPressed: () {
        _con.refreshProjects(user_repo.currentUser.value.id!);
      },
      icon: const Icon(Icons.refresh),
    );
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          refreshButton,
          noProjectsTextWidget,
        ],
      ),
    );
  }
}
