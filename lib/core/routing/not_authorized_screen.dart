import 'package:flutter/material.dart';

import '../../shared/layout/hse_app_scaffold.dart';

class NotAuthorizedScreen extends StatelessWidget {
  const NotAuthorizedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HseAppScaffold(
      title: 'Akses Ditolak',
      showBackButton: true,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Akun Anda belum memiliki izin untuk membuka halaman ini.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
