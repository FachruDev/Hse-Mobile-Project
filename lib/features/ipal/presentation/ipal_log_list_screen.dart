import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../color_config.dart';
import '../../../shared/layout/hse_app_scaffold.dart';
import '../../../shared/utils/api_response_parser.dart';
import '../application/ipal_log_controller.dart';

class IpalLogListScreen extends ConsumerStatefulWidget {
  const IpalLogListScreen({super.key});

  @override
  ConsumerState<IpalLogListScreen> createState() => _IpalLogListScreenState();
}

class _IpalLogListScreenState extends ConsumerState<IpalLogListScreen> {
  late DateTime _period;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _period = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final logs = ref.watch(
      ipalLogListProvider(month: _period.month, year: _period.year),
    );

    return HseAppScaffold(
      title: 'Riwayat IPAL',
      selectedPath: '/riwayat/ipal',
      showDrawer: true,
      actions: [
        IconButton(
          tooltip: 'Muat ulang',
          icon: const Icon(Icons.refresh),
          onPressed: () => ref.invalidate(
            ipalLogListProvider(month: _period.month, year: _period.year),
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
        title: Text(textValue(row['tanggal'])),
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
