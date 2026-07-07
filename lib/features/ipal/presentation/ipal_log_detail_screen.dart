import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../color_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/permissions/app_permissions.dart';
import '../../../shared/layout/hse_app_scaffold.dart';
import '../../../shared/utils/api_response_parser.dart';
import '../../auth/application/auth_session_controller.dart';
import '../application/ipal_log_controller.dart';
import '../data/ipal_log_repository.dart';

class IpalLogDetailScreen extends ConsumerWidget {
  const IpalLogDetailScreen({required this.logId, super.key});

  final int logId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(ipalLogDetailProvider(logId));
    final user = ref.watch(authSessionControllerProvider).value?.user;

    return HseAppScaffold(
      title: 'Detail IPAL',
      showBackButton: true,
      body: detail.when(
        data: (response) {
          final data = apiDataMap(response);
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(ipalLogDetailProvider(logId)),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _HeaderCard(data: data),
                const SizedBox(height: 12),
                _SectionCard(
                  title: 'Checklist Harian',
                  value: data['checklist'],
                ),
                _SectionCard(
                  title: 'Catatan Proses',
                  value: data['process_log'],
                ),
                _SectionCard(
                  title: 'Batch Mixing',
                  value: pathValue(data, ['process_log', 'batches']),
                ),
                _SectionCard(
                  title: 'Approval Harian',
                  value: pathValue(data, ['process_log', 'approval']),
                ),
                const SizedBox(height: 12),
                if (user?.hasPermission(AppPermissions.ipalLogsSubmit) ?? false)
                  FilledButton.icon(
                    icon: const Icon(Icons.upload_outlined),
                    label: const Text('Submit Log'),
                    onPressed: () => _runAction(
                      context,
                      ref,
                      () =>
                          ref.read(ipalLogRepositoryProvider).submitLog(logId),
                    ),
                  ),
                if (user?.hasPermission(AppPermissions.ipalLogsApprove) ??
                    false)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.verified_outlined),
                      label: const Text('Approve Log'),
                      onPressed: () => _runAction(
                        context,
                        ref,
                        () => ref
                            .read(ipalLogRepositoryProvider)
                            .approveLog(logId),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _runAction(
    BuildContext context,
    WidgetRef ref,
    Future<Map<String, dynamic>> Function() action,
  ) async {
    try {
      final response = await action();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            textValue(response['message'], fallback: 'Aksi berhasil.'),
          ),
        ),
      );
      ref.invalidate(ipalLogDetailProvider(logId));
    } on ApiException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final status = textValue(pathValue(data, ['process_log', 'status']));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              textValue(data['tanggal']),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Operator: ${textValue(pathValue(data, ['operator', 'name']))}',
            ),
            const SizedBox(height: 8),
            Text('Status: $status'),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.value});

  final String title;
  final Object? value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Text(
              _prettyValue(value),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

String _prettyValue(Object? value) {
  if (value == null) return 'Belum ada data.';
  if (value is List && value.isEmpty) return 'Belum ada data.';
  if (value is Map && value.isEmpty) return 'Belum ada data.';
  return value.toString();
}
