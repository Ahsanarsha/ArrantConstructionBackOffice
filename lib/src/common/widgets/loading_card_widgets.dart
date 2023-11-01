import 'package:flutter/material.dart';

class LoadingCardWidget extends StatelessWidget {
  final int cardCount;
  final double height;
  final double width;
  final BoxFit adjustment;
  final Axis scrollDirection;
  const LoadingCardWidget({
    Key? key,
    this.cardCount = 1,
    this.height = 150,
    this.width = 200,
    this.adjustment = BoxFit.contain,
    this.scrollDirection = Axis.vertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: scrollDirection,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cardCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
                image: DecorationImage(
                  image: const AssetImage("assets/img/loading.gif"),
                  fit: adjustment,
                )),
          ),
        );
      },
    );
  }
}
