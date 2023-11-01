import 'package:arrant_construction_bo/src/_super_admin/pages/add_vendor.dart';
import 'package:arrant_construction_bo/src/helpers/helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  void onAddVendorTap(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return AddVendor();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Helper.slideRightToLeftTransition(child, animation);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void onAddWorkTap() {
    print("work");

//TODO: Navigate to add these
  }

  void onAddServiceTap() {
    print("service");
//TODO: Navigate to add these
  }

  void onAddCategoryTap() {
    print("category");

//TODO: Navigate to add these
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            _settingTile(context, FontAwesomeIcons.userPlus, "Add New Vendor",
                () {
              onAddVendorTap(context);
            }),
            // _divider(),
            // _settingTile(context, FontAwesomeIcons.usersCog,
            //     "Add Arrant Service", onAddServiceTap),
            // _divider(),
            // _settingTile(context, FontAwesomeIcons.toolbox,
            //     "Add Work to Admire", onAddWorkTap),
            // _divider(),
            // _settingTile(context, FontAwesomeIcons.buffer,
            //     "Add Vendor's Category", onAddCategoryTap),
            // _divider(),
          ],
        ),
      ),
    );
  }

  Widget _settingTile(
      BuildContext context, IconData icon, String title, Function ontap) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 17),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: Theme.of(context).primaryColor,
        size: 16,
      ),
      onTap: () {
        ontap();
      },
    );
  }

  Widget _divider() {
    return Divider(
      endIndent: 20,
      indent: 15,
      thickness: 2,
    );
  }
}
