import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'hive_box_names.dart';
import 'json_storage_codec.dart';

part 'local_cache_service.g.dart';

class LocalCacheService {
  const LocalCacheService(this._box);

  final Box<dynamic> _box;

  Future<void> writeJson(String key, Object? value) async {
    await _box.put(key, JsonStorageCodec.normalize(value));
  }

  Map<String, dynamic>? readJsonMap(String key) {
    return JsonStorageCodec.normalizeMap(_box.get(key));
  }

  List<Map<String, dynamic>> readJsonList(String key) {
    return JsonStorageCodec.normalizeMapList(_box.get(key));
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
