import 'dart:io';
import 'package:arrant_construction_bo/src/models/project.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../helpers/app_constants.dart' as constants;

class CostEstimateDialog extends StatelessWidget {
  final Project project;
  final Function onSendEstimate;
  final Function? onCancel;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  late GlobalKey<FormState> _costFormKey = GlobalKey<FormState>();

  CostEstimateDialog(this.project, this.onSendEstimate,
      {Key? key, this.onCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                insetPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  // side: BorderSide(
                  //     color: Theme.of(context).primaryColor, width: 1.7),
                ),
                title: Center(
                  child: Text(
                    "Cost Estimate",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                content: Form(
                  key: _costFormKey,
                  child: _EstimationContent(
                    commentsController: _commentController,
                    costController: _priceController,
                    startDateController: _startDateController,
                    endDateController: _endDateController,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      // if ((_startDateController.text.length > 1) &&
                      //     (_endDateController.text.length > 1) &&
                      //     (_priceController.text.length > 1)) {
                      if (_costFormKey.currentState!.validate()) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        project.estimatedStartDate = _startDateController.text;
                        project.estimatedEndDate = _endDateController.text;
                        project.estimatedCost =
                            double.parse(_priceController.text);
                        project.backofficeComments = _commentController.text;
                        onSendEstimate(project);
                        Get.back();
                      } else {
                        Fluttertoast.showToast(msg: "Fields Required!");
                      }
                    },
                    child: Text(
                      "Send",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (onCancel == null) {
                        Get.back();
                      } else {
                        onCancel!();
                      }
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: SingleChildScrollView(
              child: CupertinoAlertDialog(
                title: Text(
                  "Cost Estimation",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                content: Form(
                  key: _costFormKey,
                  child: _EstimationContent(
                    commentsController: _commentController,
                    costController: _priceController,
                    startDateController: _startDateController,
                    endDateController: _endDateController,
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () async {
                      // if ((_startDateController.text.length > 1) &&
                      //     (_endDateController.text.length > 1) &&
                      //     (_priceController.text.length > 1)) {
                      if (_costFormKey.currentState!.validate()) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        project.estimatedStartDate = _startDateController.text;
                        project.estimatedEndDate = _endDateController.text;
                        project.estimatedCost =
                            double.parse(_priceController.text);
                        project.backofficeComments = _commentController.text;
                        onSendEstimate(project);
                        Get.back();
                      } else {
                        Fluttertoast.showToast(msg: "Fields Required!");
                      }
                    },
                    child: const Text("Save"),
                  ),
                  CupertinoDialogAction(
                    onPressed: () {
                      if (onCancel == null) {
                        Get.back();
                      } else {
                        onCancel!();
                      }
                    },
                    child: const Text("Cancel"),
                  ),
                ],
              ),
            ),
          );
  }
}

class _EstimationContent extends StatelessWidget {
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final TextEditingController costController;
  final TextEditingController commentsController;
  final DateFormat _dateFormatter = DateFormat(constants.dateStringFormat);
  _EstimationContent({
    Key? key,
    required this.commentsController,
    required this.costController,
    required this.startDateController,
    required this.endDateController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: startDateController,
          focusNode: AlwaysDisabledFocusNode(),
          // maxLines: null,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.datetime,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // onSaved: (input) => widget.project.estimatedStartDate = input,
          validator: (input) => input!.length < 1 ? "required" : null,
          readOnly: true,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
          onTap: () async {
            String selectedDate = await _handleDate(context, DateTime.now());
            startDateController.text = selectedDate;
          },
          decoration: InputDecoration(
            hintText: "Project Start Date",
            suffixIcon: Icon(
              Icons.calendar_today_outlined,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.015,
        ),
        TextFormField(
          controller: endDateController,
          focusNode: AlwaysDisabledFocusNode(),
          textAlign: TextAlign.start,
          keyboardType: TextInputType.datetime,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (input) => input!.length < 1 ? "required" : null,
          readOnly: true,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
          onTap: () async {
            String selectedDate = '';
            startDateController.text == ""
                ? Fluttertoast.showToast(
                    msg: "Select Project Start Date First !")
                : selectedDate = await _handleDate(
                    context, DateTime.parse(startDateController.text));
            endDateController.text = selectedDate;
          },
          decoration: InputDecoration(
            hintText: "Project End Date",
            suffixIcon: Icon(
              Icons.calendar_today_outlined,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.015,
        ),
        TextFormField(
          controller: costController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          // maxLines: null,
          cursorColor: Theme.of(context).primaryColor,
          // onSaved: (input) =>
          //     widget.project.estimatedCost = double.parse(input!),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (input) => input!.length < 1 ? "required" : null,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
          decoration: _costCommentDecoration(
            context,
            hintText: "Cost",
            suffixIcon: Icons.price_change_outlined,
            prefixText: " \$  ",
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.015,
        ),
        TextFormField(
          controller: commentsController,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLines: null,
          cursorColor: Theme.of(context).primaryColor,
          // onSaved: (input) => widget.project.backofficeComments = input,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
          decoration: _costCommentDecoration(
            context,
            hintText: "Comment",
            suffixIcon: Icons.comment_outlined,
          ),
        ),
      ],
    );
  }

  Future<String> _handleDate(BuildContext context, DateTime initialDate) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: initialDate.add(const Duration(days: 365)),
    );
    if (selectedDate != null) {
      return _dateFormatter.format(selectedDate);
    } else {
      return '';
    }
  }

  InputDecoration _costCommentDecoration(BuildContext context,
      {required String hintText,
      required IconData suffixIcon,
      String? prefixText}) {
    return InputDecoration(
      isDense: true,
      hintText: hintText,
      prefixText: prefixText ?? '',
      prefixStyle:
          TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
      suffixIcon: Icon(
        suffixIcon,
        size: 25,
        color: Theme.of(context).primaryColor,
      ),
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 12,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
