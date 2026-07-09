import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'hive_box_names.dart';
import 'json_storage_codec.dart';

part 'local_cache_service.g.dart';

class LocalCacheService {
  const LocalCacheService(this._box);

  static const Duration defaultTtl = Duration(minutes: 10);

  final Box<dynamic> _box;

  Future<void> writeJson(String key, Object? value) async {
    await _box.put(key, JsonStorageCodec.normalize(value));
  }

  Future<void> writeFreshJson(String key, Object? value) async {
    await writeJson(key, value);
    await _box.put(_cachedAtKey(key), DateTime.now().toIso8601String());
  }

  Map<String, dynamic>? readJsonMap(String key) {
    return JsonStorageCodec.normalizeMap(_box.get(key));
  }

  List<Map<String, dynamic>> readJsonList(String key) {
    return JsonStorageCodec.normalizeMapList(_box.get(key));
  }

  Future<void> remove(String key) async {
    await _box.delete(key);
    await _box.delete(_cachedAtKey(key));
  }

  bool isFresh(String key, {Duration ttl = defaultTtl}) {
    final cachedAt = _cachedAt(key);
    if (cachedAt == null) return false;

    return DateTime.now().difference(cachedAt) < ttl;
  }

  DateTime? _cachedAt(String key) {
    final value = _box.get(_cachedAtKey(key));
    if (value is! String) return null;
    return DateTime.tryParse(value);
  }

  String _cachedAtKey(String key) => '$key:cached_at';
}

@Riverpod(keepAlive: true)
LocalCacheService masterDataCache(Ref ref) {
  return LocalCacheService(Hive.box<dynamic>(HiveBoxNames.masterData));
}

@Riverpod(keepAlive: true)
LocalCacheService formDraftCache(Ref ref) {
  return LocalCacheService(Hive.box<dynamic>(HiveBoxNames.formDrafts));
}
