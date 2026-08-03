import 'package:flutter/material.dart';

import '../../../../color_config.dart';

class IpalAndroidScrollbar extends StatelessWidget {
  const IpalAndroidScrollbar({
    required this.controller,
    required this.child,
    this.alwaysVisible = false,
    super.key,
  });

  final ScrollController controller;
  final Widget child;
  final bool alwaysVisible;

  @override
  Widget build(BuildContext context) {
    if (!alwaysVisible) {
      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: child,
      );
    }

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: Scrollbar(
        controller: controller,
        thumbVisibility: true,
        trackVisibility: true,
        interactive: false,
        radius: const Radius.circular(999),
        thickness: 6,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(right: BorderSide(color: AppColors.border)),
          ),
          child: child,
        ),
      ),
    );
  }
}
