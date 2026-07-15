import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/storage/local_cache_service.dart';
import 'ipal_log_remote_data_source.dart';

part 'ipal_log_repository.g.dart';

class IpalLogRepository {
  const IpalLogRepository({
    required IpalLogRemoteDataSource remoteDataSource,
    required LocalCacheService historyCache,
  }) : _remoteDataSource = remoteDataSource,
       _historyCache = historyCache;

  final IpalLogRemoteDataSource _remoteDataSource;
  final LocalCacheService _historyCache;

  Future<Map<String, dynamic>> createLog(Map<String, dynamic> payload) {
    return _remoteDataSource.createLog(payload);
  }

  Future<Map<String, dynamic>> listLogs({
    int? month,
    int? year,
    String? dateFrom,
    String? dateTo,
    int perPage = 50,
  }) async {
    final cacheKey = _listCacheKey(
      month: month,
      year: year,
      dateFrom: dateFrom,
      dateTo: dateTo,
      perPage: perPage,
    );

    try {
      final response = await _remoteDataSource.listLogs(
        month: month,
        year: year,
        dateFrom: dateFrom,
        dateTo: dateTo,
        perPage: perPage,
      );
      await _historyCache.writeFreshJson(cacheKey, response);
      return response;
    } catch (_) {
      final cached = _historyCache.readJsonMap(cacheKey);
      if (cached == null) rethrow;
      return cached;
    }
  }

  Future<Map<String, dynamic>> detailLog(int logId) async {
    final cacheKey = 'ipal_log_detail:$logId';

    try {
      final response = await _remoteDataSource.detailLog(logId);
      await _historyCache.writeFreshJson(cacheKey, response);
      return response;
    } catch (_) {
      final cached = _historyCache.readJsonMap(cacheKey);
      if (cached == null) rethrow;
      return cached;
    }
  }

  Future<Map<String, dynamic>> processReferences({required String date}) async {
    final cacheKey = 'ipal_process_references:$date';

    try {
      final response = await _remoteDataSource.processReferences(date: date);
      await _historyCache.writeFreshJson(cacheKey, response);
      return response;
    } catch (_) {
      final cached = _historyCache.readJsonMap(cacheKey);
      if (cached == null) rethrow;
      return cached;
    }
  }

  Future<Map<String, dynamic>> submitLog(int logId) {
    return _remoteDataSource.submitLog(logId);
  }

  Future<Map<String, dynamic>> approveLog(int logId) {
    return _remoteDataSource.approveLog(logId);
  }

  Future<Map<String, dynamic>> reopenLog(int logId) {
    return _remoteDataSource.reopenLog(logId);
  }

  String _listCacheKey({
    int? month,
    int? year,
    String? dateFrom,
    String? dateTo,
    required int perPage,
  }) {
    return [
      'ipal_logs',
      month?.toString() ?? '',
      year?.toString() ?? '',
      dateFrom ?? '',
      dateTo ?? '',
      perPage.toString(),
    ].join(':');
  }
}

@Riverpod(keepAlive: true)
IpalLogRemoteDataSource ipalLogRemoteDataSource(Ref ref) {
  return IpalLogRemoteDataSource(ref.watch(apiClientProvider));
}

@Riverpod(keepAlive: true)
IpalLogRepository ipalLogRepository(Ref ref) {
  return IpalLogRepository(
    remoteDataSource: ref.watch(ipalLogRemoteDataSourceProvider),
    historyCache: ref.watch(masterDataCacheProvider),
  );
}
