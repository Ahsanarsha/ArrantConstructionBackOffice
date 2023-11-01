import 'package:arrant_construction_bo/src/_super_admin/pages/manager_detail_page.dart';
import 'package:arrant_construction_bo/src/_super_admin/widgets/show_managers_list_widget.dart';
import 'package:arrant_construction_bo/src/controllers/admin_home_controller.dart';
import 'package:arrant_construction_bo/src/helpers/helper.dart';
import 'package:arrant_construction_bo/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagersPage extends StatefulWidget {
  final List<User> managers;
  final String title;
  final AdminHomeController controller;
  const ManagersPage(
    this.managers, {
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);

  @override
  _ManagersPageState createState() => _ManagersPageState();
}

class _ManagersPageState extends State<ManagersPage> {
  void onManagerClick(User manager) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ManagerDetailPage(manager);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Helper.slideRightToLeftTransition(child, animation);
        },
        // transitionDuration: const Duration(milliseconds: 300),
      ),
    );
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
          return widget.controller.refreshManagers();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Obx(() {
                return widget.managers.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : ShowManagersListWidget(
                        widget.managers,
                        onManagerClick,
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
