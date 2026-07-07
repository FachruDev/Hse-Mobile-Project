import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../color_config.dart';
import '../../../shared/layout/hse_app_scaffold.dart';
import '../../../shared/utils/api_response_parser.dart';
import '../application/b3_storage_log_controller.dart';

class B3LogListScreen extends ConsumerStatefulWidget {
  const B3LogListScreen({super.key});

  @override
  ConsumerState<B3LogListScreen> createState() => _B3LogListScreenState();
}

class _B3LogListScreenState extends ConsumerState<B3LogListScreen> {
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
      b3StorageLogListProvider(month: _period.month, year: _period.year),
    );

    return HseAppScaffold(
      title: 'Riwayat B3',
      selectedPath: '/riwayat/b3',
      showDrawer: true,
      actions: [
        IconButton(
          tooltip: 'Muat ulang',
          icon: const Icon(Icons.refresh),
          onPressed: () => ref.invalidate(
            b3StorageLogListProvider(month: _period.month, year: _period.year),
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
                  return const _EmptyState(message: 'Riwayat B3 belum ada.');
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: rows.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => _B3LogCard(row: rows[index]),
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

class _B3LogCard extends StatelessWidget {
  const _B3LogCard({required this.row});

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    final id = int.tryParse(textValue(row['id'], fallback: ''));
    final movementType = textValue(row['movement_type']);
    final wasteName = textValue(
      pathValue(row, ['waste_type', 'name']),
      fallback: textValue(row['waste_type_other']),
    );

    return Card(
      child: ListTile(
        minVerticalPadding: 14,
        leading: CircleAvatar(
          backgroundColor: _movementColor(movementType).withValues(alpha: 0.12),
          child: Icon(
            Icons.inventory_2_outlined,
            color: _movementColor(movementType),
          ),
        ),
        title: Text('$wasteName • ${textValue(row['weight_kg'])} kg'),
        subtitle: Text(
          '${textValue(row['movement_date'])} ${textValue(row['movement_time'])}\n'
          'Dokumen: ${textValue(row['document_number'])}',
        ),
        isThreeLine: true,
        trailing: Text(movementType),
        onTap: id == null ? null : () => context.push('/riwayat/b3/$id'),
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

Color _movementColor(String movementType) {
  return movementType == 'KELUAR' ? AppColors.warning : AppColors.success;
}
