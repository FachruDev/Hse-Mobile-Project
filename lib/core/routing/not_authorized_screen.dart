import 'package:flutter/material.dart';

class NotAuthorizedScreen extends StatelessWidget {
  const NotAuthorizedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Akses Ditolak')),
      body: const Center(
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
