import 'package:arrant_construction_bo/src/_super_admin/pages/vendor_detail_page.dart';
import 'package:arrant_construction_bo/src/_super_admin/widgets/show_venders_list_widget.dart';
import 'package:arrant_construction_bo/src/controllers/admin_home_controller.dart';
import 'package:arrant_construction_bo/src/helpers/helper.dart';
import 'package:arrant_construction_bo/src/models/vendor.dart';
import 'package:arrant_construction_bo/src/models/vendor_business_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VendersPage extends StatefulWidget {
  final List<Vendor> vendors;
  final String title;
  final AdminHomeController controller;
  const VendersPage(
    this.vendors, {
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);

  @override
  _VendersPageState createState() => _VendersPageState();
}

class _VendersPageState extends State<VendersPage> {
  void onVendorClick(Vendor vendor) async {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return VendorDetailPage(vendor);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Helper.slideRightToLeftTransition(child, animation);
        },
      ), // transitionDuration: const Duration(milliseconds: 300),
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
          print("refresh");
          return widget.controller.refreshVendors();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Obx(() {
                return widget.vendors.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : ShowVendersListWidget(
                        widget.vendors,
                        onVendorClick,
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
