import 'package:arrant_construction_bo/src/models/vendor.dart';
import 'manage_project_vendors.dart';
import '../pages/manager_detail_page.dart';
import '../pages/managers_assign_page%20.dart';
import '../widgets/cost_estimate_dialog.dart';
import '../widgets/manager_list_tile.dart';
import '../../common/pages/project_comments.dart';
import '../../common/widgets/add_project_comment.dart';
import '../../common/widgets/comment_card.dart';
import '../../common/widgets/image_dialog.dart';
import '../../common/widgets/loading_card_widgets.dart';
import '../../common/widgets/project_list_tile.dart';
import '../../controllers/admin_home_controller.dart';
import '../../controllers/comments_controller.dart';
import '../../controllers/projects_controller.dart';
import '../../helpers/helper.dart';
import '../../models/project.dart';
import '../../models/project_comment.dart';
import '../../models/project_media_library.dart';
import '../../models/project_service.dart';
import '../../models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../helpers/app_constants.dart' as constants;

class ProjectDetails extends StatefulWidget {
  final Project project;
  final bool showManagerDetails;
  const ProjectDetails(
    this.project, {
    Key? key,
    this.showManagerDetails = true,
  }) : super(key: key);

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  final ProjectsController _con =
      Get.put(ProjectsController(), tag: constants.projectsConTag);
  final CommentsController _commentsController = CommentsController();
  final AdminHomeController _adminHomeController = Get.find();
  var projectManager = User.fromJSON({}).obs;
  var testingObsDispose = false.obs;

  void sendProjectEstimate(Project project) {
    project.status = 2;
    _con.sendProjectEstimate(context, project).then((value) {
      if (value) {
        Navigator.pop(context, value);
      }
    });
  }

  void onAssignManagerClick() async {
    User assignedManger = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ManagersAssignPage(
            _adminHomeController.totalManagers,
            projectId: widget.project.id ?? '',
            controller: _adminHomeController,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Helper.slideRightToLeftTransition(child, animation);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
    if (assignedManger.name != null && assignedManger.name!.isNotEmpty) {
      projectManager.value = assignedManger;
    } else {
      print("received manager is null");
    }
  }

  void onManageVendorClick() {
    FocusScope.of(context).requestFocus(FocusNode());
    // go to Manage Vendor page

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ManageProjectVendors(
            widget.project.id ?? '',
            _adminHomeController.totalVendors,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Helper.bottomToTopTransition(child, animation);
        },
      ),
    );
  }

  void onManagerClick(User manager) {
    if (widget.showManagerDetails) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return ManagerDetailPage(
              manager,
              isShowdetailPage: false,
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Helper.slideRightToLeftTransition(child, animation);
          },
        ),
      );
    }
  }

  void addComment(ProjectComment _comment) {
    _comment.isVisibleToManager = 1;
    _comment.senderType = 4;
    _comment.projectId = widget.project.id;
    _commentsController.addProjectComment(_comment);
  }

  void onViewAllCommentsClicked() {
    FocusScope.of(context).requestFocus(FocusNode());
    // go to comments page
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ProjectComments(widget.project.id!, _commentsController);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Helper.bottomToTopTransition(child, animation);
        },
        // transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // initialise assigned vendors
    print("Project Vendors Length: ${widget.project.projectVendors.length}");
    _con.assignedVendors.addAll(
        _con.getVendorsFromProjectVendors(widget.project.projectVendors));
    print(_con.assignedVendors.length);
    // get project comments
    _commentsController.getProjectComments(
      widget.project.id ?? '',
    );
    projectManager.value = widget.project.manager!;
  }

  @override
  void dispose() {
    // disposing rx resources
    projectManager.close();
    Get.delete<ProjectsController>(tag: constants.projectsConTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizedBox mainAxisPadding = SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name!),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mainAxisPadding,
              _projectImagesCarousel(),
              mainAxisPadding,
              ProjectListTileWidget(
                widget.project,
                () {},
                isShowForward: false,
              ),
              mainAxisPadding,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  widget.project.description!,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              mainAxisPadding,
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                child:
                    _ProjectServicesTable(widget.project.addedProjectServices),
              ),
              mainAxisPadding,
              widget.project.status == 1
                  ? Align(
                      alignment: Alignment.center,
                      child: _costEstimateButton(),
                    )
                  : const SizedBox(),
              mainAxisPadding,
              widget.project.status! > 1
                  ? _EstimationTile(widget.project)
                  : const SizedBox(),
              widget.project.status == 3
                  ? Column(
                      children: [
                        mainAxisPadding,
                        // widget.project.managerId == null ||
                        //         widget.project.managerId!.isEmpty
                        //     ? Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Flexible(
                        //             fit: FlexFit.tight,
                        //             child: _assignTile(
                        //               "Manage Vendors",
                        //               onTap: onManageVendorClick,
                        //               leadingIcon: FontAwesomeIcons.users,
                        //             ),
                        //           ),
                        //           Flexible(
                        //             fit: FlexFit.tight,
                        //             child: _assignTile(
                        //               "Assign Manager",
                        //               onTap: onAssignManagerClick,
                        //               leadingIcon: FontAwesomeIcons.user,
                        //             ),
                        //           ),
                        //         ],
                        //       )
                        //     : Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.only(
                        //               left: 10,
                        //               bottom: 10,
                        //             ),
                        //             child: Text(
                        //               "Manager: ",
                        //               style: TextStyle(
                        //                 fontWeight: FontWeight.bold,
                        //               ),
                        //             ),
                        //           ),
                        //           ManagerListTileWidget(
                        //             widget.project.manager!,
                        //             onManagerClick,
                        //           ),
                        //           const SizedBox(
                        //             height: 10,
                        //           ),
                        //           _assignTile(
                        //             "Manage Vendors",
                        //             onTap: onManageVendorClick,
                        //             leadingIcon: FontAwesomeIcons.users,
                        //           ),
                        //         ],
                        //       ),
                        Obx(() {
                          return projectManager.value.name!.isEmpty
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: _assignTile(
                                        "Manage Vendors",
                                        onTap: onManageVendorClick,
                                        leadingIcon: FontAwesomeIcons.users,
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: _assignTile(
                                        "Assign Manager",
                                        onTap: onAssignManagerClick,
                                        leadingIcon: FontAwesomeIcons.user,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        "Manager: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    ManagerListTileWidget(
                                      projectManager.value,
                                      onManagerClick,
                                      isShowdetailPage:
                                          widget.showManagerDetails,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    _assignTile(
                                      "Manage Vendors",
                                      onTap: onManageVendorClick,
                                      leadingIcon: FontAwesomeIcons.users,
                                    ),
                                  ],
                                );
                        }),
                        mainAxisPadding,
                        mainAxisPadding,
                        Obx(() {
                          const int numberOfCommentsOnMainPage = 2;
                          return _commentsController.projectComments.isEmpty &&
                                  _commentsController
                                      .doneFetchingProjectComments.value
                              ? const Center(child: Text("No comments"))
                              : _commentsController.projectComments.isEmpty &&
                                      !_commentsController
                                          .doneFetchingProjectComments.value
                                  ? LoadingCardWidget(
                                      cardCount: 2,
                                      width: MediaQuery.of(context).size.width *
                                          0.90,
                                      adjustment: BoxFit.fill,
                                    )
                                  : _CommentWidget(
                                      _commentsController.projectComments
                                          .take(numberOfCommentsOnMainPage)
                                          .toList(),
                                      onViewAllCommentsClicked,
                                      // addComment,
                                      _commentsController
                                          .projectComments.length,
                                    );
                        }),
                      ],
                    )
                  : const SizedBox(),
              widget.project.status == 3
                  ? AddProjectCommentWidget(addComment)
                  : const SizedBox(),
              mainAxisPadding,
            ],
          ),
        ),
      ),
    );
  }

  Widget _assignTile(String title,
      {required Function onTap, required IconData leadingIcon}) {
    List<String> titleList = title.split(' ');
    String firstTitleWord = titleList[0];
    String lastTitleWord = titleList[titleList.length - 1];
    TextStyle titleStyle = TextStyle(
      fontSize: 12,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: ListTile(
        title: Text(
          firstTitleWord,
          style: titleStyle,
        ),
        subtitle: Text(
          lastTitleWord,
          style: titleStyle,
        ),
        leading: Icon(
          leadingIcon,
          color: Colors.black,
        ),
        trailing: const Icon(
          FontAwesomeIcons.longArrowAltRight,
          color: Colors.black,
        ),
        tileColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        // contentPadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.symmetric(horizontal: 5),
        horizontalTitleGap: 0.0,
        onTap: () {
          onTap();
        },
      ),
    );
    // return Card(
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 20),
    //     child: Row(
    //       children: [
    //         Expanded(child: Icon(FontAwesomeIcons.user)),
    //         Expanded(
    //           child: Text(
    //             title,
    //             style: TextStyle(fontSize: 13),
    //           ),
    //         ),
    //         Expanded(child: Icon(FontAwesomeIcons.longArrowAltRight))
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _costEstimateButton() {
    return TextButton(
      onPressed: () {
        // sendCostEstimate(widget.project);
        Get.dialog(
          CostEstimateDialog(
            widget.project,
            sendProjectEstimate,
          ),
        );
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 30.0),
        ),
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).primaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
      ),
      child: const Text(
        "Send Estimate",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _projectImagesCarousel() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: widget.project.mediaLibraryFiles.isNotEmpty
          ? CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.25,
                // height: 200,
                autoPlay: true,
                enableInfiniteScroll: false,
              ),
              items: widget.project.mediaLibraryFiles
                  .map((ProjectMediaLibrary mediaItem) {
                return GestureDetector(
                  onTap: () {
                    Get.dialog(
                      ImageDialogWidget(
                        mediaItem.url!,
                        width: MediaQuery.of(context).size.width * 0.90,
                      ),
                    );
                  },
                  child: _ProjectImageBuilder(mediaItem.url!),
                );
              }).toList(),
            )
          : Container(
              height: MediaQuery.of(context).size.height * 0.25,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: const Center(
                  child: Icon(
                Icons.image,
              )),
            ),
    );
  }
}

class _CommentWidget extends StatelessWidget {
  final List<ProjectComment> comments;
  final int totalComments;
  final Function onViewAllClicked;
  // final Function addComment;
  // final int numberOfCommentsOnMainPage;
  final double borderRadius = 15.0;
  const _CommentWidget(
    this.comments,
    this.onViewAllClicked,
    // this.addComment,
    this.totalComments, {
    Key? key,
    // this.numberOfCommentsOnMainPage = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, -2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _commentHeading(),
              const Spacer(),
              _viewAllButton(),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          _commentsList(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _commentsList() {
    return ListView.builder(
      itemCount: comments.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CommentCardWidget(comments[index]),
        );
      },
    );
  }

  Widget _viewAllButton() {
    return TextButton(
      onPressed: () {
        onViewAllClicked();
      },
      child: const Text("View All"),
    );
  }

  Widget _commentHeading() {
    return Text(
      "Comments ($totalComments)",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _EstimationTile extends StatelessWidget {
  final Project project;
  const _EstimationTile(this.project, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle titleSubTitleStyle = const TextStyle(
      // same as title
      color: Colors.black,
      fontSize: 16,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Estimate:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ExpansionTile(
          initiallyExpanded: true,
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          // expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.topLeft,
          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              project.estimatedStartDate!,
              style: titleSubTitleStyle,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              project.estimatedEndDate!,
              style: titleSubTitleStyle,
            ),
          ),
          leading: _leadingColumn(context),
          // leading: _leadingColumn(),
          trailing: Helper.of(context).getPriceRichText(
            project.estimatedCost!,
            size: 15,
          ),
          children: _expandedColumnWidgetsList(),
        ),
      ],
    );
  }

  List<Widget> _expandedColumnWidgetsList() {
    return [
      const Text(
        "Comment:",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        project.backofficeComments!,
      ),
    ];
  }

  Widget _leadingColumn(BuildContext context) {
    const double containerRadius = 8.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: containerRadius,
          width: containerRadius,
          decoration: BoxDecoration(
            // color: Colors.red,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.green,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.027,
            child: const VerticalDivider(
              // width: 2,
              thickness: 1,
              color: Colors.grey,
            ),
          ),
        ),
        Container(
          height: containerRadius,
          width: containerRadius,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

class _ProjectServicesTable extends StatelessWidget {
  final List<ProjectService> projectServices;
  final double mainRowChildrenVerticalPadding = 5.0;
  List<TableRow> allRows = [];
  _ProjectServicesTable(this.projectServices, {Key? key}) : super(key: key) {
    TextStyle mainRowHeadingStyle = const TextStyle(
      fontWeight: FontWeight.bold,
    );
    TableRow firstRow = TableRow(
      decoration: const BoxDecoration(),
      children: [
        Center(
          child: Padding(
            padding:
                EdgeInsets.symmetric(vertical: mainRowChildrenVerticalPadding),
            child: Text(
              "Service",
              style: mainRowHeadingStyle,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding:
                EdgeInsets.symmetric(vertical: mainRowChildrenVerticalPadding),
            child: Text(
              "Area(m${constants.squareSC})",
              style: mainRowHeadingStyle,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding:
                EdgeInsets.symmetric(vertical: mainRowChildrenVerticalPadding),
            child: Text(
              "Description",
              style: mainRowHeadingStyle,
            ),
          ),
        ),
      ],
    );
    allRows.add(firstRow);
  }

  @override
  Widget build(BuildContext context) {
    // adding all other rows dynamic values to the list
    allRows.addAll(projectServices.map((ProjectService _service) {
      // print("service description");
      // print(_service.description);
      return _servicesTableRow(_service);
    }));
    // print(allRows.length);
    return Table(
      border: TableBorder.all(
        color: Theme.of(context).primaryColor,
      ),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(2)
      },
      children: allRows,
    );
  }

  TableRow _servicesTableRow(ProjectService s) {
    const double verticalPadding = 5.0;
    const double horizontalPadding = 5.0;
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          child: Text(
            s.service?.name ?? '',
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          child: Text(
            s.areaInSqM.toString(),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: verticalPadding,
              horizontal: horizontalPadding,
            ),
            child: Text(
              s.description ?? 'N/A',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProjectImageBuilder extends StatelessWidget {
  final String url;
  const _ProjectImageBuilder(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "${constants.storageBaseUrl}$url",
      imageBuilder: (context, imageProvider) {
        return _imageBuilder(context, imageProvider);
      },
      placeholder: (context, url) {
        return _placeHolder();
      },
      errorWidget: (context, error, d) {
        return _errorWidget();
      },
    );
  }

  Widget _imageBuilder(
      BuildContext context, ImageProvider<Object> imageProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fill,
          )),
    );
  }

  Widget _placeHolder() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
          // color: Colors.grey,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          image: DecorationImage(
            image: AssetImage("assets/img/loading.gif"),
            fit: BoxFit.cover,
          )),
    );
  }

  Widget _errorWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: const Center(
          child: Icon(
        Icons.image,
      )),
    );
  }
}
