import 'dart:ui';
import 'package:flutter/material.dart';

class GeneralImageViewDialog extends StatelessWidget {
  final ImageProvider image;
  final bool isTransparentBackground;
  final bool blurBackground;
  const GeneralImageViewDialog(
    this.image, {
    Key? key,
    this.isTransparentBackground = true,
    this.blurBackground = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double backgroundBlurValue = blurBackground ? 1.0 : 0.0;
    return BackdropFilter(
      filter: ImageFilter.blur(
          sigmaX: backgroundBlurValue, sigmaY: backgroundBlurValue),
      child: Dialog(
        backgroundColor:
            isTransparentBackground ? Colors.transparent : Colors.white,
        insetPadding: EdgeInsets.zero,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.50,
          width: MediaQuery.of(context).size.width * 0.80,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
            image: DecorationImage(
              image: image,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
