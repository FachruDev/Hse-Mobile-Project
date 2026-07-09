import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../color_config.dart';
import '../../../../shared/utils/api_response_parser.dart';
import '../../../../shared/utils/hse_datetime_formatter.dart';
import '../../application/ipal_log_controller.dart';

class IpalTodayLogGuard extends ConsumerWidget {
  const IpalTodayLogGuard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayLogState = ref.watch(ipalTodayLogProvider);

    return todayLogState.when(
      data: (log) {
        if (log == null) return child;
        return _ExistingLogView(log: log);
      },
      error: (_, _) => child,
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ExistingLogView extends StatelessWidget {
  const _ExistingLogView({required this.log});

  final Map<String, dynamic> log;

  @override
  Widget build(BuildContext context) {
    final status = textValue(pathValue(log, ['process_log', 'status']));
    final id = int.tryParse(textValue(log['id'], fallback: ''));
    final operatorName = textValue(
      pathValue(log, ['operator', 'name']),
      fallback: 'Operator',
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.warningPastel,
                      child: Icon(
                        Icons.lock_clock_outlined,
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Log IPAL hari ini sudah ada',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    _StatusChip(status: status),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Tanggal ${HseDateTimeFormatter.date(log['tanggal'])} sudah pernah diisi oleh $operatorName. Pengisian ulang tidak tersedia dari aplikasi mobile.',
                ),
                const SizedBox(height: 18),
                if (id != null)
                  FilledButton.icon(
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text('Lihat Detail'),
                    onPressed: () => context.push('/riwayat/ipal/$id'),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'APPROVED' => AppColors.success,
      'SUBMITTED' => AppColors.primary,
      'DRAFT' => AppColors.warning,
      _ => AppColors.textSecondary,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          status,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
