import 'package:arrant_construction_bo/src/_super_admin/pages/vendor_projects.dart';
import 'package:arrant_construction_bo/src/common/widgets/user_circular_avatar.dart';
import 'package:arrant_construction_bo/src/helpers/helper.dart';
import 'package:arrant_construction_bo/src/models/vendor.dart';
import 'package:arrant_construction_bo/src/models/vendor_business_detail.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VendorDetailPage extends StatelessWidget {
  final Vendor vendor;
  const VendorDetailPage(this.vendor, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vendor Details"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _userData(context),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          _userDetails(context),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return VendorProjects(vendor);
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return Helper.slideRightToLeftTransition(child, animation);
                  },
                ), // transitionDuration: const Duration(milliseconds: 300),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Projects",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 5),
                  child: Icon(
                    FontAwesomeIcons.longArrowAltRight,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _userData(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Center(
            child: UserCircularAvatar(
              imgUrl: vendor.imageUrl ?? '',
            ),
          ),
        ),
        Text(
          vendor.firstName ?? '' + " ${vendor.lastName ?? ''}",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.handyman_outlined,
              size: 16,
              color: Colors.grey,
            ),
            Text(
              vendor.businessDetailsList?[0].vendorCategory!.name ?? '',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _userDetails(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _userDetailsContent(
            icon: Icons.contact_phone_outlined,
            title: "Contact Number",
            content: vendor.contactNumber ?? 'N/A',
          ),
          const SizedBox(
            height: 15,
          ),
          _userDetailsContent(
            icon: Icons.email_outlined,
            title: "Email",
            content: vendor.email!,
          ),
          const SizedBox(
            height: 15,
          ),
          _userDetailsContent(
            icon: Icons.location_on_outlined,
            title: "Shop Address",
            content: vendor.shopAddress!,
          ),
          const SizedBox(
            height: 15,
          ),
          _userDetailsContent(
            icon: Icons.work_outline_outlined,
            title: "Past Experience",
            content: vendor.pastExperience ?? '',
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _userDetailsContent(
      {required IconData icon,
      required String title,
      required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: Colors.grey,
                ),
                Text(
                  " $title:  ",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
