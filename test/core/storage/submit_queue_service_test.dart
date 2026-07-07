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
}

class _MemoryBox extends Fake implements Box<dynamic> {
  final _values = <dynamic, dynamic>{};

  void seed(dynamic key, dynamic value) {
    _values[key] = value;
  }

  @override
  Iterable<dynamic> get values => _values.values;

  @override
  Future<void> put(dynamic key, dynamic value) async {
    _values[key] = value;
  }

  @override
  Future<void> delete(dynamic key) async {
    _values.remove(key);
  }
}
