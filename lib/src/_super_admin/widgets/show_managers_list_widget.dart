import 'package:arrant_construction_bo/src/_super_admin/widgets/manager_list_tile.dart';
import 'package:arrant_construction_bo/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ShowManagersListWidget extends StatelessWidget {
  final List<User> managers;
  final Function onTap;
  const ShowManagersListWidget(this.managers, this.onTap, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: managers.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ManagerListTileWidget(
            managers[index],
            onTap,
          ),
        );
      },
    );
  }
}
