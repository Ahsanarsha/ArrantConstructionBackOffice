import 'package:arrant_construction_bo/src/_manager/pages/btm_nav_mgr.dart';
import 'package:arrant_construction_bo/src/_super_admin/pages/btm_nav_sa.dart';
import 'package:arrant_construction_bo/src/common/pages/splash.dart';
import 'package:arrant_construction_bo/src/helpers/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../src/helpers/app_constants.dart' as constants;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  constants.connectionStatus.initialize();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: constants.primaryColor));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppTheme _appTheme;
  @override
  void initState() {
    super.initState();
    _appTheme = AppTheme();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: _appTheme.getAppLightTheme(),
      debugShowCheckedModeBanner: false,
      initialRoute: "/Splash",
      getPages: [
        GetPage(
            name: "/Splash",
            page: () {
              return const SplashScreen();
            }),
        GetPage(
            name: "/SaBottomNavPage/:index",
            // parameters: {},
            page: () {
              return BottomNavPageSA();
            }),
        GetPage(
            name: "/MgrBottomNavPage/:index",
            // parameters: {},
            page: () {
              return BottomNavPageMgr();
            }),
      ],
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: _appTheme.getAppLightTheme(),
    //   initialRoute: '/',
    //   routes: <String, WidgetBuilder>{
    //     '/': (BuildContext context) => const SplashScreen(),
    //     '/BottomNavPage': (BuildContext context) =>
    //         const BottomNavigationPage(),
    //   },
    // );
  }
}
