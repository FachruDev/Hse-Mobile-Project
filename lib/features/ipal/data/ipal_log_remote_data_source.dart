import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../domain/services/ipal_log_payload_builder.dart';

class IpalLogRemoteDataSource {
  const IpalLogRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> createLog(Map<String, dynamic> payload) async {
    final formData = await IpalLogPayloadBuilder.buildFormData(payload);

    return _apiClient.post<Map<String, dynamic>>(
      '/ipal/logs',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  Future<Map<String, dynamic>> listLogs({
    int? month,
    int? year,
    String? dateFrom,
    String? dateTo,
    int perPage = 50,
  }) {
    final queryParameters = <String, dynamic>{'per_page': perPage};
    if (month != null) queryParameters['month'] = month;
    if (year != null) queryParameters['year'] = year;
    if (dateFrom != null) queryParameters['date_from'] = dateFrom;
    if (dateTo != null) queryParameters['date_to'] = dateTo;

    return _apiClient.get<Map<String, dynamic>>(
      '/ipal/logs',
      queryParameters: queryParameters,
    );
  }

  Future<Map<String, dynamic>> detailLog(int logId) {
    return _apiClient.get<Map<String, dynamic>>('/ipal/logs/$logId');
  }

  Future<Map<String, dynamic>> submitLog(int logId) {
    return _apiClient.post<Map<String, dynamic>>('/ipal/logs/$logId/submit');
  }

  Future<Map<String, dynamic>> approveLog(int logId) {
    return _apiClient.post<Map<String, dynamic>>('/ipal/logs/$logId/approve');
  }

  Future<Map<String, dynamic>> reopenLog(int logId) {
    return _apiClient.post<Map<String, dynamic>>('/ipal/logs/$logId/reopen');
  }
}
