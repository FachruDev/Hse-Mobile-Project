import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../color_config.dart';
import '../../../core/permissions/app_permissions.dart';
import '../../../core/storage/submit_queue_service.dart';
import '../../../shared/layout/hse_app_scaffold.dart';
import '../../auth/application/auth_session_controller.dart';
import '../../auth/domain/entities/app_user.dart';
import '../../b3/data/b3_storage_repository.dart';
import '../../ipal/data/ipal_checklist_repository_impl.dart';
import '../../ipal/data/ipal_process_repository_impl.dart';
import '../../sync/application/submit_queue_controller.dart';

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
            enabled: user.hasAll([
              AppPermissions.masterProcessView,
              AppPermissions.masterBatchView,
              AppPermissions.ipalLogsCreate,
            ]),
            onTap: () => context.push('/form/ipal/proses'),
          ),
          _ModuleTile(
            title: 'Checklist Pemeriksaan Harian',
            subtitle: 'Status unit dan catatan pemeriksaan.',
            icon: Icons.checklist_outlined,
            enabled: user.hasAll([
              AppPermissions.masterChecklistView,
              AppPermissions.ipalLogsCreate,
            ]),
            onTap: () => context.push('/form/ipal/checklist'),
          ),
          _ModuleTile(
            title: 'Penyimpanan Limbah B3',
            subtitle: 'Input log masuk atau keluar TPS LB3.',
            icon: Icons.inventory_2_outlined,
            enabled: user.hasAll([
              AppPermissions.b3StorageMasterView,
              AppPermissions.b3StorageLogsCreate,
            ]),
            onTap: () => context.push('/form/b3'),
          ),
          const SizedBox(height: 12),
          Text('Riwayat', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _ModuleTile(
            title: 'Riwayat IPAL',
            subtitle: 'Daftar log IPAL bulanan dan detail approval.',
            icon: Icons.history_outlined,
            enabled: user.hasAll([AppPermissions.ipalLogsView]),
            onTap: () => context.push('/riwayat/ipal'),
          ),
          _ModuleTile(
            title: 'Riwayat B3',
            subtitle: 'Daftar log penyimpanan limbah B3.',
            icon: Icons.receipt_long_outlined,
            enabled: user.hasAll([AppPermissions.b3StorageLogsView]),
            onTap: () => context.push('/riwayat/b3'),
          ),
          const SizedBox(height: 12),
          Text('Laporan', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _ModuleTile(
            title: 'Laporan Bulanan B3',
            subtitle: 'Rekap dan approval bulanan penyimpanan limbah B3.',
            icon: Icons.assignment_outlined,
            enabled: user.hasAll([AppPermissions.b3StorageMonthlyReportView]),
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

class _QuickStatusGrid extends ConsumerWidget {
  const _QuickStatusGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftCount = [
      ref.watch(ipalProcessRepositoryProvider).readDraft(),
      ref.watch(ipalChecklistRepositoryProvider).readDraft(),
      ref.watch(b3StorageRepositoryProvider).readDraft(),
    ].where((draft) => draft != null).length;
    final queueCount = ref
        .watch(submitQueueServiceProvider)
        .pendingItems()
        .length;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatusTile(
                label: 'Draft Lokal',
                value: draftCount.toString(),
                icon: Icons.edit_document,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatusTile(
                label: 'Antrean Submit',
                value: queueCount.toString(),
                icon: Icons.cloud_upload_outlined,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        if (queueCount > 0) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.sync),
              label: const Text('Kirim Ulang Antrean'),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final count = await ref
                    .read(submitQueueProcessorProvider)
                    .retryPending();
                messenger.showSnackBar(
                  SnackBar(content: Text('$count antrean berhasil dikirim.')),
                );
              },
            ),
          ),
        ],
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
  bool hasAll(Iterable<String> permissions) {
    final user = this;
    return user != null && user.canAll(permissions);
  }
}
