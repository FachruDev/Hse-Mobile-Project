import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/storage/local_cache_service.dart';
import '../domain/entities/b3_master_data.dart';
import '../domain/entities/b3_storage_draft.dart';
import 'b3_storage_remote_data_source.dart';

part 'b3_storage_repository.g.dart';

class B3StorageRepository {
  const B3StorageRepository({
    required B3StorageRemoteDataSource remoteDataSource,
    required LocalCacheService masterCache,
    required LocalCacheService draftCache,
  }) : _remoteDataSource = remoteDataSource,
       _masterCache = masterCache,
       _draftCache = draftCache;

  static const _wasteTypesKey = 'b3_waste_types';
  static const _departmentsKey = 'b3_initiator_departments';
  static const _draftKey = 'b3_storage_draft';

  final B3StorageRemoteDataSource _remoteDataSource;
  final LocalCacheService _masterCache;
  final LocalCacheService _draftCache;

  Future<List<B3MasterOption>> getWasteTypes() {
    return _loadMaster(
      cacheKey: _wasteTypesKey,
      loader: _remoteDataSource.getWasteTypes,
    );
  }

  Future<List<B3MasterOption>> getInitiatorDepartments() {
    return _loadMaster(
      cacheKey: _departmentsKey,
      loader: _remoteDataSource.getInitiatorDepartments,
    );
  }

  Future<Map<String, dynamic>> createLog(B3StorageDraft draft) {
    return _remoteDataSource.createLog(draft);
  }

  Future<Map<String, dynamic>> updateLog(int logId, B3StorageDraft draft) {
    return _remoteDataSource.updateLog(logId, draft);
  }

  Future<Map<String, dynamic>> listLogs({
    int? month,
    int? year,
    int perPage = 50,
  }) {
    return _remoteDataSource.listLogs(
      month: month,
      year: year,
      perPage: perPage,
    );
  }

  Future<Map<String, dynamic>> detailLog(int logId) {
    return _remoteDataSource.detailLog(logId);
  }

  Future<Map<String, dynamic>> deleteLog(int logId) {
    return _remoteDataSource.deleteLog(logId);
  }

  Future<Uint8List> photoBytes(int logId) {
    return _remoteDataSource.photoBytes(logId);
  }

  B3StorageDraft? readDraft() {
    final draft = _draftCache.readJsonMap(_draftKey);
    if (draft == null) return null;
    return B3StorageDraft.fromJson(draft);
  }

  Future<void> saveDraft(B3StorageDraft draft) {
    return _draftCache.writeJson(_draftKey, draft.toJson());
  }

  Future<void> clearDraft() => _draftCache.remove(_draftKey);

  Future<List<B3MasterOption>> _loadMaster({
    required String cacheKey,
    required Future<List<B3MasterOption>> Function() loader,
  }) async {
    try {
      final items = await loader();
      await _masterCache.writeJson(
        cacheKey,
        items.map((item) => item.toJson()).toList(growable: false),
      );
      return items;
    } catch (_) {
      final cached = _masterCache.readJsonList(cacheKey);
      if (cached.isEmpty) rethrow;
      return cached.map(B3MasterOption.fromJson).toList(growable: false);
    }
  }
}

@Riverpod(keepAlive: true)
B3StorageRemoteDataSource b3StorageRemoteDataSource(Ref ref) {
  return B3StorageRemoteDataSource(ref.watch(apiClientProvider));
}

@Riverpod(keepAlive: true)
B3StorageRepository b3StorageRepository(Ref ref) {
  return B3StorageRepository(
    remoteDataSource: ref.watch(b3StorageRemoteDataSourceProvider),
    masterCache: ref.watch(masterDataCacheProvider),
    draftCache: ref.watch(formDraftCacheProvider),
  );
}
