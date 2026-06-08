import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/application/auth_session_controller.dart';
import '../../auth/domain/entities/app_user.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionControllerProvider).value;
    final user = session?.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('HSE Mobile'),
        actions: [
          IconButton(
            tooltip: 'Keluar',
            onPressed: () =>
                ref.read(authSessionControllerProvider.notifier).logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Selamat datang, ${user?.name ?? 'Pengguna'}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(user?.department?.name ?? 'Departemen belum tersedia'),
          const SizedBox(height: 24),
          _ModuleTile(
            title: 'Form IPAL',
            subtitle: 'Checklist unit, catatan proses, dan batch mixing.',
            icon: Icons.water_drop_outlined,
            enabled: user.hasAny(['ipal.logs.create', 'ipal.logs.submit']),
            onTap: () => context.go('/form/ipal'),
          ),
          _ModuleTile(
            title: 'Penyimpanan Limbah B3',
            subtitle: 'Input log masuk atau keluar TPS LB3.',
            icon: Icons.inventory_2_outlined,
            enabled: user.hasAny(['b3storage.logs.create']),
            onTap: () => context.go('/form/b3'),
          ),
          _ModuleTile(
            title: 'Laporan Bulanan B3',
            subtitle: 'Rekap dan approval bulanan penyimpanan limbah B3.',
            icon: Icons.assignment_outlined,
            enabled: user.hasAny(['b3storage.monthly-report.view']),
            onTap: () => context.go('/laporan/b3'),
          ),
        ],
      ),
    );
  }
}

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        enabled: enabled,
        leading: Icon(icon, color: enabled ? theme.colorScheme.primary : null),
        title: Text(title),
        subtitle: Text(
          enabled ? subtitle : 'Akses belum tersedia untuk akun ini.',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: enabled ? onTap : null,
      ),
    );
  }
}

extension on AppUser? {
  bool hasAny(Iterable<String> permissions) {
    final user = this;
    return user != null && user.hasAnyPermission(permissions);
  }
}
