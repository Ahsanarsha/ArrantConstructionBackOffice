import 'package:arrant_construction_bo/src/_super_admin/pages/project_details.dart';
import 'package:arrant_construction_bo/src/common/pages/show_projects_list_widget.dart';
import 'package:arrant_construction_bo/src/controllers/admin_home_controller.dart';
import 'package:arrant_construction_bo/src/helpers/helper.dart';
import 'package:arrant_construction_bo/src/models/project.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectsPage extends StatefulWidget {
  final List<Project> projects;
  final String title;
  final AdminHomeController controller;
  const ProjectsPage(
    this.projects, {
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);

  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  void onProjectClick(Project project) async {
    // bool isProjectAccepted = await
    bool isProjectUpdated = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ProjectDetails(project);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Helper.slideRightToLeftTransition(child, animation);
        },
        // transitionDuration: const Duration(milliseconds: 300),
      ),
    );
    if (isProjectUpdated) {
      widget.controller.refreshProjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          print("refresh");
          return widget.controller.refreshProjects();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Obx(() {
                return widget.projects.isEmpty
                    ?
                    //  const Center(
                    //     child: CircularProgressIndicator.adaptive(),
                    //   )
                    Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("No projects to show!"),
                          ],
                        ),
                      )
                    : ShowProjectsListWidget(
                        widget.projects,
                        onProjectClick,
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
