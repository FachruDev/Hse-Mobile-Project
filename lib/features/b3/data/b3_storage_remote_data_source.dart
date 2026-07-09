import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../domain/entities/b3_master_data.dart';
import '../domain/entities/b3_storage_draft.dart';
import '../domain/services/b3_storage_payload_builder.dart';

class B3StorageRemoteDataSource {
  const B3StorageRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<B3MasterOption>> getWasteTypes() {
    return _getMasterOptions('/b3-storage/master/waste-types');
  }

  Future<List<B3MasterOption>> getInitiatorDepartments() {
    return _getMasterOptions('/b3-storage/master/initiator-departments');
  }

  Future<Map<String, dynamic>> createLog(B3StorageDraft draft) async {
    final formData = await B3StoragePayloadBuilder.buildFormData(draft);
    return _apiClient.post<Map<String, dynamic>>(
      '/b3-storage/logs',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  Future<Map<String, dynamic>> updateLog(
    int logId,
    B3StorageDraft draft,
  ) async {
    final formData = await B3StoragePayloadBuilder.buildFormData(draft);
    return _apiClient.put<Map<String, dynamic>>(
      '/b3-storage/logs/$logId',
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
      '/b3-storage/logs',
      queryParameters: queryParameters,
    );
  }

  Future<Map<String, dynamic>> detailLog(int logId) {
    return _apiClient.get<Map<String, dynamic>>('/b3-storage/logs/$logId');
  }

  Future<Map<String, dynamic>> deleteLog(int logId) {
    return _apiClient.delete<Map<String, dynamic>>('/b3-storage/logs/$logId');
  }

  Future<Uint8List> photoBytes(int logId) async {
    final bytes = await _apiClient.get<List<int>>(
      '/b3-storage/logs/$logId/photo',
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(bytes);
  }

  Future<List<B3MasterOption>> _getMasterOptions(String path) async {
    final response = await _apiClient.get<Map<String, dynamic>>(path);
    final data = response['data'];
    if (data is! List) return const [];

    return data
        .whereType<Map>()
        .map(
          (item) => B3MasterOption.fromApiJson(Map<String, dynamic>.from(item)),
        )
        .toList(growable: false);
  }
}
