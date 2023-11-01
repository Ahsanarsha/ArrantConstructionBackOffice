import 'package:arrant_construction_bo/src/common/pages/show_projects_list_widget.dart';
import 'package:arrant_construction_bo/src/controllers/vendor_controller.dart';
import 'package:arrant_construction_bo/src/models/vendor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VendorProjects extends StatefulWidget {
  final Vendor vendor;
  const VendorProjects(this.vendor, {Key? key}) : super(key: key);

  @override
  _VendorProjectsState createState() => _VendorProjectsState();
}

class _VendorProjectsState extends State<VendorProjects> {
  VendorController _con = Get.put(VendorController());

  @override
  void initState() {
    _con.getVendorProjects(widget.vendor.id!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Projects"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              return _con.vendorProjects.isEmpty &&
                      _con.doneFetchingVendorProjects.value
                  ? Center(child: _refreshList())
                  : _con.vendorProjects.isEmpty &&
                          !_con.doneFetchingVendorProjects.value
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        )
                      : ShowProjectsListWidget(
                          _con.vendorProjects,
                          () {},
                          isShowForward: false,
                        );
            }),
          ],
        ),
      ),
    );
  }

  Widget _refreshList() {
    Text noProjectsTextWidget = Text("No projects to show! Tap to refresh!");
    IconButton refreshButton = IconButton(
      onPressed: () {
        _con.refreshVendorProjects(widget.vendor.id!);
      },
      icon: const Icon(Icons.refresh),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        refreshButton,
        noProjectsTextWidget,
      ],
    );
  }
}
