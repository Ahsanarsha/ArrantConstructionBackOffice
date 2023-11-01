import 'dart:io';

import 'package:arrant_construction_bo/src/helpers/helper.dart';
import 'package:arrant_construction_bo/src/models/project_comment.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../helpers/app_constants.dart' as constants;

class AddProjectCommentWidget extends StatelessWidget {
  final ProjectComment _projectComment = ProjectComment();
  final Function onCommentAdd;
  final TextEditingController _commentController = TextEditingController();
  var hasText = false.obs;
  var _isShowToClientGroupValue = 0.obs;
  var _isShowToVendorGroupValue = 0.obs;
  var vendorValue = 1.obs;
  var clientValue = 0.obs;

  final ImagePicker _imagePicker = ImagePicker();
  final _selectedImagePath = "".obs;
  AddProjectCommentWidget(this.onCommentAdd, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return _selectedImagePath.value.isNotEmpty
                ? _imageContainer()
                : const SizedBox();
          }),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: _addImageIcon(context),
              ),
              Expanded(
                flex: 6,
                child: _writeCommentTextField(context),
              ),
              Expanded(
                flex: 1,
                child: _sendIcon(context),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Text(
              "Visible to :",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text("Client"),
                      Obx(() {
                        return Checkbox(
                          activeColor: Theme.of(context).primaryColor,
                          value: _isShowToClientGroupValue.value == 0
                              ? false
                              : true,
                          onChanged: (bool? value) {
                            _isShowToClientGroupValue.value = value! ? 1 : 0;
                            _projectComment.isVisibleToClient =
                                _isShowToClientGroupValue.value;
                          },
                        );
                      }),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Text("Vendor"),
                      Obx(() {
                        return Checkbox(
                          activeColor: Theme.of(context).primaryColor,
                          value: _isShowToVendorGroupValue.value == 0
                              ? false
                              : true,
                          onChanged: (bool? value) {
                            _isShowToVendorGroupValue.value = value! ? 1 : 0;
                            _projectComment.isVisibleToVendor =
                                _isShowToVendorGroupValue.value;
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageContainer() {
    return Container(
      height: 80,
      width: 80,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image: FileImage(
            File(_selectedImagePath.value),
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
              right: -12,
              top: -12,
              child: IconButton(
                onPressed: () {
                  _selectedImagePath.value = "";
                  hasText.value =
                      _commentController.text.isEmpty ? false : true;
                },
                icon: Icon(
                  Icons.cancel,
                  color: Colors.red[800],
                ),
              ))
        ],
      ),
    );
  }

  Widget _writeCommentTextField(BuildContext context) {
    return TextField(
      controller: _commentController,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      maxLines: null,
      cursorColor: Theme.of(context).primaryColor,
      style: const TextStyle(
        fontWeight: FontWeight.normal,
      ),
      onChanged: (value) {
        // check if value is not empty
        // not contains only new lines and whitespaces
        hasText.value = (value.isEmpty &&
                value.trim() == "" &&
                Helper.trimNewLine(value) == "" &&
                _selectedImagePath.value.isEmpty)
            ? false
            : true;
      },
      decoration: InputDecoration(
        isDense: true,
        // filled: true,
        // fillColor: Colors.white,
        hintText: "write comment",

        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  Widget _addImageIcon(BuildContext context) {
    return IconButton(
        splashRadius: 20,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        onPressed: () async {
          if (_selectedImagePath.value.isEmpty) {
            XFile? image =
                await _imagePicker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              _selectedImagePath.value = image.path;
              hasText.value = true;
            }
          }
        },
        icon: Obx(() {
          return Icon(
            Icons.add_a_photo,
            color: _selectedImagePath.value.isEmpty
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColor.withOpacity(0.5),
            size: 20,
          );
        }));
  }

  Widget _sendIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: IconButton(
        splashRadius: 20.0,
        onPressed: () {
          // check if connection is available
          // check if hasText is true
          // send message
          // clear message box
          // hasText to false
          if (constants.connectionStatus.hasConnection) {
            if (hasText.value || _selectedImagePath.value.isNotEmpty) {
              FocusScope.of(context).requestFocus(FocusNode());
              _projectComment.text = _commentController.text;
              _projectComment.imageFile = _selectedImagePath.value.isNotEmpty
                  ? File(_selectedImagePath.value)
                  : null;
              _projectComment.isVisibleToClient =
                  _isShowToClientGroupValue.value;
              _projectComment.isVisibleToVendor =
                  _isShowToVendorGroupValue.value;
              // calling function to add comment
              onCommentAdd(_projectComment);
              // resetting fields
              _commentController.text = "";
              hasText.value = false;
              _selectedImagePath.value = "";
              _isShowToClientGroupValue.value = 0;
              _isShowToVendorGroupValue.value = 0;
            }
          } else {
            Fluttertoast.showToast(msg: "No internet connection");
          }
        },
        icon: Obx(() {
          return Icon(
            Icons.send,
            size: 20.0,
            color: hasText.value
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColor.withOpacity(0.5),
          );
        }),
      ),
    );
  }
}
