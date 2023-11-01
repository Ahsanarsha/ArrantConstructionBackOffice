import 'package:arrant_construction_bo/src/common/widgets/project_list_tile.dart';
import 'package:arrant_construction_bo/src/models/project.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ShowProjectsListWidget extends StatelessWidget {
  final List<Project> projects;
  final Function onTap;
  final bool isShowForward;
  const ShowProjectsListWidget(this.projects, this.onTap,
      {Key? key, this.isShowForward = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: projects.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ProjectListTileWidget(
            projects[index],
            onTap,
            isShowForward: isShowForward,
          ),
        );
      },
    );
  }
}
