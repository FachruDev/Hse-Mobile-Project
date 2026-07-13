import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../color_config.dart';
import '../../../../core/storage/submit_queue_service.dart';
import '../../application/submit_queue_controller.dart';

class SubmitQueueStatusBanner extends ConsumerStatefulWidget {
  const SubmitQueueStatusBanner({
    super.key,
    this.endpoints,
    this.compact = false,
  });

  final Set<String>? endpoints;
  final bool compact;

  @override
  ConsumerState<SubmitQueueStatusBanner> createState() =>
      _SubmitQueueStatusBannerState();
}

class _SubmitQueueStatusBannerState
    extends ConsumerState<SubmitQueueStatusBanner> {
  bool _retrying = false;

  @override
  Widget build(BuildContext context) {
    final queueState = ref.watch(submitQueueItemsProvider);
    final items = _filterItems(queueState.value ?? const []);

    if (items.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final failedCount = items
        .where((item) => item.status == SubmitQueueStatus.failed.name)
        .length;

    return Card(
      color: AppColors.warningPastel,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.cloud_sync_outlined, color: AppColors.warning),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${items.length} form menunggu jaringan',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        failedCount > 0
                            ? '$failedCount antrean sempat gagal dan akan dicoba lagi saat server bisa dijangkau.'
                            : 'Data sudah aman di perangkat dan akan dikirim otomatis saat koneksi/server tersedia.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _retrying ? null : _retryPending,
              icon: _retrying
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.sync),
              label: Text(_retrying ? 'Mengirim...' : 'Kirim Ulang Sekarang'),
            ),
            if (!widget.compact) ...[
              const SizedBox(height: 8),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(top: 4),
                title: Text(
                  'Detail Antrean',
                  style: theme.textTheme.labelLarge,
                ),
                children: [
                  for (final item in items)
                    _QueueItemTile(item: item, label: _labelFor(item.endpoint)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<SubmitQueueItem> _filterItems(List<SubmitQueueItem> items) {
    final endpoints = widget.endpoints;
    if (endpoints == null || endpoints.isEmpty) return items;

    return items
        .where((item) => endpoints.contains(item.endpoint))
        .toList(growable: false);
  }

  Future<void> _retryPending() async {
    setState(() => _retrying = true);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final count = await ref.read(submitQueueProcessorProvider).retryPending();
      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(content: Text('$count antrean berhasil dikirim.')),
      );
    } finally {
      if (mounted) {
        setState(() => _retrying = false);
      }
    }
  }

  String _labelFor(String endpoint) {
    return switch (endpoint) {
      '/ipal/logs' => 'Log IPAL',
      '/b3-storage/logs' => 'Log B3',
      _ => endpoint,
    };
  }
}

class _QueueItemTile extends StatelessWidget {
  const _QueueItemTile({required this.item, required this.label});

  final SubmitQueueItem item;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusLabel = item.status == SubmitQueueStatus.failed.name
        ? 'Gagal sementara'
        : 'Menunggu kirim';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.status == SubmitQueueStatus.failed.name
                ? Icons.error_outline
                : Icons.schedule_send_outlined,
            color: item.status == SubmitQueueStatus.failed.name
                ? AppColors.danger
                : AppColors.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelLarge),
                const SizedBox(height: 2),
                Text(
                  '$statusLabel - percobaan ${item.attempts}',
                  style: theme.textTheme.bodySmall,
                ),
                if (item.lastError?.isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.lastError!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.danger,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
