import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../color_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/permissions/app_permissions.dart';
import '../../../shared/layout/hse_app_scaffold.dart';
import '../../../shared/utils/api_response_parser.dart';
import '../../auth/application/auth_session_controller.dart';
import '../application/b3_report_controller.dart';
import '../data/b3_report_repository.dart';

class B3MonthlyReportScreen extends ConsumerStatefulWidget {
  const B3MonthlyReportScreen({super.key});

  @override
  ConsumerState<B3MonthlyReportScreen> createState() =>
      _B3MonthlyReportScreenState();
}

class _B3MonthlyReportScreenState extends ConsumerState<B3MonthlyReportScreen> {
  late DateTime _period;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _period = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final report = ref.watch(
      b3MonthlyReportProvider(month: _period.month, year: _period.year),
    );
    final user = ref.watch(authSessionControllerProvider).value?.user;
    final canApprove =
        user?.hasPermission(AppPermissions.b3StorageMonthlyApprovalApprove) ??
        false;

    return HseAppScaffold(
      title: 'Laporan Bulanan B3',
      selectedPath: '/laporan/b3',
      showDrawer: true,
      actions: [
        IconButton(
          tooltip: 'Muat ulang',
          icon: const Icon(Icons.refresh),
          onPressed: () => ref.invalidate(
            b3MonthlyReportProvider(month: _period.month, year: _period.year),
          ),
        ),
      ],
      body: Column(
        children: [
          _PeriodBar(
            period: _period,
            onChanged: (value) => setState(() => _period = value),
          ),
          Expanded(
            child: report.when(
              data: (response) {
                final data = apiDataMap(response);
                final rows = (data['rows'] as List?) ?? const [];
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _SummaryCard(data: data, rowCount: rows.length),
                    const SizedBox(height: 12),
                    _ApprovalCard(data: data),
                    const SizedBox(height: 12),
                    if (rows.isEmpty)
                      const _EmptyState(
                        message: 'Data laporan bulan ini belum ada.',
                      )
                    else
                      ...rows.whereType<Map>().map(
                        (row) =>
                            _ReportRow(row: Map<String, dynamic>.from(row)),
                      ),
                    if (canApprove) ...[
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        icon: const Icon(Icons.supervisor_account_outlined),
                        label: const Text('Approve Environment Supervisor'),
                        onPressed: () =>
                            _approve(context, ref, 'ENVIRONMENT_SUPERVISOR'),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.verified_outlined),
                        label: const Text('Approve HSE Dept Head'),
                        onPressed: () =>
                            _approve(context, ref, 'HSE_DEPARTMENT_HEAD'),
                      ),
                    ],
                  ],
                );
              },
              error: (error, _) => _EmptyState(message: error.toString()),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _approve(
    BuildContext context,
    WidgetRef ref,
    String role,
  ) async {
    final noteController = TextEditingController();
    final note = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Catatan Approval'),
        content: TextField(
          controller: noteController,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'Catatan optional'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(noteController.text),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
    noteController.dispose();
    if (note == null) return;

    try {
      final response = await ref
          .read(b3ReportRepositoryProvider)
          .approveMonthlyReport(
            month: _period.month,
            year: _period.year,
            approvalRole: role,
            note: note.trim().isEmpty ? null : note.trim(),
          );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            textValue(response['message'], fallback: 'Approval berhasil.'),
          ),
        ),
      );
      ref.invalidate(
        b3MonthlyReportProvider(month: _period.month, year: _period.year),
      );
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data, required this.rowCount});

  final Map<String, dynamic> data;
  final int rowCount;

  @override
  Widget build(BuildContext context) {
    final periodLabel = textValue(pathValue(data, ['period', 'label']));
    final overall = textValue(
      pathValue(data, ['totals', 'overall']),
      fallback: '0',
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.assignment_outlined, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    periodLabel,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text('$rowCount baris • Total $overall kg'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  const _ApprovalCard({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final approval = pathValue(data, ['approval']) as Map?;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Approval',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(textValue(approval?['status'], fallback: 'NOT_SUBMITTED')),
            const SizedBox(height: 6),
            Text('Catatan: ${textValue(approval?['note'])}'),
          ],
        ),
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  const _ReportRow({required this.row});

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        minVerticalPadding: 14,
        title: Text(
          'No. ${textValue(row['no'])} • ${textValue(row['document_number'])}',
        ),
        subtitle: Text(
          '${textValue(row['tanggal_masuk'])} ${textValue(row['jam'])}\n'
          'Dept: ${textValue(row['initiator_department'])}',
        ),
        isThreeLine: true,
        trailing: Text('${_rowWeight(row)} kg'),
      ),
    );
  }

  String _rowWeight(Map<String, dynamic> row) {
    final weights = row['weights_by_waste_type'];
    if (weights is Map && weights.isNotEmpty) {
      return weights.values
          .map((value) => textValue(value, fallback: '0'))
          .join('/');
    }
    return textValue(row['weight_other'], fallback: '0');
  }
}

class _PeriodBar extends StatelessWidget {
  const _PeriodBar({required this.period, required this.onChanged});

  final DateTime period;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final label = DateFormat('MMMM yyyy', 'id_ID').format(period);

    return Material(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            IconButton(
              tooltip: 'Bulan sebelumnya',
              icon: const Icon(Icons.chevron_left),
              onPressed: () =>
                  onChanged(DateTime(period.year, period.month - 1)),
            ),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IconButton(
              tooltip: 'Bulan berikutnya',
              icon: const Icon(Icons.chevron_right),
              onPressed: () =>
                  onChanged(DateTime(period.year, period.month + 1)),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

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
