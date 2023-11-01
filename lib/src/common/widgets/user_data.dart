import 'dart:io';
import 'package:arrant_construction_bo/src/common/dialogs/general_image_view_dialog.dart';
import 'package:arrant_construction_bo/src/common/widgets/image_dialog.dart';
import 'package:arrant_construction_bo/src/common/widgets/user_circular_avatar.dart';
import 'package:arrant_construction_bo/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserData extends StatelessWidget {
  final User user;
  final Function updateImage;
  late File _imageFile;
  var imageName = "".obs;
  final ImagePicker _picker = ImagePicker();

  UserData({
    Key? key,
    required this.user,
    required this.updateImage,
  }) : super(key: key);

  void _selectImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 60);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      imageName.value = _imageFile.path.split('/').last;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Obx(() {
              print(user.imageUrl);
              return imageName.value.isEmpty
                  ? GestureDetector(
                      onTap: () {
                        if (user.imageUrl!.isNotEmpty) {
                          Get.dialog(
                            ImageDialogWidget(
                              user.imageUrl!,
                            ),
                          );
                        }
                      },
                      child: UserCircularAvatar(
                        imgUrl: user.imageUrl!,
                        height: 120.0,
                        width: 100.0,
                        adjustment: BoxFit.fill,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        ImageProvider profileImage = FileImage(_imageFile);
                        Get.dialog(
                          GeneralImageViewDialog(
                            profileImage,
                          ),
                        );
                      },
                      child: Container(
                        height: 120.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: FileImage(_imageFile),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    );
            }),
            Positioned(
                top: 75,
                left: 60,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).primaryColor),
                  child: Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.add_a_photo_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _selectImage();
                      },
                    ),
                  ),
                )),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.015),
        Obx(() {
          return imageName.value.isNotEmpty
              ? _saveCancelButton(context)
              : const SizedBox();
        }),
      ],
    );
  }

  Widget _saveCancelButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            if (imageName.value.isNotEmpty) {
              updateImage(_imageFile);
              imageName.value = "";
            }
          },
          child: Text(
            "Save",
            style: TextStyle(
              color: imageName.value.isNotEmpty
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (imageName.value.isNotEmpty) {
              imageName.value = ""; // reset file value
            }
          },
          child: Text(
            "Cancel",
            style: TextStyle(
              color: imageName.value.isNotEmpty
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
