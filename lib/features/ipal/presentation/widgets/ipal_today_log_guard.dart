import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../color_config.dart';
import '../../../../shared/utils/api_response_parser.dart';
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

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lock_clock_outlined,
                  color: AppColors.warning,
                  size: 36,
                ),
                const SizedBox(height: 14),
                Text(
                  'Log IPAL hari ini sudah ada',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tanggal ${textValue(log['tanggal'])} sudah pernah diisi untuk akun ini. Pengisian ulang tidak tersedia dari aplikasi mobile.',
                ),
                const SizedBox(height: 12),
                Text('Status: $status'),
                const SizedBox(height: 18),
                if (id != null)
                  FilledButton.icon(
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text('Lihat Riwayat'),
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
