import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../color_config.dart';
import '../../../core/storage/submit_queue_service.dart';
import '../../../shared/layout/hse_app_scaffold.dart';
import '../../../shared/utils/hse_datetime_formatter.dart';
import '../../../shared/widgets/hse_confirm_dialog.dart';
import '../application/submit_queue_controller.dart';

class SubmitQueueScreen extends ConsumerStatefulWidget {
  const SubmitQueueScreen({super.key});

  @override
  ConsumerState<SubmitQueueScreen> createState() => _SubmitQueueScreenState();
}

class _SubmitQueueScreenState extends ConsumerState<SubmitQueueScreen> {
  final _retryingIds = <String>{};

  @override
  void initState() {
    super.initState();
    unawaited(ref.read(submitQueueServiceProvider).unlockAll());
  }

  @override
  Widget build(BuildContext context) {
    final queueState = ref.watch(submitQueueItemsProvider);

    return HseAppScaffold(
      title: 'Antrean Submit',
      selectedPath: '/antrean-submit',
      showDrawer: true,
      body: queueState.when(
        data: (items) {
          if (items.isEmpty) return const _EmptyQueueState();

          return RefreshIndicator(
            onRefresh: () async {},
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _QueueCard(
                item: items[index],
                retrying: _retryingIds.contains(items[index].id),
                onRetry: () => _retry(items[index].id),
                onEdit: () => _edit(items[index]),
                onDelete: () => _delete(items[index]),
              ),
            ),
          );
        },
        error: (error, _) => _ErrorState(message: error.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _retry(String id) async {
    setState(() => _retryingIds.add(id));
    final messenger = ScaffoldMessenger.of(context);

    try {
      final success = await ref
          .read(submitQueueProcessorProvider)
          .retryItem(id);
      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Antrean berhasil dikirim.'
                : 'Antrean belum berhasil dikirim.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _retryingIds.remove(id));
      }
    }
  }

  Future<void> _edit(SubmitQueueItem item) async {
    if (item.endpoint == '/b3-storage/logs') {
      context.push('/antrean-submit/b3/${item.id}/edit');
      return;
    }

    if (item.endpoint != '/ipal/logs') return;

    final target = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.checklist_outlined),
              title: const Text('Edit Checklist IPAL'),
              subtitle: Text(_dateLabel(item)),
              onTap: () => Navigator.of(context).pop('checklist'),
            ),
            ListTile(
              leading: const Icon(Icons.fact_check_outlined),
              title: const Text('Edit Proses dan Batch Mixing'),
              subtitle: Text(_dateLabel(item)),
              onTap: () => Navigator.of(context).pop('process'),
            ),
          ],
        ),
      ),
    );

    if (!mounted || target == null) return;
    context.push('/antrean-submit/ipal/${item.id}/$target/edit');
  }

  Future<void> _delete(SubmitQueueItem item) async {
    final confirmed = await showHseConfirmDialog(
      context: context,
      title: 'Hapus Antrean?',
      message:
          '${_moduleLabel(item)} tanggal ${_dateLabel(item)} akan dibatalkan permanen dari antrean submit.',
      confirmLabel: 'Hapus',
      destructive: true,
    );
    if (!confirmed) return;

    await ref.read(submitQueueServiceProvider).deleteItem(item.id);
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Antrean dihapus.')));
  }
}

class _QueueCard extends StatelessWidget {
  const _QueueCard({
    required this.item,
    required this.retrying,
    required this.onRetry,
    required this.onEdit,
    required this.onDelete,
  });

  final SubmitQueueItem item;
  final bool retrying;
  final VoidCallback onRetry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final statusColor = item.status == SubmitQueueStatus.failed.name
        ? AppColors.danger
        : AppColors.warning;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: statusColor.withValues(alpha: 0.12),
                  child: Icon(_iconFor(item), color: statusColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _moduleLabel(item),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _dateLabel(item),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                _StatusChip(item: item),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(
                  icon: Icons.schedule_outlined,
                  label:
                      'Dibuat ${DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(item.createdAt)}',
                ),
                _InfoChip(
                  icon: Icons.refresh,
                  label: 'Percobaan ${item.attempts}',
                ),
                if (item.locked)
                  const _InfoChip(
                    icon: Icons.lock_outline,
                    label: 'Sedang diedit',
                  ),
              ],
            ),
            if (item.lastError?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Text(
                item.lastError!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.danger),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: retrying || item.locked ? null : onRetry,
                    icon: retrying
                        ? const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.cloud_upload_outlined),
                    label: const Text('Kirim Ulang'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: 'Edit',
                  onPressed: retrying || item.locked ? null : onEdit,
                  icon: const Icon(Icons.edit_outlined),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: 'Hapus',
                  onPressed: retrying || item.locked ? null : onDelete,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.item});

  final SubmitQueueItem item;

  @override
  Widget build(BuildContext context) {
    final failed = item.status == SubmitQueueStatus.failed.name;
    final color = failed ? AppColors.danger : AppColors.warning;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          failed ? 'Gagal sementara' : 'Menunggu koneksi',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(label, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _EmptyQueueState extends StatelessWidget {
  const _EmptyQueueState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_done_outlined, size: 48, color: AppColors.success),
            SizedBox(height: 12),
            Text('Tidak ada antrean submit.', textAlign: TextAlign.center),
            SizedBox(height: 6),
            Text(
              'Data yang sudah terkirim akan muncul di riwayat IPAL/B3.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}

String _moduleLabel(SubmitQueueItem item) {
  if (item.moduleLabel?.isNotEmpty == true) return item.moduleLabel!;

  return switch (item.endpoint) {
    '/ipal/logs' => 'Log IPAL',
    '/b3-storage/logs' => 'Log B3',
    _ => item.endpoint,
  };
}

String _dateLabel(SubmitQueueItem item) {
  final date =
      item.displayDate ??
      item.payload['tanggal']?.toString() ??
      item.payload['movement_date']?.toString() ??
      '';

  if (date.isEmpty) return '-';

  return HseDateTimeFormatter.date(date);
}

IconData _iconFor(SubmitQueueItem item) {
  return switch (item.endpoint) {
    '/ipal/logs' => Icons.water_drop_outlined,
    '/b3-storage/logs' => Icons.inventory_2_outlined,
    _ => Icons.cloud_upload_outlined,
  };
}
