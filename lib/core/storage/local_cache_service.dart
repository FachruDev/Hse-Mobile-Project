import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'hive_box_names.dart';

part 'local_cache_service.g.dart';

class LocalCacheService {
  const LocalCacheService(this._box);

  final Box<dynamic> _box;

  Future<void> writeJson(String key, Object? value) async {
    await _box.put(key, value);
  }

  Map<String, dynamic>? readJsonMap(String key) {
    final value = _box.get(key);
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  List<Map<String, dynamic>> readJsonList(String key) {
    final value = _box.get(key);
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }

  Future<void> remove(String key) => _box.delete(key);
}

@Riverpod(keepAlive: true)
LocalCacheService masterDataCache(Ref ref) {
  return LocalCacheService(Hive.box<dynamic>(HiveBoxNames.masterData));
}

@Riverpod(keepAlive: true)
LocalCacheService formDraftCache(Ref ref) {
  return LocalCacheService(Hive.box<dynamic>(HiveBoxNames.formDrafts));
}
