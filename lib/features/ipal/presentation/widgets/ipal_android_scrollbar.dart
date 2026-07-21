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
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: Scrollbar(
        controller: controller,
        thumbVisibility: alwaysVisible,
        trackVisibility: alwaysVisible,
        interactive: true,
        radius: const Radius.circular(999),
        thickness: alwaysVisible ? 6 : 4,
        child: DecoratedBox(
          decoration: alwaysVisible
              ? const BoxDecoration(
                  border: Border(right: BorderSide(color: AppColors.border)),
                )
              : const BoxDecoration(),
          child: child,
        ),
      ),
    );
  }
}
