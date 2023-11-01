import 'dart:async';
import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatefulWidget {
  final double? height;
  const CustomCircularProgressIndicator({Key? key, this.height})
      : super(key: key);
  @override
  _CustomCircularProgressIndicatorState createState() =>
      _CustomCircularProgressIndicatorState();
}

class _CustomCircularProgressIndicatorState
    extends State<CustomCircularProgressIndicator>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    animationController = AnimationController(vsync: this);
    CurvedAnimation curve =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation = Tween<double>(begin: widget.height, end: 0).animate(curve)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    Timer(const Duration(seconds: 500), () {
      if (mounted) {
        animationController.forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    Timer(const Duration(seconds: 30), () {
      if (mounted) {
        animationController.dispose();
      }
    });
    // animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: animation.value / 100 > 1.0 ? 1.0 : animation.value / 100,
      child: SizedBox(
        height: animation.value,
        child: Center(
          child: CircularProgressIndicator.adaptive(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            backgroundColor: Colors.white,
            strokeWidth: 4.5,
          ),
        ),
      ),
    );
  }
}
