import 'package:flutter/material.dart';
import 'package:easy_place_picker/src/widgets/rounded_frame.dart';

class FloatingCard extends StatelessWidget {
  const FloatingCard({
    super.key,
    this.topPosition,
    this.leftPosition,
    this.rightPosition,
    this.bottomPosition,
    this.width,
    this.height,
    this.borderRadius = BorderRadius.zero,
    this.elevation = 0.0,
    this.color,
    this.child,
  });

  final double? topPosition;
  final double? leftPosition;
  final double? bottomPosition;
  final double? rightPosition;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final double elevation;
  final Color? color;
  final Widget? child;

  @override
  Widget build(final BuildContext context) {
    return Positioned(
      top: topPosition,
      left: leftPosition,
      right: rightPosition,
      bottom: bottomPosition,
      child: RoundedFrame(
        width: width,
        height: height,
        borderRadius: borderRadius,
        elevation: elevation,
        color: color,
        child: child,
      ),
    );
  }
}
