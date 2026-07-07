import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/storage/submit_queue_service.dart';
import '../../b3/domain/entities/b3_storage_draft.dart';
import '../../b3/domain/services/b3_storage_payload_builder.dart';
import '../../ipal/domain/services/ipal_log_payload_builder.dart';

part 'submit_queue_controller.g.dart';

class SubmitQueueProcessor {
  const SubmitQueueProcessor({
    required SubmitQueueService queueService,
    required ApiClient apiClient,
  }) : _queueService = queueService,
       _apiClient = apiClient;

  final SubmitQueueService _queueService;
  final ApiClient _apiClient;

  Future<int> retryPending() async {
    var successCount = 0;
    final items = _queueService.pendingItems();
    for (final item in items) {
      try {
        await _send(item);
        await _queueService.markDone(item.id);
        successCount++;
      } on ApiException catch (error) {
        await _queueService.markFailed(item, error.message);
      } catch (error) {
        await _queueService.markFailed(item, error.toString());
      }
    }
    return successCount;
  }

  Future<void> _send(SubmitQueueItem item) async {
    if (item.endpoint == '/b3-storage/logs' && item.method == 'POST') {
      final draft = B3StorageDraft.fromJson(item.payload);
      final formData = await B3StoragePayloadBuilder.buildFormData(draft);
      await _apiClient.post<Map<String, dynamic>>(
        item.endpoint,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      return;
    }

    if (item.endpoint == '/ipal/logs' && item.method == 'POST') {
      final formData = await IpalLogPayloadBuilder.buildFormData(item.payload);
      await _apiClient.post<Map<String, dynamic>>(
        item.endpoint,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      return;
    }

    switch (item.method) {
      case 'POST':
        await _apiClient.post<Map<String, dynamic>>(
          item.endpoint,
          data: item.payload,
        );
        return;
      case 'PUT':
        await _apiClient.put<Map<String, dynamic>>(
          item.endpoint,
          data: item.payload,
        );
        return;
      case 'DELETE':
        await _apiClient.delete<Map<String, dynamic>>(
          item.endpoint,
          data: item.payload,
        );
        return;
      default:
        throw UnsupportedError('Metode antrean tidak didukung: ${item.method}');
    }
  }
}

@Riverpod(keepAlive: true)
SubmitQueueProcessor submitQueueProcessor(Ref ref) {
  return SubmitQueueProcessor(
    queueService: ref.watch(submitQueueServiceProvider),
    apiClient: ref.watch(apiClientProvider),
  );
}
