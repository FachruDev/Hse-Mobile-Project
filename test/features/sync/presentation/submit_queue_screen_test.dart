import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hse_mobile/core/storage/submit_queue_service.dart';
import 'package:hse_mobile/features/sync/presentation/submit_queue_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID');
  });

  testWidgets('menampilkan IPAL dan B3 pending serta menghapus antrean', (
    tester,
  ) async {
    final box = _MemoryBox();
    final service = SubmitQueueService(box);
    await service.enqueue(
      SubmitQueueItem(
        id: 'ipal-1',
        endpoint: '/ipal/logs',
        method: 'POST',
        payload: const {'tanggal': '2026-08-03'},
        createdAt: DateTime(2026, 8, 3, 8),
        moduleLabel: 'Log IPAL',
        displayDate: '2026-08-03',
      ),
    );
    await service.enqueue(
      SubmitQueueItem(
        id: 'b3-1',
        endpoint: '/b3-storage/logs',
        method: 'POST',
        payload: const {'movement_date': '2026-08-03'},
        createdAt: DateTime(2026, 8, 3, 9),
        moduleLabel: 'Log B3',
        displayDate: '2026-08-03',
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          submitQueueServiceProvider.overrideWithValue(service),
          submitQueueItemsProvider.overrideWith(
            (ref) => Stream.value(service.pendingItems()),
          ),
        ],
        child: const MaterialApp(home: SubmitQueueScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Log IPAL'), findsOneWidget);
    expect(find.text('Log B3'), findsOneWidget);

    await tester.tap(find.byTooltip('Hapus').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();

    expect(service.findById('ipal-1'), isNull);
  });
}

class _MemoryBox extends Fake implements Box<dynamic> {
  final _values = <dynamic, dynamic>{};

  @override
  Iterable<dynamic> get values => _values.values;

  @override
  dynamic get(dynamic key, {dynamic defaultValue}) {
    return _values[key] ?? defaultValue;
  }

  @override
  Future<void> put(dynamic key, dynamic value) async {
    _values[key] = value;
  }

  @override
  Future<void> delete(dynamic key) async {
    _values.remove(key);
  }
}
