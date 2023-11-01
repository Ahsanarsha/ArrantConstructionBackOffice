import 'package:arrant_construction_bo/src/_super_admin/pages/project_details.dart';
import 'package:arrant_construction_bo/src/common/pages/show_projects_list_widget.dart';
import 'package:arrant_construction_bo/src/common/widgets/user_circular_avatar.dart';
import 'package:arrant_construction_bo/src/controllers/managers_controller.dart';
import 'package:arrant_construction_bo/src/helpers/helper.dart';

import 'package:arrant_construction_bo/src/models/project.dart';
import 'package:arrant_construction_bo/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerDetailPage extends StatefulWidget {
  final User manager;
  final bool isShowdetailPage;
  const ManagerDetailPage(this.manager,
      {Key? key, this.isShowdetailPage = true})
      : super(key: key);

  @override
  _ManagerDetailPageState createState() => _ManagerDetailPageState();
}

class _ManagerDetailPageState extends State<ManagerDetailPage> {
  final ManagersController _con = Get.put(ManagersController());
  final List<Tab> _projectTypes = const [
    Tab(
      text: "Ongoing Projects",
    ),
    Tab(
      text: "Completed Projects",
    ),
  ];

  void onProjectClick(Project project) async {
    if (widget.isShowdetailPage) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return ProjectDetails(
              project,
              showManagerDetails: false,
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Helper.slideRightToLeftTransition(child, animation);
          },
          // transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _con.getManagerProjects(widget.manager.id!);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _projectTypes.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(230.0),
          child: AppBar(
            flexibleSpace: _managerData(),
            centerTitle: true,
            bottom: TabBar(
              isScrollable: true,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              indicatorColor: Theme.of(context).primaryColor,
              tabs: _projectTypes,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() {
              return _con.managerOngoingProjects.isEmpty &&
                      _con.doneFetchingManagerProjects.value
                  ? _noProjectsToShow()
                  : _con.managerOngoingProjects.isEmpty &&
                          !_con.doneFetchingManagerProjects.value
                      ? Center(child: CircularProgressIndicator.adaptive())
                      : RefreshIndicator(
                          onRefresh: () async {
                            return _con.refreshProjects(widget.manager.id!);
                          },
                          child: ShowProjectsListWidget(
                            _con.managerOngoingProjects,
                            onProjectClick,
                            isShowForward: widget.isShowdetailPage,
                          ),
                        );
            }),
            Obx(() {
              return _con.managerCompletedProjects.isEmpty &&
                      _con.doneFetchingManagerProjects.value
                  ? _noProjectsToShow()
                  : _con.managerCompletedProjects.isEmpty &&
                          !_con.doneFetchingManagerProjects.value
                      ? Center(child: CircularProgressIndicator.adaptive())
                      : RefreshIndicator(
                          onRefresh: () async {
                            return _con.refreshProjects(widget.manager.id!);
                          },
                          child: ShowProjectsListWidget(
                            _con.managerCompletedProjects,
                            onProjectClick,
                            isShowForward: widget.isShowdetailPage,
                          ),
                        );
            }),
          ],
        ),
      ),
    );
  }

  Widget _noProjectsToShow() {
    Text noProjectsTextWidget =
        const Text("No projects to show! Tap to refresh.");
    IconButton refreshButton = IconButton(
      onPressed: () {
        _con.refreshProjects(widget.manager.id!);
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

  Widget _managerData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UserCircularAvatar(imgUrl: widget.manager.imageUrl!),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            widget.manager.name!,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
        Text(
          widget.manager.email!,
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }
}
