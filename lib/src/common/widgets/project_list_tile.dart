import 'package:arrant_construction_bo/src/common/widgets/user_circular_avatar.dart';
import 'package:arrant_construction_bo/src/models/project.dart';
import 'package:flutter/material.dart';

class ProjectListTileWidget extends StatelessWidget {
  final Project project;
  final Function onClick;
  final bool isShowForward;
  const ProjectListTileWidget(
    this.project,
    this.onClick, {
    Key? key,
    this.isShowForward = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).primaryColor,
    );
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(left: 3.0),
        child: Text(
          project.name!,
          style: titleStyle,
        ),
      ),
      subtitle: _subtitleWidget(context),
      leading: _leadingWidget(context),
      trailing: isShowForward ? _trailingWidget(context) : const SizedBox(),
      tileColor: Colors.white,
      minVerticalPadding: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      isThreeLine: true,
      onTap: () {
        onClick(project);
      },
    );
  }

  Widget _subtitleWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 3,
            ),
            Icon(
              Icons.calendar_today_outlined,
              size: 14,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(
              width: 3,
            ),
            Text(project.requestDate!),
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
                project.location!,
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
                  imgUrl: project.client!.imageUrl!,
                  adjustment: BoxFit.fill,
                  height: 42,
                  width: 42,
                ),
                Expanded(
                  child: Text(
                    project.client!.name!,
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
