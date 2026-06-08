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
}

class _MemoryBox extends Fake implements Box<dynamic> {
  final _values = <dynamic, dynamic>{};

  @override
  Future<void> put(dynamic key, dynamic value) async {
    _values[key] = value;
  }

  @override
  dynamic get(dynamic key, {dynamic defaultValue}) {
    return _values[key] ?? defaultValue;
  }
}
