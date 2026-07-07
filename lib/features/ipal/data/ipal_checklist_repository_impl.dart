import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/storage/local_cache_service.dart';
import '../domain/entities/ipal_checklist_draft.dart';
import '../domain/entities/ipal_checklist_master.dart';
import '../domain/repositories/ipal_checklist_repository.dart';
import 'ipal_checklist_remote_data_source.dart';

part 'ipal_checklist_repository_impl.g.dart';

class IpalChecklistRepositoryImpl implements IpalChecklistRepository {
  const IpalChecklistRepositoryImpl({
    required IpalChecklistRemoteDataSource remoteDataSource,
    required LocalCacheService masterCache,
    required LocalCacheService draftCache,
  }) : _remoteDataSource = remoteDataSource,
       _masterCache = masterCache,
       _draftCache = draftCache;

  static const _masterCacheKey = 'ipal_checklist_master';
  static const _draftKey = 'ipal_checklist_draft';

  final IpalChecklistRemoteDataSource _remoteDataSource;
  final LocalCacheService _masterCache;
  final LocalCacheService _draftCache;

  @override
  Future<List<IpalChecklistTemplate>> getChecklistTemplates() async {
    try {
      final templates = await _remoteDataSource.getChecklistTemplates();
      await _masterCache.writeJson(
        _masterCacheKey,
        templates.map((template) => template.toJson()).toList(growable: false),
      );
      return templates;
    } catch (_) {
      final cached = _masterCache.readJsonList(_masterCacheKey);
      if (cached.isEmpty) rethrow;
      return cached.map(IpalChecklistTemplate.fromJson).toList(growable: false);
    }
  }

  @override
  IpalChecklistDraft? readDraft() {
    final draft = _draftCache.readJsonMap(_draftKey);
    if (draft == null) return null;
    return IpalChecklistDraft.fromJson(draft);
  }

  @override
  Future<void> saveDraft(IpalChecklistDraft draft) {
    return _draftCache.writeJson(_draftKey, draft.toJson());
  }

  @override
  Future<void> clearDraft() => _draftCache.remove(_draftKey);
}

@Riverpod(keepAlive: true)
IpalChecklistRemoteDataSource ipalChecklistRemoteDataSource(Ref ref) {
  return IpalChecklistRemoteDataSource(ref.watch(apiClientProvider));
}

@Riverpod(keepAlive: true)
IpalChecklistRepository ipalChecklistRepository(Ref ref) {
  return IpalChecklistRepositoryImpl(
    remoteDataSource: ref.watch(ipalChecklistRemoteDataSourceProvider),
    masterCache: ref.watch(masterDataCacheProvider),
    draftCache: ref.watch(formDraftCacheProvider),
  );
}
