import 'dart:ui';

import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  GlassContainer({
    required this.width,
    required this.height,
    required this.margin,
    required this.padding,
    this.opacity = 0.2,
    this.radius = 0,
    BorderRadius? borderRadius,
    this.blur = 20,
    required this.child,
  }) {
    this.borderRadius = borderRadius ?? BorderRadius.circular(radius);
  }

  final double width;
  final double height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double opacity;
  final double radius;
  late BorderRadius borderRadius;
  final double blur;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            spreadRadius: 16,
            color: Colors.black.withOpacity(0.2),
          )
        ],
      ),
      // ぼかす範囲をContainerの背後のみにする
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          // 背景をぼかす
          filter: ImageFilter.blur(
            sigmaX: blur,
            sigmaY: blur,
          ),
          child: Container(
            height: height,
            width: width,
            margin: margin,
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(opacity),
              borderRadius: borderRadius,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
