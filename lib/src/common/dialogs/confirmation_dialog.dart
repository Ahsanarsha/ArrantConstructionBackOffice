import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final String? content;
  final Function onConfirmMethod;
  final Function? onCancel;
  const ConfirmationDialog(this.message, this.onConfirmMethod,
      {Key? key, this.content, this.onCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? AlertDialog(
            title: Text(message),
            content: Text(content ?? ""),
            actions: [
              TextButton(
                onPressed: () async {
                  onConfirmMethod();
                  Get.back();
                },
                child: Text(
                  "Yes",
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
                  "No",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          )
        : CupertinoAlertDialog(
            title: Text(message),
            content: Text(
              content ?? "",
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  onConfirmMethod();
                  Get.back();
                },
                child: const Text("Yes"),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  if (onCancel == null) {
                    Get.back();
                  } else {
                    onCancel!();
                  }
                },
                child: const Text("No"),
              ),
            ],
          );
  }
}
