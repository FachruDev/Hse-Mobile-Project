import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/storage/local_cache_service.dart';
import '../domain/entities/ipal_process_draft.dart';
import '../domain/entities/ipal_process_master.dart';
import '../domain/repositories/ipal_process_repository.dart';
import 'ipal_process_remote_data_source.dart';

part 'ipal_process_repository_impl.g.dart';

class IpalProcessRepositoryImpl implements IpalProcessRepository {
  const IpalProcessRepositoryImpl({
    required IpalProcessRemoteDataSource remoteDataSource,
    required LocalCacheService masterCache,
    required LocalCacheService draftCache,
  }) : _remoteDataSource = remoteDataSource,
       _masterCache = masterCache,
       _draftCache = draftCache;

  static const _masterCacheKey = 'ipal_process_master';
  static const _draftKey = 'ipal_process_draft';

  final IpalProcessRemoteDataSource _remoteDataSource;
  final LocalCacheService _masterCache;
  final LocalCacheService _draftCache;

  @override
  Future<IpalProcessMaster> getProcessMaster({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = _masterCache.readJsonMap(_masterCacheKey);
      if (cached != null) return IpalProcessMaster.fromJson(cached);
    }

    try {
      final master = await _remoteDataSource.getProcessMaster();
      await _masterCache.writeJson(_masterCacheKey, master.toJson());
      return master;
    } catch (error) {
      final cached = _masterCache.readJsonMap(_masterCacheKey);
      if (cached != null) return IpalProcessMaster.fromJson(cached);
      throw FormatException(
        'Master catatan proses tidak sesuai kontrak: $error',
      );
    }
  }

  @override
  IpalProcessDraft? readDraft() {
    final draft = _draftCache.readJsonMap(_draftKey);
    if (draft == null) return null;
    return IpalProcessDraft.fromJson(draft);
  }

  @override
  Future<void> saveDraft(IpalProcessDraft draft) {
    return _draftCache.writeJson(_draftKey, draft.toJson());
  }

  @override
  Future<void> clearDraft() => _draftCache.remove(_draftKey);
}

@Riverpod(keepAlive: true)
IpalProcessRemoteDataSource ipalProcessRemoteDataSource(Ref ref) {
  return IpalProcessRemoteDataSource(ref.watch(apiClientProvider));
}

@Riverpod(keepAlive: true)
IpalProcessRepository ipalProcessRepository(Ref ref) {
  return IpalProcessRepositoryImpl(
    remoteDataSource: ref.watch(ipalProcessRemoteDataSourceProvider),
    masterCache: ref.watch(masterDataCacheProvider),
    draftCache: ref.watch(formDraftCacheProvider),
  );
}
