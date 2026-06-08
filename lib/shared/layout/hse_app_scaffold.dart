import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../color_config.dart';
import 'hse_app_drawer.dart';

class HseAppScaffold extends StatelessWidget {
  const HseAppScaffold({
    required this.title,
    required this.body,
    this.selectedPath,
    this.actions,
    this.showDrawer = false,
    this.showBackButton = false,
    super.key,
  });

  final String title;
  final Widget body;
  final String? selectedPath;
  final List<Widget>? actions;
  final bool showDrawer;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: showDrawer
          ? HseAppDrawer(selectedPath: selectedPath ?? '/beranda')
          : null,
      appBar: AppBar(
        title: Text(title),
        leading: showBackButton
            ? IconButton(
                tooltip: 'Kembali',
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                    return;
                  }
                  context.go('/beranda');
                },
              )
            : null,
        actions: actions,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(color: AppColors.background),
        child: SafeArea(child: body),
      ),
    );
  }
}
