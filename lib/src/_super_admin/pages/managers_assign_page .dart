import 'package:arrant_construction_bo/src/_super_admin/pages/manager_detail_page.dart';
import 'package:arrant_construction_bo/src/common/dialogs/confirmation_dialog.dart';
import 'package:arrant_construction_bo/src/common/widgets/user_circular_avatar.dart';
import 'package:arrant_construction_bo/src/controllers/admin_home_controller.dart';
import 'package:arrant_construction_bo/src/controllers/projects_controller.dart';
import 'package:arrant_construction_bo/src/helpers/helper.dart';
import 'package:arrant_construction_bo/src/models/user.dart';
import '../../helpers/app_constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagersAssignPage extends StatefulWidget {
  final List<User> managers;
  final String projectId;
  final AdminHomeController controller;
  const ManagersAssignPage(
    this.managers, {
    Key? key,
    required this.projectId,
    required this.controller,
  }) : super(key: key);

  @override
  _ManagersAssignPageState createState() => _ManagersAssignPageState();
}

class _ManagersAssignPageState extends State<ManagersAssignPage> {
  final ProjectsController _projectsController =
      Get.find(tag: constants.projectsConTag);
  //OntileClick
  void onManagerClick(User manager) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ManagerDetailPage(
            manager,
            isShowdetailPage: false,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Helper.slideRightToLeftTransition(child, animation);
        },
      ),
    );
  }

  void onAssignClick(User manager) async {
    // open confirmation dialog
    // with manager info
    _projectsController
        .assignManager(
      context,
      managerId: manager.id ?? '',
      projectId: widget.projectId,
    )
        .then((value) {
      if (value) {
        Navigator.pop(context, manager);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assign Manager"),
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
                    : _ShowManagersListWidget(
                        widget.managers,
                        onManagerClick,
                        onAssignClick,
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShowManagersListWidget extends StatelessWidget {
  final List<User> managers;
  final Function onTileTap;
  final Function onAssignTap;

  const _ShowManagersListWidget(this.managers, this.onTileTap, this.onAssignTap,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: managers.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: _ManagerListTileWidget(
            managers[index],
            onTileTap,
            onAssignTap,
          ),
        );
      },
    );
  }
}

class _ManagerListTileWidget extends StatelessWidget {
  final User manager;
  final Function onTileClick;
  final Function onAssignClick;

  const _ManagerListTileWidget(
    this.manager,
    this.onTileClick,
    this.onAssignClick, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(
        fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor);
    return ListTile(
      contentPadding: EdgeInsets.all(10.0),
      tileColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      // isThreeLine: true,
      title: Text(
        manager.name!,
        style: titleStyle,
      ),
      //   subtitle: _subtitleWidget(context),
      leading: _leadingWidget(context),
      trailing: _trailingWidget(context),
      onTap: () {
        onTileClick(manager);
      },
    );
  }

  void _onConfirmAssigning() {
    onAssignClick(manager);
  }

  Widget _trailingWidget(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => ConfirmationDialog(
            "Assign ${manager.name} on this project?",
            _onConfirmAssigning,
          ),
        );
        // onAssignClick(manager);
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
      ),
      child: Text(
        "Assign",
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
    );
  }

  Widget _leadingWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.2,
      child: SizedBox(
        height: 43,
        width: 45,
        child: UserCircularAvatar(
          imgUrl: manager.imageUrl!,
          adjustment: BoxFit.fill,
        ),
      ),
    );
  }
}
