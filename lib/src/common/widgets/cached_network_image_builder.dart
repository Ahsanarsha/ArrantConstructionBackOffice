import 'package:flutter/material.dart';

class CachedNetworkGeneralImageBuilder extends StatelessWidget {
  final ImageProvider image;
  final bool isErroneous;
  final BoxFit adjustment;
  double? height;
  double? width;
  CachedNetworkGeneralImageBuilder(
    this.image,
    this.isErroneous, {
    Key? key,
    this.adjustment = BoxFit.fill,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    height = height ?? MediaQuery.of(context).size.height * 0.50;
    width = width ?? MediaQuery.of(context).size.width * 0.50;
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: isErroneous ? Colors.white : Colors.transparent,
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        image: DecorationImage(
          image: image,
          fit: adjustment,
        ),
      ),
    );
  }
}
