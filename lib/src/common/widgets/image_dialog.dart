import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../helpers/app_constants.dart' as constants;

class ImageDialogWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final String imgUrl;
  final bool blurBackground;
  final double defaultHeightPercent = 0.50;
  final double defaultWidthPercent = 0.80;
  const ImageDialogWidget(
    this.imgUrl, {
    Key? key,
    this.height,
    this.width,
    this.blurBackground = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double backgroundBlurValue = blurBackground ? 1.0 : 0.0;
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: backgroundBlurValue,
        sigmaY: backgroundBlurValue,
      ),
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        // backgroundColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.transparent,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.all(
        //     Radius.circular(10),
        //   ),
        // ),
        child: CachedNetworkImage(
          imageUrl: '${constants.storageBaseUrl}$imgUrl',
          imageBuilder: (context, imageProvider) {
            return _imageBuilder(context, imageProvider);
          },
          placeholder: (context, url) {
            return _placeHolder(context);
          },
          errorWidget: (context, error, d) {
            //print(error.toString());
            //print(d.toString());
            return _errorWidget(context);
          },
        ),
      ),
    );
  }

  Widget _imageBuilder(BuildContext context, ImageProvider imageProvider) {
    return Container(
      height:
          height ?? MediaQuery.of(context).size.height * defaultHeightPercent,
      width: width ?? MediaQuery.of(context).size.width * defaultWidthPercent,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _placeHolder(BuildContext context) {
    return Container(
      height:
          height ?? MediaQuery.of(context).size.height * defaultHeightPercent,
      width: width ?? MediaQuery.of(context).size.width * defaultWidthPercent,
      decoration: const BoxDecoration(
        // borderRadius: BorderRadius.circular(5),
        // shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage("assets/img/loading.gif"),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _errorWidget(BuildContext context) {
    return Container(
      height:
          height ?? MediaQuery.of(context).size.height * defaultHeightPercent,
      width: width ?? MediaQuery.of(context).size.width * defaultWidthPercent,
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
