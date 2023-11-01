import 'package:arrant_construction_bo/src/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/app_constants.dart' as constants;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController _con = Get.put(SplashController());

  @override
  void initState() {
    super.initState();
    _con.getVendorCategories();
    _con.goToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constants.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            // Text(
            //   constants.arrantConstruction,
            //   style: TextStyle(
            //     fontSize: 20,
            //     color: Colors.white,
            //   ),
            // ),
            Image(
              image: AssetImage("assets/img/ac_logo_white.png"),
              width: 80,
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
