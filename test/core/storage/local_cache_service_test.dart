import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/core/storage/local_cache_service.dart';
import 'package:hse_mobile/features/forms/domain/entities/form_field_definition.dart';
import 'package:hse_mobile/features/ipal/domain/entities/ipal_process_master.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  test(
    'writeJson menyimpan Freezed nested object sebagai JSON murni',
    () async {
      final box = _MemoryBox();
      final cache = LocalCacheService(box);
      const master = IpalProcessMaster(
        templates: [
          IpalProcessTemplate(
            id: 1,
            name: 'Catatan Proses',
            sections: [
              IpalProcessSection(
                id: 2,
                name: 'Section',
                items: [
                  IpalProcessItem(
                    id: 3,
                    label: 'pH',
                    inputType: HseInputType.number,
                  ),
                ],
              ),
            ],
          ),
        ],
      );

      await cache.writeJson('master', master.toJson());

      final stored = box.get('master') as Map<String, dynamic>;
      final templates = stored['templates'] as List<dynamic>;
      expect(templates.single, isA<Map<String, dynamic>>());
    },
  );

  test('readJsonMap menormalisasi nested Hive map dynamic', () {
    final box = _MemoryBox();
    final cache = LocalCacheService(box);
    box.seed('draft', {
      'tanggal': '2026-07-07',
      'templateId': 1,
      'processValues': {1: '7.1'},
      'batches': [
        {
          'batchNo': 1,
          'values': {2: 'Normal'},
        },
      ],
    });

    final draft = cache.readJsonMap('draft')!;
    final processValues = draft['processValues'] as Map<String, dynamic>;
    final batches = draft['batches'] as List<dynamic>;
    final batch = batches.single as Map<String, dynamic>;
    final values = batch['values'] as Map<String, dynamic>;

    expect(processValues['1'], '7.1');
    expect(values['2'], 'Normal');
  });

  test('writeFreshJson menandai cache fresh sampai TTL habis', () async {
    final box = _MemoryBox();
    final cache = LocalCacheService(box);

    await cache.writeFreshJson('session', {'name': 'Operator'});

    expect(cache.isFresh('session'), isTrue);

    box.seed(
      'session:cached_at',
      DateTime.now().subtract(const Duration(minutes: 11)).toIso8601String(),
    );

    expect(cache.isFresh('session'), isFalse);
  });

  test('remove menghapus data dan timestamp cache', () async {
    final box = _MemoryBox();
    final cache = LocalCacheService(box);

    await cache.writeFreshJson('session', {'name': 'Operator'});
    await cache.remove('session');

    expect(cache.readJsonMap('session'), isNull);
    expect(cache.isFresh('session'), isFalse);
  });
}

class _MemoryBox extends Fake implements Box<dynamic> {
  final _values = <dynamic, dynamic>{};

  void seed(dynamic key, dynamic value) {
    _values[key] = value;
  }

  @override
  Future<void> put(dynamic key, dynamic value) async {
    _values[key] = value;
  }

  @override
  Future<void> delete(dynamic key) async {
    _values.remove(key);
  }

  @override
  dynamic get(dynamic key, {dynamic defaultValue}) {
    return _values[key] ?? defaultValue;
  }
}
