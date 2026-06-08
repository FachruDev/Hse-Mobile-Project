import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../color_config.dart';
import '../../../shared/layout/hse_app_scaffold.dart';
import '../../auth/application/auth_session_controller.dart';
import '../../auth/domain/entities/app_user.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionControllerProvider).value;
    final user = session?.user;

    return HseAppScaffold(
      title: 'Dashboard',
      selectedPath: '/beranda',
      showDrawer: true,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DashboardHeader(user: user),
          const SizedBox(height: 16),
          const _QuickStatusGrid(),
          const SizedBox(height: 24),
          Text('Menu Form', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _ModuleTile(
            title: 'Catatan Proses IPAL',
            subtitle: 'Proses harian dan batch mixing.',
            icon: Icons.fact_check_outlined,
            enabled: user.hasAny(['ipal.logs.create', 'ipal.logs.submit']),
            onTap: () => context.push('/form/ipal/proses'),
          ),
          _ModuleTile(
            title: 'Checklist Pemeriksaan Harian',
            subtitle: 'Status unit dan catatan pemeriksaan.',
            icon: Icons.checklist_outlined,
            enabled: user.hasAny(['ipal.logs.create']),
            onTap: () => context.push('/form/ipal/checklist'),
          ),
          _ModuleTile(
            title: 'Penyimpanan Limbah B3',
            subtitle: 'Input log masuk atau keluar TPS LB3.',
            icon: Icons.inventory_2_outlined,
            enabled: user.hasAny(['b3storage.logs.create']),
            onTap: () => context.push('/form/b3'),
          ),
          const SizedBox(height: 12),
          Text('Laporan', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _ModuleTile(
            title: 'Laporan Bulanan B3',
            subtitle: 'Rekap dan approval bulanan penyimpanan limbah B3.',
            icon: Icons.assignment_outlined,
            enabled: user.hasAny(['b3storage.monthly-report.view']),
            onTap: () => context.push('/laporan/b3'),
          ),
        ],
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.user});

  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? 'Pengguna',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user?.department?.name ?? 'Departemen belum tersedia',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.white.withValues(alpha: 0.84),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.verified_user_outlined,
              color: AppColors.white,
              size: 34,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickStatusGrid extends StatelessWidget {
  const _QuickStatusGrid();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _StatusTile(
            label: 'Draft Lokal',
            value: '0',
            icon: Icons.edit_document,
            color: AppColors.warning,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatusTile(
            label: 'Antrean Submit',
            value: '0',
            icon: Icons.cloud_upload_outlined,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 10),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 2),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
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
      child: ListTile(
        minVerticalPadding: 16,
        enabled: enabled,
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: enabled
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: enabled ? theme.colorScheme.primary : null),
        ),
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
