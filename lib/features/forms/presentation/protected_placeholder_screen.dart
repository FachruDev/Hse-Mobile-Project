import 'package:flutter/material.dart';

import '../../../shared/layout/hse_app_scaffold.dart';

class ProtectedPlaceholderScreen extends StatelessWidget {
  const ProtectedPlaceholderScreen({
    required this.title,
    required this.description,
    required this.selectedPath,
    super.key,
  });

  final String title;
  final String description;
  final String selectedPath;

  @override
  Widget build(BuildContext context) {
    return HseAppScaffold(
      title: title,
      selectedPath: selectedPath,
      showBackButton: true,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(description),
            const SizedBox(height: 24),
            const LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
