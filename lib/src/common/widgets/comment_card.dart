import 'package:arrant_construction_bo/src/common/widgets/cached_network_image_builder.dart';
import 'package:arrant_construction_bo/src/common/dialogs/general_image_view_dialog.dart';
import 'package:arrant_construction_bo/src/common/widgets/user_circular_avatar.dart';
import 'package:arrant_construction_bo/src/models/project_comment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../helpers/app_constants.dart' as constants;

class CommentCardWidget extends StatelessWidget {
  final ProjectComment comment;
  const CommentCardWidget(this.comment, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(comment.imageUrl);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _senderInfoTile(),
          const SizedBox(
            height: 5.0,
          ),
          // comment.imageUrl != null && comment.imageUrl!.isNotEmpty
          //     ? _ShowCommentImageWidget(comment.imageUrl!)
          //     : const SizedBox(),
          Text("${comment.text}"),
          const SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "${comment.date} ${comment.time}",
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _senderInfoTile() {
    return ListTile(
      horizontalTitleGap: 10.0,
      contentPadding: EdgeInsets.zero,
      title: Text(comment.senderName ?? ''),
      leading: UserCircularAvatar(
        imgUrl: comment.senderImageUrl ?? '',
        height: 40,
        width: 40,
        adjustment: BoxFit.fill,
        hasBorder: false,
      ),
      trailing: comment.imageUrl != null && comment.imageUrl!.isNotEmpty
          ? _ShowCommentImageWidget(
              comment.imageUrl!,
              adjustment: BoxFit.cover,
            )
          : const SizedBox(),
    );
  }
}

class _ShowCommentImageWidget extends StatelessWidget {
  final String imageUrl;
  // final Function? onImageTap;
  final double height;
  final double width;
  final BoxFit adjustment;

  const _ShowCommentImageWidget(
    this.imageUrl, {
    Key? key,
    // this.onImageTap,
    this.adjustment = BoxFit.fill,
    this.height = 100,
    this.width = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "${constants.storageBaseUrl}$imageUrl",
      imageBuilder: (context, imageProvider) {
        return GestureDetector(
          onTap: () {
            Get.dialog(
              GeneralImageViewDialog(
                imageProvider,
                blurBackground: false,
                isTransparentBackground: false,
              ),
            );
          },
          child: CachedNetworkGeneralImageBuilder(
            imageProvider,
            false,
            height: height,
            width: width,
            adjustment: adjustment,
          ),
        );
      },
      placeholder: (context, url) {
        ImageProvider image = const AssetImage("assets/img/loading.gif");
        return CachedNetworkGeneralImageBuilder(
          image,
          false,
          height: height,
          width: width,
          adjustment: adjustment,
        );
      },
      errorWidget: (context, url, error) {
        ImageProvider image =
            const AssetImage("assets/img/image_placeholder.png");
        return CachedNetworkGeneralImageBuilder(
          image,
          true,
          height: height,
          width: width,
          adjustment: adjustment,
        );
      },
    );
  }

  // Widget _displayImage()
}
