import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../color_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/permissions/app_permissions.dart';
import '../../../shared/layout/hse_app_scaffold.dart';
import '../../../shared/utils/api_response_parser.dart';
import '../../auth/application/auth_session_controller.dart';
import '../application/b3_storage_log_controller.dart';
import '../data/b3_storage_repository.dart';

class B3LogDetailScreen extends ConsumerWidget {
  const B3LogDetailScreen({required this.logId, super.key});

  final int logId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(b3StorageLogDetailProvider(logId));
    final user = ref.watch(authSessionControllerProvider).value?.user;

    return HseAppScaffold(
      title: 'Detail B3',
      showBackButton: true,
      body: detail.when(
        data: (response) {
          final data = apiDataMap(response);
          return RefreshIndicator(
            onRefresh: () async =>
                ref.invalidate(b3StorageLogDetailProvider(logId)),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _DetailCard(data: data),
                const SizedBox(height: 12),
                _PhotoSection(
                  logId: logId,
                  photoPath: textValue(data['photo_path'], fallback: ''),
                ),
                const SizedBox(height: 16),
                if (user?.hasPermission(AppPermissions.b3StorageLogsDelete) ??
                    false)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Hapus Log'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                    ),
                    onPressed: () => _delete(context, ref),
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

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Log B3'),
        content: const Text('Log yang dihapus tidak bisa dikembalikan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(b3StorageRepositoryProvider).deleteLog(logId);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Log B3 berhasil dihapus.')));
      context.go('/riwayat/b3');
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

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final wasteName = textValue(
      pathValue(data, ['waste_type', 'name']),
      fallback: textValue(data['waste_type_other']),
    );
    final departmentName = textValue(
      pathValue(data, ['initiator_department', 'name']),
      fallback: textValue(data['initiator_department_other']),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(wasteName, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _InfoRow(label: 'Tanggal', value: textValue(data['movement_date'])),
            _InfoRow(label: 'Jam', value: textValue(data['movement_time'])),
            _InfoRow(label: 'Tipe', value: textValue(data['movement_type'])),
            _InfoRow(
              label: 'Berat',
              value: '${textValue(data['weight_kg'])} kg',
            ),
            _InfoRow(
              label: 'Dokumen',
              value: textValue(data['document_number']),
            ),
            _InfoRow(label: 'Dept Inisiator', value: departmentName),
            _InfoRow(
              label: 'Operator',
              value: textValue(pathValue(data, ['operator', 'name'])),
            ),
            _InfoRow(label: 'Catatan', value: textValue(data['note'])),
          ],
        ),
      ),
    );
  }
}

class _PhotoSection extends ConsumerWidget {
  const _PhotoSection({required this.logId, required this.photoPath});

  final int logId;
  final String photoPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (photoPath.isEmpty) {
      return const _InfoRow(label: 'Foto', value: '-');
    }

    final photo = ref.watch(b3StorageLogPhotoProvider(logId));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Foto Serah Terima',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            photo.when(
              data: (bytes) => ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  bytes,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              error: (error, _) => Text(
                'Foto belum bisa dimuat. Path: $photoPath',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              loading: () => const LinearProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 126,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
