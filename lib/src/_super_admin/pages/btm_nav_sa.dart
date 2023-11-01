import 'package:arrant_construction_bo/src/_super_admin/pages/sa_home.dart';
import 'package:arrant_construction_bo/src/common/pages/profile.dart';
import 'package:arrant_construction_bo/src/_super_admin/pages/settings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavPageSA extends StatefulWidget {
  int? index;
  BottomNavPageSA({Key? key}) : super(key: key) {
    // print(Get.parameters['index']);
    index = int.parse(Get.parameters['index'] ?? "1");
  }

  @override
  _BottomNavPageSAState createState() => _BottomNavPageSAState();
}

class _BottomNavPageSAState extends State<BottomNavPageSA> {
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
              initialRoute: 'saBottomNavPage/settings',
              onGenerateRoute: (RouteSettings settings) {
                WidgetBuilder builder;
                // print(settings.name);
                switch (settings.name) {
                  case 'saBottomNavPage/settings':
                    builder = (BuildContext context) => const SettingsPage();
                    break;
                  default:
                    throw Exception('Invalid route: ${settings.name}');
                }
                return MaterialPageRoute<void>(
                    builder: builder, settings: settings);
              },
            ),
            Navigator(
              initialRoute: 'saBottomNavPage/home',
              // initialRoute: constants.initialRoutes[0],
              onGenerateRoute: (RouteSettings settings) {
                WidgetBuilder builder;
                // print(settings.name);
                switch (settings.name) {
                  case 'saBottomNavPage/home':
                    builder = (BuildContext context) => const SaHome();
                    break;
                  default:
                    throw Exception('Invalid route: ${settings.name}');
                }
                return MaterialPageRoute<void>(
                    builder: builder, settings: settings);
              },
            ),
            Navigator(
              initialRoute: 'saBottomNavPage/profile',
              onGenerateRoute: (RouteSettings settings) {
                WidgetBuilder builder;
                // print(settings.name);
                switch (settings.name) {
                  case 'saBottomNavPage/profile':
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
            // selectedLabelStyle: const TextStyle(
            //   fontSize: 10,
            // ),
            items: [
              _bottomNavBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.cogs,
                  size: iconSize,
                ),
                label: "Settings",
              ),
              _bottomNavBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.home,
                  size: iconSize,
                ),
                label: "Home",
              ),
              _bottomNavBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.user,
                  size: iconSize,
                ),
                label: "Profile",
              ),
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
