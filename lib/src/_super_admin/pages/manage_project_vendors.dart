import 'package:arrant_construction_bo/src/_super_admin/pages/vendor_detail_page.dart';
import 'package:arrant_construction_bo/src/common/dialogs/confirmation_dialog.dart';
import 'package:arrant_construction_bo/src/common/widgets/user_circular_avatar.dart';
import 'package:arrant_construction_bo/src/controllers/admin_home_controller.dart';
import 'package:arrant_construction_bo/src/controllers/projects_controller.dart';
import 'package:arrant_construction_bo/src/helpers/helper.dart';
import 'package:arrant_construction_bo/src/models/vendor.dart';
import 'package:arrant_construction_bo/src/models/vendor_business_detail.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../helpers/app_constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageProjectVendors extends StatefulWidget {
  final String projectId;
  final List<Vendor> allVendors;
  const ManageProjectVendors(this.projectId, this.allVendors, {Key? key})
      : super(key: key);

  @override
  _ManageProjectVendorsState createState() => _ManageProjectVendorsState();
}

class _ManageProjectVendorsState extends State<ManageProjectVendors> {
  ProjectsController _con = Get.find(tag: constants.projectsConTag);

  //OntileClick
  void onVendorTileClick(Vendor vendor) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return VendorDetailPage(vendor);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Helper.slideRightToLeftTransition(child, animation);
        },
      ),
    );
  }

  void onAssignClick(Vendor vendor) {
    // print(newValue);
    print("assign $vendor");
    _con.assignVendorOnProject(widget.projectId, vendor);
  }

  void onVendorRemove(Vendor vendor) {
    print("remove $vendor");
    _con.removeVendorFromProject(widget.projectId, vendor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Vendors"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          //  return widget.controller.refreshVendors();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Obx(() {
                print(_con.assignedVendors.length);
                return widget.allVendors.isEmpty && _con.assignedVendors.isEmpty
                    ? const Center(
                        child: Text("No vendor assigned"),
                      )
                    : _ShowVendorsListWidget(
                        widget.allVendors,
                        _con.assignedVendors,
                        onVendorTileClick,
                        onAssignClick,
                        onVendorRemove,
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShowVendorsListWidget extends StatelessWidget {
  final List<Vendor> allVendors;
  final List<Vendor> assignedVendors;
  final Function onTileTap;
  final Function onAssignTap;
  final Function onVendorRemove;

  const _ShowVendorsListWidget(this.allVendors, this.assignedVendors,
      this.onTileTap, this.onAssignTap, this.onVendorRemove,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(assignedVendors.length);
    print("reloading assigned vendors");
    return ListView.builder(
      itemCount: allVendors.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // print(index);
        bool isVendorAssigned = false;
        if (assignedVendors.isNotEmpty) {
          for (int i = 0; i < assignedVendors.length; i++) {
            if (allVendors[index].id == assignedVendors[i].id) {
              isVendorAssigned = true;
              break;
            }
          }
        }
        print("is vendor assigned: $isVendorAssigned");
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: _VendorListTileWidget(
            allVendors[index],
            isVendorAssigned,
            onTileTap,
            onAssignTap,
            onVendorRemove,
          ),
        );
      },
    );
  }
}

class _VendorListTileWidget extends StatefulWidget {
  final Vendor vendor;
  final bool isAssigned;
  final Function onTileClick;
  final Function onAssignVendor;
  final Function onRemoveVendor;
  _VendorListTileWidget(
    this.vendor,
    this.isAssigned,
    this.onTileClick,
    this.onAssignVendor,
    this.onRemoveVendor, {
    Key? key,
  }) : super(key: key);

  @override
  State<_VendorListTileWidget> createState() => _VendorListTileWidgetState();
}

class _VendorListTileWidgetState extends State<_VendorListTileWidget> {
  // var _isAssign = false.obs;
  void handleVendorToggleButton(bool value) {
    if (value) {
      showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
          "Assign ${widget.vendor.firstName} on this project?",
          () {
            widget.onAssignVendor(widget.vendor);
          },
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
            "Remove ${widget.vendor.firstName} from this project?",
            () => widget.onRemoveVendor(widget.vendor)),
      );
    }
  }

  @override
  void initState() {
    // _isAssign.value = widget.isAssigned;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("toggle button value: ${widget.isAssigned}");
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
          widget.vendor.businessDetailsList?[0].vendorCategory!.name ?? '',
          style: titleStyle,
        ),
      ),
      subtitle: _subtitleWidget(context),
      leading: _leadingWidget(context),
      // trailing: _trailingWidget(context),
      trailing: Switch.adaptive(
          value: widget.isAssigned,
          activeColor: Colors.green,
          onChanged: (value) {
            // _isAssign.value = newValue;
            // onAssignVendor(_isAssign.value);
            if (constants.connectionStatus.hasConnection) {
              handleVendorToggleButton(value);
            } else {
              Fluttertoast.showToast(msg: "No internet!");
            }
          }),
      // trailing: Obx(() {
      //   return Switch.adaptive(
      //     value: _isAssign.value,
      //     activeColor: Colors.green,
      //     onChanged: (bool newValue) {
      //       // _isAssign.value = newValue;
      //       // onAssignVendor(_isAssign.value);
      //       if (constants.connectionStatus.hasConnection) {
      //         handleVendorToggleButton(newValue);
      //       } else {
      //         Fluttertoast.showToast(msg: "No internet!");
      //       }
      //     },
      //   );
      // }),
      onTap: () {
        widget.onTileClick(widget.vendor);
      },
    );
  }

  Widget _subtitleWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.vendor.status == 1
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
                  const Text("Approval Pending!"),
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
                widget.vendor.shopAddress ?? '',
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

  // Widget _trailingWidget(BuildContext context) {
  Widget _leadingWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                UserCircularAvatar(
                  imgUrl: widget.vendor.imageUrl ?? '',
                  adjustment: BoxFit.fill,
                  height: 42,
                  width: 42,
                ),
                Expanded(
                  child: Text(
                    widget.vendor.firstName ?? '',
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: const TextStyle(
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 5,
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






// class ManageVendorsPage extends StatefulWidget {
//   final List<Vendor> assignedVendors;
//   final String title;
//   final AdminHomeController controller;
//   const ManageVendorsPage(
//     this.assignedVendors, {
//     Key? key,
//     required this.title,
//     required this.controller,
//   }) : super(key: key);

//   @override
//   _ManageVendorsPageState createState() => _ManageVendorsPageState();
// }

// class _ManageVendorsPageState extends State<ManageVendorsPage> {
//   //OntileClick
//   void onVendorTileClick(Vendor vendor) {
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) {
//           return VendorDetailPage(vendor);
//         },
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return Helper.slideRightToLeftTransition(child, animation);
//         },
//       ),
//     );
//   }

//   void onAssignClick(Vendor vendor) {
//     // print(newValue);
//     print("assign $vendor");
//   }

//   void onVendorRemove(Vendor vendor) {
//     print("remove $vendor");
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         centerTitle: true,
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           return widget.controller.refreshVendors();
//         },
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Column(
//             children: [
//               Obx(() {
//                 return widget.controller.totalVendors.isEmpty
//                     ? const Center(
//                         child: CircularProgressIndicator.adaptive(),
//                       )
//                     : _ShowVendorsListWidget(
//                         widget.controller.totalVendors,
//                         widget.assignedVendors,
//                         onVendorTileClick,
//                         onAssignClick,
//                         onVendorRemove,
//                       );
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }