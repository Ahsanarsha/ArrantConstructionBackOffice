import 'package:arrant_construction_bo/src/_super_admin/widgets/vendor_list_tile.dart';
import 'package:arrant_construction_bo/src/models/vendor.dart';
import 'package:arrant_construction_bo/src/models/vendor_business_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ShowVendersListWidget extends StatelessWidget {
  final List<Vendor> vendors;
  final Function onVendorTap;
  const ShowVendersListWidget(this.vendors, this.onVendorTap, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: vendors.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: VendorListTileWidget(
            vendors[index],
            onVendorTap,
          ),
        );
      },
    );
  }
}
