import 'package:arrant_construction_bo/src/common/widgets/user_circular_avatar.dart';
import 'package:arrant_construction_bo/src/models/vendor.dart';
import 'package:arrant_construction_bo/src/models/vendor_business_detail.dart';
import 'package:flutter/material.dart';

class VendorListTileWidget extends StatelessWidget {
  final Vendor vendor;
  final Function onVendorClick;
  const VendorListTileWidget(
    this.vendor,
    this.onVendorClick, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(
        fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor);
    return ListTile(
      tileColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      isThreeLine: true,
      title: Padding(
        padding: const EdgeInsets.only(left: 3.0),
        child: Text(
          vendor.businessDetailsList?[0].vendorCategory!.name ?? '',
          style: titleStyle,
        ),
      ),
      subtitle: _subtitleWidget(context),
      leading: _leadingWidget(context),
      trailing: _trailingWidget(context),
      onTap: () {
        onVendorClick(vendor);
      },
    );
  }

  Widget _subtitleWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // vendorBusinessDetails.vendor!.status == 1
        vendor.status == 1
            ? Row(
                children: [
                  const SizedBox(
                    width: 3,
                  ),
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 14,
                    color: Colors.yellow,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  const Text("Approvel Pending !"),
                ],
              )
            : Row(
                children: [
                  const SizedBox(
                    width: 3,
                  ),
                  const Icon(
                    Icons.verified_outlined,
                    size: 14,
                    color: Colors.green,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  const Text("Verified"),
                ],
              ),
        const SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.place,
              size: 18,
              color: Theme.of(context).primaryColor,
            ),
            Expanded(
              child: Text(
                vendor.shopAddress ?? '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _trailingWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.navigate_next_rounded,
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  Widget _leadingWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.2,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                UserCircularAvatar(
                  imgUrl: vendor.imageUrl ?? '',
                  adjustment: BoxFit.fill,
                  height: 42,
                  width: 42,
                ),
                Expanded(
                  child: Text(
                    vendor.firstName ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(
            color: Colors.grey[200],
            thickness: 3,
            width: 0,
          ),
        ],
      ),
    );
  }
}
