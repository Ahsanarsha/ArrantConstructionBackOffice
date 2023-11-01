import 'package:arrant_construction_bo/src/_manager/pages/completed_projects.dart';

import 'package:arrant_construction_bo/src/_manager/pages/ongoing_projects.dart';
import 'package:arrant_construction_bo/src/common/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavPageMgr extends StatefulWidget {
  int? index;
  BottomNavPageMgr({Key? key}) : super(key: key) {
    index = int.parse(Get.parameters['index'] ?? "0");
  }

  @override
  _BottomNavPageMgrState createState() => _BottomNavPageMgrState();
}

class _BottomNavPageMgrState extends State<BottomNavPageMgr> {
  var currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index.obs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(),
      body: Obx(() {
        return IndexedStack(
          index: currentIndex.value,
          children: [
            Navigator(
              initialRoute: 'mgrBottomNavPage/onGoingProjects',
              // initialRoute: constants.initialRoutes[0],
              onGenerateRoute: (RouteSettings settings) {
                WidgetBuilder builder;
                // print(settings.name);
                switch (settings.name) {
                  case 'mgrBottomNavPage/onGoingProjects':
                    builder =
                        (BuildContext context) => const MgrOnGoingProjects();
                    break;
                  default:
                    throw Exception('Invalid route: ${settings.name}');
                }
                return MaterialPageRoute<void>(
                    builder: builder, settings: settings);
              },
            ),
            Navigator(
              initialRoute: 'mgrBottomNavPage/completedProjects',
              onGenerateRoute: (RouteSettings settings) {
                WidgetBuilder builder;
                // print(settings.name);
                switch (settings.name) {
                  case 'mgrBottomNavPage/completedProjects':
                    builder =
                        (BuildContext context) => const MgrCompletedProjects();
                    break;
                  default:
                    throw Exception('Invalid route: ${settings.name}');
                }
                return MaterialPageRoute<void>(
                    builder: builder, settings: settings);
              },
            ),
            Navigator(
              initialRoute: 'mgrBottomNavPage/profile',
              onGenerateRoute: (RouteSettings settings) {
                WidgetBuilder builder;
                // print(settings.name);
                switch (settings.name) {
                  case 'mgrBottomNavPage/profile':
                    builder = (BuildContext context) => const Profile();
                    break;
                  default:
                    throw Exception('Invalid route: ${settings.name}');
                }
                return MaterialPageRoute<void>(
                    builder: builder, settings: settings);
              },
            ),
          ],
        );
      }),
    );
  }

  Widget _bottomNavigationBar() {
    Radius _bottomNavBarCurveRadius = const Radius.circular(15);
    double iconSize = 20.0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.only(
          topLeft: _bottomNavBarCurveRadius,
          topRight: _bottomNavBarCurveRadius,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0,
            blurRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: _bottomNavBarCurveRadius,
          topRight: _bottomNavBarCurveRadius,
        ),
        child: Obx(() {
          // print("bottom nav rebuilt");
          return BottomNavigationBar(
            onTap: _onIconTap,
            currentIndex: currentIndex.value,
            // dont explicitly define colours
            // when type is fixed
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(
              fontSize: 10,
            ),
            items: [
              _bottomNavBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.clipboardList,
                  size: iconSize,
                ),
                label: "Ongoing Projects",
              ),
              _bottomNavBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.clipboardCheck,
                  size: iconSize,
                ),
                label: "Completed Projects",
              ),
              _bottomNavBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.user,
                  size: iconSize,
                ),
                label: "Profile",
              ),
              // _bottomNavBarItem(
              //   icon: FaIcon(
              //     FontAwesomeIcons.bell,
              //     size: iconSize,
              //   ),
              //   label: "Notifications",
              // ),
            ],
          );
        }),
      ),
    );
  }

  void _onIconTap(int index) {
    // print(index);
    currentIndex.value = index;
  }

  BottomNavigationBarItem _bottomNavBarItem({
    @required Widget? icon,
    String? label,
  }) {
    return BottomNavigationBarItem(
      icon: icon ??
          const SizedBox(
            height: 0.0,
            width: 0.0,
          ),
      label: label ?? '',
    );
  }
}
