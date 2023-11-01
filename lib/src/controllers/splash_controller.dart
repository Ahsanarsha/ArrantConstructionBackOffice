import 'package:arrant_construction_bo/src/common/pages/login.dart';
import 'package:arrant_construction_bo/src/models/user.dart';
import 'package:arrant_construction_bo/src/models/vendor_category.dart';
import 'package:arrant_construction_bo/src/repositories/user_repo.dart'
    as user_repo;
import 'package:arrant_construction_bo/src/repositories/vendor_repo.dart'
    as vendor_repo;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../helpers/app_constants.dart' as constants;

class SplashController extends GetxController {
  // error string
  String errorString = "Splash Controller Error :";
  Future<void> goToNextScreen() async {
    user_repo.getCurrentUser().then((User _u) {
      if (_u.authToken != null && _u.authToken!.isNotEmpty) {
        if (_u.userType == 1) {
          print("User is an Admin");
          Get.offAllNamed('/SaBottomNavPage/1');
        } else if (_u.userType == 2) {
          print("User is a manager");

          Get.offAllNamed('/MgrBottomNavPage/0');
        }
      } else {
        Get.offAll(
          const LoginPage(),
          transition: Transition.rightToLeft,
        );
      }
    }).onError((error, stackTrace) {
      print("$errorString $error");
    }).whenComplete(() {});
  }

  void getVendorCategories() async {
    Stream<VendorCategory> stream = await vendor_repo.getVendorCategories();
    stream.listen((VendorCategory _vendorCategory) {
      constants.vendorCategories.add(_vendorCategory);
    }, onError: (e) {
      print("$errorString $e");
      Fluttertoast.showToast(msg: "No internet!");
    }, onDone: () {});
  }
}
