import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../color_config.dart';
import '../../../core/storage/submit_queue_service.dart';
import '../../../shared/layout/hse_app_scaffold.dart';
import '../../../shared/navigation/mobile_menu.dart';
import '../../../shared/widgets/hse_confirm_dialog.dart';
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
    final sections = visibleMobileMenuSections(user);

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
          for (final section in sections) ...[
            Text(section.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            for (final item in section.items)
              _ModuleTile(
                title: item.title,
                subtitle: item.subtitle,
                icon: item.icon,
                onTap: () => context.push(item.path),
              ),
            const SizedBox(height: 12),
          ],
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
                final confirmed = await showHseConfirmDialog(
                  context: context,
                  title: 'Kirim Ulang Antrean',
                  message:
                      'Semua antrean submit akan dicoba dikirim ulang. Lanjutkan?',
                  confirmLabel: 'Kirim Ulang',
                );
                if (!confirmed || !context.mounted) return;

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
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        minVerticalPadding: 16,
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primaryPastel,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
