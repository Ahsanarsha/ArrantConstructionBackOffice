import 'package:arrant_construction_bo/src/models/project_comment.dart';
import 'package:arrant_construction_bo/src/repositories/comments_repo.dart'
    as comments_repo;
import 'package:get/get.dart';

class CommentsController {
  // project comment variables
  var projectComments = <ProjectComment>[].obs;

  // project comment fetching progress variables
  var doneFetchingProjectComments = false.obs;

  // Error string
  final String errorString = "Comments Controller Error: ";

  Future<void> addProjectComment(ProjectComment projectComment) async {
    await comments_repo
        .addProjectComment(projectComment)
        .then((ProjectComment _c) {
          print(_c.time);
          if (_c.text!.isNotEmpty) {
            projectComments.insert(0, _c);
          }
        })
        .onError((error, stackTrace) {})
        .whenComplete(() {});
  }

  Future<void> getProjectComments(String projectId,
      {int skip = 0, int take = 10}) async {
    doneFetchingProjectComments.value = false;
    Stream<ProjectComment> stream = await comments_repo
        .getProjectComment(projectId, skip: skip, take: take);
    stream.listen((ProjectComment _comment) {
      projectComments.add(_comment);
    }, onError: (e) {
      print("$errorString $e");
    }, onDone: () {
      doneFetchingProjectComments.value = true;
    });
  }

  Future<void> refreshProjectComments(String projectId) async {
    projectComments.clear();
    await getProjectComments(projectId);
  }
}
