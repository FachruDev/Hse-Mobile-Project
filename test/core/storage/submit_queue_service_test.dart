import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hse_mobile/core/storage/submit_queue_service.dart';

void main() {
  test('pendingItems menormalisasi nested payload dari Hive', () {
    final box = _MemoryBox();
    final service = SubmitQueueService(box);
    box.seed('queue-1', {
      'id': 'queue-1',
      'endpoint': '/ipal/logs',
      'method': 'POST',
      'payload': {
        'process': {
          'values': [
            {'item_id': 1, 'value_text': 'Normal'},
          ],
        },
      },
      'createdAt': '2026-07-07T10:00:00.000',
      'attempts': 0,
      'status': 'pending',
    });

    final item = service.pendingItems().single;
    final process = item.payload['process'] as Map<String, dynamic>;
    final values = process['values'] as List<dynamic>;
    final firstValue = values.single as Map<String, dynamic>;

    expect(firstValue['item_id'], 1);
    expect(firstValue['value_text'], 'Normal');
  });

  test('upsertIpal mengganti payload antrean tanggal yang sama', () async {
    final box = _MemoryBox();
    final service = SubmitQueueService(box);

    await service.upsertIpal(
      SubmitQueueItem(
        id: 'ipal-old',
        endpoint: '/ipal/logs',
        method: 'POST',
        payload: const {'tanggal': '2026-08-03', 'value': 'lama'},
        createdAt: DateTime(2026, 8, 3, 8),
        displayDate: '2026-08-03',
      ),
    );
    await service.upsertIpal(
      SubmitQueueItem(
        id: 'ipal-new',
        endpoint: '/ipal/logs',
        method: 'POST',
        payload: const {'tanggal': '2026-08-03', 'value': 'baru'},
        createdAt: DateTime(2026, 8, 3, 9),
        displayDate: '2026-08-03',
      ),
    );

    final item = service.pendingItems().single;

    expect(item.id, 'ipal-old');
    expect(item.payload['value'], 'baru');
    expect(item.attempts, 0);
    expect(item.status, SubmitQueueStatus.pending.name);
  });

  test('deleteItem menghapus antrean permanen', () async {
    final box = _MemoryBox();
    final service = SubmitQueueService(box);

    await service.enqueue(
      SubmitQueueItem(
        id: 'queue-1',
        endpoint: '/b3-storage/logs',
        method: 'POST',
        payload: const {'movement_date': '2026-08-03'},
        createdAt: DateTime(2026, 8, 3),
      ),
    );

    await service.deleteItem('queue-1');

    expect(service.pendingItems(), isEmpty);
  });

  test('lockItem dan updatePayload mengatur status edit antrean', () async {
    final box = _MemoryBox();
    final service = SubmitQueueService(box);

    await service.enqueue(
      SubmitQueueItem(
        id: 'queue-1',
        endpoint: '/b3-storage/logs',
        method: 'POST',
        payload: const {'movement_date': '2026-08-03'},
        createdAt: DateTime(2026, 8, 3),
        status: SubmitQueueStatus.failed.name,
        lastError: 'Offline',
      ),
    );

    await service.lockItem('queue-1');
    expect(service.findById('queue-1')?.locked, isTrue);

    await service.updatePayload('queue-1', const {
      'movement_date': '2026-08-04',
    }, displayDate: '2026-08-04');

    final item = service.findById('queue-1');
    expect(item?.locked, isFalse);
    expect(item?.status, SubmitQueueStatus.pending.name);
    expect(item?.lastError, isNull);
    expect(item?.displayDate, '2026-08-04');
  });

  test('unlockAll membuka semua antrean yang tertinggal locked', () async {
    final box = _MemoryBox();
    final service = SubmitQueueService(box);

    await service.enqueue(
      SubmitQueueItem(
        id: 'queue-1',
        endpoint: '/b3-storage/logs',
        method: 'POST',
        payload: const {'movement_date': '2026-08-03'},
        createdAt: DateTime(2026, 8, 3),
        locked: true,
      ),
    );

    await service.unlockAll();

    expect(service.findById('queue-1')?.locked, isFalse);
  });
}

class _MemoryBox extends Fake implements Box<dynamic> {
  final _values = <dynamic, dynamic>{};

  void seed(dynamic key, dynamic value) {
    _values[key] = value;
  }

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
