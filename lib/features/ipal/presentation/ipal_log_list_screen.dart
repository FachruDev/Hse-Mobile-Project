import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../color_config.dart';
import '../../../shared/layout/hse_app_scaffold.dart';
import '../../../shared/utils/api_response_parser.dart';
import '../../../shared/utils/hse_datetime_formatter.dart';
import '../application/ipal_log_controller.dart';

class IpalLogListScreen extends ConsumerStatefulWidget {
  const IpalLogListScreen({super.key});

  @override
  ConsumerState<IpalLogListScreen> createState() => _IpalLogListScreenState();
}

class _IpalLogListScreenState extends ConsumerState<IpalLogListScreen> {
  late DateTime _period;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _period = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final provider = ipalLogListProvider(
      month: _period.month,
      year: _period.year,
      dateFrom: _dateText(_dateFrom),
      dateTo: _dateText(_dateTo),
    );
    final logs = ref.watch(provider);

    return HseAppScaffold(
      title: 'Riwayat IPAL',
      selectedPath: '/riwayat/ipal',
      showDrawer: true,
      actions: [
        IconButton(
          tooltip: 'Muat ulang',
          icon: const Icon(Icons.refresh),
          onPressed: () => ref.invalidate(provider),
        ),
      ],
      body: Column(
        children: [
          _PeriodBar(
            period: _period,
            onChanged: (value) => setState(() => _period = value),
            dateFrom: _dateFrom,
            dateTo: _dateTo,
            onPickDateRange: _pickDateRange,
            onClearDateRange: () => setState(() {
              _dateFrom = null;
              _dateTo = null;
            }),
          ),
          Expanded(
            child: logs.when(
              data: (response) {
                final rows = apiRows(response);
                if (rows.isEmpty) {
                  return const _EmptyState(message: 'Riwayat IPAL belum ada.');
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: rows.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) =>
                      _IpalLogCard(row: rows[index]),
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

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _dateFrom == null || _dateTo == null
          ? null
          : DateTimeRange(start: _dateFrom!, end: _dateTo!),
    );

    if (picked == null) return;

    setState(() {
      _dateFrom = picked.start;
      _dateTo = picked.end;
    });
  }
}

class _IpalLogCard extends StatelessWidget {
  const _IpalLogCard({required this.row});

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    final id = int.tryParse(textValue(row['id'], fallback: ''));
    final status = textValue(pathValue(row, ['process_log', 'status']));
    final batchCount =
        (pathValue(row, ['process_log', 'batches']) as List?)?.length ?? 0;

    return Card(
      child: ListTile(
        minVerticalPadding: 14,
        leading: CircleAvatar(
          backgroundColor: _statusColor(status).withValues(alpha: 0.12),
          child: Icon(Icons.water_drop_outlined, color: _statusColor(status)),
        ),
        title: Text(HseDateTimeFormatter.date(row['tanggal'])),
        subtitle: Text(
          [
            textValue(
              pathValue(row, ['operator', 'name']),
              fallback: 'Operator -',
            ),
            if (batchCount > 0) '$batchCount batch',
          ].join(' • '),
        ),
        trailing: _StatusChip(status: status),
        onTap: id == null ? null : () => context.push('/riwayat/ipal/$id'),
      ),
    );
  }
}

class _PeriodBar extends StatelessWidget {
  const _PeriodBar({
    required this.period,
    required this.onChanged,
    required this.dateFrom,
    required this.dateTo,
    required this.onPickDateRange,
    required this.onClearDateRange,
  });

  final DateTime period;
  final ValueChanged<DateTime> onChanged;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final VoidCallback onPickDateRange;
  final VoidCallback onClearDateRange;

  @override
  Widget build(BuildContext context) {
    final label = DateFormat('MMMM yyyy', 'id_ID').format(period);
    final rangeLabel = dateFrom == null || dateTo == null
        ? 'Filter tanggal'
        : '${HseDateTimeFormatter.shortDate(dateFrom)} s.d. ${HseDateTimeFormatter.shortDate(dateTo)}';

    return Material(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          children: [
            Row(
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
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.date_range_outlined),
                    label: Text(rangeLabel, overflow: TextOverflow.ellipsis),
                    onPressed: onPickDateRange,
                  ),
                ),
                if (dateFrom != null || dateTo != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Hapus filter tanggal',
                    icon: const Icon(Icons.close),
                    onPressed: onClearDateRange,
                  ),
                ],
              ],
            ),
            if (dateFrom != null || dateTo != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Filter tanggal aktif. Bulan/tahun diabaikan oleh API.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          status,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
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

Color _statusColor(String status) {
  return switch (status) {
    'APPROVED' => AppColors.success,
    'SUBMITTED' => AppColors.primary,
    'DRAFT' => AppColors.warning,
    _ => AppColors.textSecondary,
  };
}

String? _dateText(DateTime? date) {
  if (date == null) return null;

  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}
