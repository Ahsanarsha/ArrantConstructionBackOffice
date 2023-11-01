import 'package:arrant_construction_bo/src/_super_admin/pages/managers.dart';
import 'package:arrant_construction_bo/src/_super_admin/pages/sa_projects.dart';
import 'package:arrant_construction_bo/src/_super_admin/pages/venders.dart';
import 'package:arrant_construction_bo/src/common/widgets/image_dialog.dart';
import 'package:arrant_construction_bo/src/common/widgets/loading_card_widgets.dart';
import 'package:arrant_construction_bo/src/common/widgets/user_circular_avatar.dart';
import 'package:arrant_construction_bo/src/controllers/admin_home_controller.dart';
import 'package:arrant_construction_bo/src/helpers/helper.dart';
import 'package:arrant_construction_bo/src/models/project.dart';
import 'package:arrant_construction_bo/src/models/user.dart';
import 'package:arrant_construction_bo/src/models/vendor.dart';
import 'package:arrant_construction_bo/src/models/vendor_business_detail.dart';
import 'package:arrant_construction_bo/src/repositories/user_repo.dart'
    as user_repo;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SaHome extends StatefulWidget {
  const SaHome({Key? key}) : super(key: key);

  @override
  _SaHomeState createState() => _SaHomeState();
}

class _SaHomeState extends State<SaHome> {
  final AdminHomeController _con = Get.put(AdminHomeController());
  late double menuCardWidth;
  final double loadingWidgetHeight = 150;

  void showAllProject(List<Project> projects, String title) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ProjectsPage(
            projects,
            title: title,
            controller: _con,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Helper.slideRightToLeftTransition(child, animation);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void showAllManagers(List<User> managers) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ManagersPage(
            managers,
            title: "Managers",
            controller: _con,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Helper.slideRightToLeftTransition(child, animation);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void showAllVendors(List<Vendor> vendors, String title) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return VendersPage(
            vendors,
            title: title,
            controller: _con,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Helper.slideRightToLeftTransition(child, animation);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  void initState() {
    _con.getAllProjects();
    _con.getAllVendors("0");
    _con.getAllManagers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    menuCardWidth = screenSize.width * 0.40;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _con.refrestHome();
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              SizedBox(
                height: screenSize.height * 0.02,
              ),
              _userInfoTile(),
              SizedBox(
                height: screenSize.height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 40,
                  mainAxisSpacing: 20,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Obx(() {
                      return _con.projectRequests.isEmpty &&
                              !_con.doneFetchingProjects.value
                          ? LoadingCardWidget(
                              width: menuCardWidth,
                              height: loadingWidgetHeight,
                            )
                          : _con.projectRequests.isEmpty &&
                                  _con.doneFetchingProjects.value
                              ? DashboardMenuCard(
                                  icon: FontAwesomeIcons.chalkboardTeacher,
                                  title: "Project Requests",
                                  count: 0,
                                  cardWidth: menuCardWidth,
                                  onMenuItemTap: () {
                                    //   showAllProject(_con.projectRequests);
                                  },
                                )
                              : DashboardMenuCard(
                                  icon: FontAwesomeIcons.chalkboardTeacher,
                                  title: "Project Requests",
                                  count: _con.projectRequests.length,
                                  cardWidth: menuCardWidth,
                                  onMenuItemTap: () {
                                    showAllProject(
                                      _con.projectRequests,
                                      "Project Requests",
                                    );
                                  },
                                );
                    }),
                    Obx(() {
                      return _con.ongoingProjects.isEmpty &&
                              !_con.doneFetchingProjects.value
                          ? LoadingCardWidget(
                              width: menuCardWidth,
                              height: loadingWidgetHeight,
                            )
                          : _con.ongoingProjects.isEmpty &&
                                  _con.doneFetchingProjects.value
                              ? DashboardMenuCard(
                                  icon: FontAwesomeIcons.tasks,
                                  title: "Ongoing Projects",
                                  count: 0,
                                  cardWidth: menuCardWidth,
                                  onMenuItemTap: () {},
                                )
                              : DashboardMenuCard(
                                  icon: FontAwesomeIcons.tasks,
                                  title: "Ongoing Projects",
                                  count: _con.ongoingProjects.length,
                                  cardWidth: menuCardWidth,
                                  onMenuItemTap: () {
                                    showAllProject(_con.ongoingProjects,
                                        "Ongoing Projects");
                                  },
                                );
                    }),
                    Obx(() {
                      return _con.projectsPendingApproval.isEmpty &&
                              !_con.doneFetchingProjects.value
                          ? LoadingCardWidget(
                              width: menuCardWidth,
                              height: loadingWidgetHeight,
                            )
                          : _con.projectsPendingApproval.isEmpty &&
                                  _con.doneFetchingProjects.value
                              ? DashboardMenuCard(
                                  icon: FontAwesomeIcons.userClock,
                                  title: "Pending Client's Approval",
                                  count: 0,
                                  cardWidth: menuCardWidth,
                                  onMenuItemTap: () {},
                                )
                              : DashboardMenuCard(
                                  icon: FontAwesomeIcons.userClock,
                                  title: "Pending Client's Approval",
                                  count: _con.projectsPendingApproval.length,
                                  cardWidth: menuCardWidth,
                                  onMenuItemTap: () {
                                    showAllProject(_con.projectsPendingApproval,
                                        "Pending Client's Approval");
                                  },
                                );
                    }),
                    Obx(() {
                      return _con.totalVendors.isEmpty &&
                              !_con.doneFetchingVendors.value
                          ? LoadingCardWidget(
                              width: menuCardWidth,
                              height: loadingWidgetHeight,
                            )
                          : _con.totalVendors.isEmpty &&
                                  _con.doneFetchingVendors.value
                              ? DashboardMenuCard(
                                  icon: FontAwesomeIcons.userFriends,
                                  title: "Total Vendors",
                                  count: 0,
                                  cardWidth: menuCardWidth,
                                  onMenuItemTap: () {},
                                )
                              : DashboardMenuCard(
                                  icon: FontAwesomeIcons.userFriends,
                                  title: "Total Vendors",
                                  count: _con.totalVendors.length,
                                  cardWidth: menuCardWidth,
                                  onMenuItemTap: () {
                                    showAllVendors(
                                        _con.totalVendors, "Vendors");
                                  },
                                );
                    }),
                    Obx(() {
                      return _con.totalManagers.isEmpty &&
                              !_con.doneFetchingManagers.value
                          ? LoadingCardWidget(
                              width: menuCardWidth,
                              height: loadingWidgetHeight,
                            )
                          : _con.totalManagers.isEmpty &&
                                  _con.doneFetchingManagers.value
                              ? DashboardMenuCard(
                                  icon: FontAwesomeIcons.userTie,
                                  title: "Total Managers",
                                  count: 0,
                                  cardWidth: menuCardWidth,
                                  onMenuItemTap: () {},
                                )
                              : DashboardMenuCard(
                                  icon: FontAwesomeIcons.userTie,
                                  title: "Total Managers",
                                  count: _con.totalManagers.length,
                                  cardWidth: menuCardWidth,
                                  onMenuItemTap: () {
                                    showAllManagers(_con.totalManagers);
                                  },
                                );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userInfoTile() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListTile(
          title: Text(
            "Admin",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          subtitle: Text(
            user_repo.currentUser.value.name!.toUpperCase(),
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          trailing: GestureDetector(
            onTap: () {
              if (user_repo.currentUser.value.imageUrl != "") {
                Get.dialog(ImageDialogWidget(
                  user_repo.currentUser.value.imageUrl!,
                  width: MediaQuery.of(context).size.width * 0.90,
                ));
              }
            },
            child: UserCircularAvatar(
              imgUrl: user_repo.currentUser.value.imageUrl ?? '',
            ),
          ),
        ),
      );
    });
  }
}

class DashboardMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final double cardWidth;
  final Function onMenuItemTap;
  const DashboardMenuCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.count,
    required this.cardWidth,
    required this.onMenuItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onMenuItemTap();
      },
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: cardWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.009,
            ),
            Icon(
              icon,
              size: 40.0,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Text(
              count.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
