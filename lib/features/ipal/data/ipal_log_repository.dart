import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import 'ipal_log_remote_data_source.dart';

part 'ipal_log_repository.g.dart';

class IpalLogRepository {
  const IpalLogRepository(this._remoteDataSource);

  final IpalLogRemoteDataSource _remoteDataSource;

  Future<Map<String, dynamic>> createLog(Map<String, dynamic> payload) {
    return _remoteDataSource.createLog(payload);
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

  Future<Map<String, dynamic>> submitLog(int logId) {
    return _remoteDataSource.submitLog(logId);
  }

  Future<Map<String, dynamic>> approveLog(int logId) {
    return _remoteDataSource.approveLog(logId);
  }
}

@Riverpod(keepAlive: true)
IpalLogRemoteDataSource ipalLogRemoteDataSource(Ref ref) {
  return IpalLogRemoteDataSource(ref.watch(apiClientProvider));
}

@Riverpod(keepAlive: true)
IpalLogRepository ipalLogRepository(Ref ref) {
  return IpalLogRepository(ref.watch(ipalLogRemoteDataSourceProvider));
}
