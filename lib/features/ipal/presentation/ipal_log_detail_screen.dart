import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../color_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/permissions/app_permissions.dart';
import '../../../shared/layout/hse_app_scaffold.dart';
import '../../../shared/pdf/hse_pdf_builders.dart';
import '../../../shared/pdf/hse_pdf_exporter.dart';
import '../../../shared/utils/api_response_parser.dart';
import '../../../shared/utils/hse_datetime_formatter.dart';
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
                FilledButton.icon(
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  label: const Text('Export PDF'),
                  onPressed: () => _exportPdf(context, data),
                ),
                const SizedBox(height: 12),
                _ChecklistSection(data: data),
                _ProcessSection(data: data),
                _BatchSection(data: data),
                _ApprovalSection(data: data),
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

  Future<void> _exportPdf(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    try {
      await HsePdfExporter.preview(
        fileName: 'catatan-ipal-harian-$logId.pdf',
        build: (logoBytes) =>
            HsePdfBuilders.ipalDailyDetail(data, logoBytes: logoBytes),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF gagal dibuat: $error'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
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
      ref.invalidate(ipalTodayLogProvider);
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
    final processLog = _map(pathValue(data, ['process_log']));
    final status = textValue(processLog['status'], fallback: 'DRAFT');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.infoPastel,
                  child: Icon(Icons.water_drop_outlined, color: AppColors.info),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        HseDateTimeFormatter.date(data['tanggal']),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Operator: ${textValue(pathValue(data, ['operator', 'name']))}',
                      ),
                    ],
                  ),
                ),
                _StatusChip(status: status),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistSection extends StatelessWidget {
  const _ChecklistSection({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final values = _list(pathValue(data, ['checklist', 'values']));
    return _SectionCard(
      title: 'Checklist Harian',
      empty: values.isEmpty,
      emptyText: 'Tidak ada data checklist.',
      children: [
        for (final value in values)
          _DetailTile(
            title: textValue(pathValue(value, ['item', 'name'])),
            rows: [
              _InfoPair(
                'Kondisi standar',
                textValue(pathValue(value, ['item', 'standard_condition'])),
              ),
              _InfoPair('Status', _checklistStatusLabel(value['status'])),
              _InfoPair('Catatan', textValue(value['note'])),
              _InfoPair('Lampiran', _attachmentLabel(value)),
            ],
          ),
      ],
    );
  }
}

class _ProcessSection extends StatelessWidget {
  const _ProcessSection({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final values = _list(pathValue(data, ['process_log', 'values']));
    return _SectionCard(
      title: 'Catatan Proses',
      empty: values.isEmpty,
      emptyText: 'Tidak ada data catatan proses.',
      children: [
        for (final value in values)
          _DetailTile(
            title: textValue(pathValue(value, ['item', 'name'])),
            subtitle: textValue(
              pathValue(value, ['item', 'section', 'name']),
              fallback: 'Catatan Proses IPAL',
            ),
            rows: [
              _InfoPair(
                'Kondisi standar',
                textValue(pathValue(value, ['item', 'standard_condition'])),
              ),
              _InfoPair('Kondisi aktual', _actualValue(value)),
              _InfoPair('Keterangan', textValue(value['note'])),
              _InfoPair('Foto', _attachmentLabel(value)),
            ],
          ),
      ],
    );
  }
}

class _BatchSection extends StatelessWidget {
  const _BatchSection({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final batches = _list(pathValue(data, ['process_log', 'batches']));
    return _SectionCard(
      title: 'Batch Mixing',
      empty: batches.isEmpty,
      emptyText: 'Tidak ada data batch mixing.',
      children: [
        for (final batch in batches)
          _DetailTile(
            title: 'Batch ${textValue(batch['batch_no'])}',
            rows: [
              for (final value in _list(batch['values']))
                _InfoPair(
                  textValue(pathValue(value, ['item', 'name'])),
                  _actualValue(value),
                ),
            ],
          ),
      ],
    );
  }
}

class _ApprovalSection extends StatelessWidget {
  const _ApprovalSection({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final approval = _map(pathValue(data, ['process_log', 'approval']));
    return _SectionCard(
      title: 'Approval Harian',
      empty: approval.isEmpty,
      emptyText: 'Approval belum tersedia.',
      children: [
        _InfoRow(
          label: 'Operator',
          value: textValue(pathValue(approval, ['operator', 'name'])),
        ),
        _InfoRow(
          label: 'Tanda tangan operator',
          value: HseDateTimeFormatter.dateTime(approval['operator_signed_at']),
        ),
        _InfoRow(
          label: 'Supervisor',
          value: textValue(pathValue(approval, ['supervisor', 'name'])),
        ),
        _InfoRow(
          label: 'Tanda tangan supervisor',
          value: HseDateTimeFormatter.dateTime(
            approval['supervisor_signed_at'],
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.empty,
    required this.emptyText,
    required this.children,
  });

  final String title;
  final bool empty;
  final String emptyText;
  final List<Widget> children;

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
            const SizedBox(height: 12),
            if (empty)
              Text(emptyText, style: Theme.of(context).textTheme.bodySmall)
            else
              ...children,
          ],
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({required this.title, required this.rows, this.subtitle});

  final String title;
  final String? subtitle;
  final List<_InfoPair> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
          ],
          const SizedBox(height: 10),
          for (final row in rows) _InfoRow(label: row.label, value: row.value),
        ],
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
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 132,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _InfoPair {
  const _InfoPair(this.label, this.value);

  final String label;
  final String value;
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

String _actualValue(Map<String, dynamic> value) {
  final number = textValue(value['value_number'], fallback: '');
  if (number.isNotEmpty) return number;

  return textValue(value['value_text']);
}

String _checklistStatusLabel(Object? status) {
  return switch (textValue(status, fallback: '')) {
    'OK' => 'Ya',
    'NOT_OK' => 'Tidak',
    'NA' => 'N/A',
    _ => 'Belum diisi',
  };
}

String _attachmentLabel(Map<String, dynamic> value) {
  if (value['attachment'] != null || value['attachments'] != null) {
    return 'Ada lampiran';
  }

  return '-';
}

Map<String, dynamic> _map(Object? value) {
  if (value is Map) return Map<String, dynamic>.from(value);
  return const <String, dynamic>{};
}

List<Map<String, dynamic>> _list(Object? value) {
  if (value is! List) return const <Map<String, dynamic>>[];
  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList(growable: false);
}
