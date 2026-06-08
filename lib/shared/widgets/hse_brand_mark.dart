import 'package:flutter/material.dart';

import '../../color_config.dart';

class HseBrandMark extends StatelessWidget {
  const HseBrandMark({
    this.size = 48,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = AppColors.white,
    super.key,
  });

  final double size;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.health_and_safety_outlined,
        color: foregroundColor,
        size: size * 0.58,
      ),
    );
  }
}
