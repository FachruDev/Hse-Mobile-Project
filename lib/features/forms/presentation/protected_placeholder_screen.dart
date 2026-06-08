import 'package:flutter/material.dart';

class ProtectedPlaceholderScreen extends StatelessWidget {
  const ProtectedPlaceholderScreen({
    required this.title,
    required this.description,
    super.key,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(description),
            const SizedBox(height: 24),
            const Text(
              'Implementasi detail akan memakai master data API, cache lokal, draft form, dan submit queue yang sudah disiapkan di fondasi aplikasi.',
            ),
          ],
        ),
      ),
    );
  }
}
