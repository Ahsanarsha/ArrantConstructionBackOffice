import 'package:arrant_construction_bo/src/common/widgets/user_circular_avatar.dart';
import 'package:arrant_construction_bo/src/models/user.dart';
import 'package:flutter/material.dart';

class ManagerListTileWidget extends StatelessWidget {
  final User manager;
  final Function onClick;
  final bool isShowdetailPage;
  const ManagerListTileWidget(
    this.manager,
    this.onClick, {
    Key? key,
    this.isShowdetailPage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(
        fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor);
    return ListTile(
      contentPadding: EdgeInsets.all(10.0),
      tileColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      // isThreeLine: true,
      title: Text(
        manager.name!,
        style: titleStyle,
      ),
      //   subtitle: _subtitleWidget(context),
      leading: _leadingWidget(context),
      trailing: isShowdetailPage ? _trailingWidget(context) : SizedBox(),
      onTap: () {
        onClick(manager);
      },
    );
  }

  // Widget _subtitleWidget(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       manager.isApproved!
  //           ? Row(
  //               children: [
  //                 const SizedBox(
  //                   width: 3,
  //                 ),
  //                 const Icon(
  //                   Icons.warning_amber_rounded,
  //                   size: 14,
  //                   color: Colors.yellow,
  //                 ),
  //                 const SizedBox(
  //                   width: 3,
  //                 ),
  //                 const Text("Approvel Pending !"),
  //               ],
  //             )
  //           : Row(
  //               children: [
  //                 const SizedBox(
  //                   width: 3,
  //                 ),
  //                 const Icon(
  //                   Icons.verified_outlined,
  //                   size: 14,
  //                   color: Colors.green,
  //                 ),
  //                 const SizedBox(
  //                   width: 3,
  //                 ),
  //                 const Text("Verified"),
  //               ],
  //             ),
  //       const SizedBox(
  //         height: 5.0,
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           Icon(
  //             Icons.place,
  //             size: 18,
  //             color: Theme.of(context).primaryColor,
  //           ),
  //           Expanded(
  //             child: Text(
  //               manager.shopAddress!,
  //               maxLines: 3,
  //               overflow: TextOverflow.ellipsis,
  //               style: const TextStyle(
  //                 fontSize: 10,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

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
      child: SizedBox(
        height: 43,
        width: 45,
        child: UserCircularAvatar(
          imgUrl: manager.imageUrl!,
          adjustment: BoxFit.fill,
        ),
      ),
    );
  }
}
