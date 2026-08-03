import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hse_mobile/core/network/api_client.dart';
import 'package:hse_mobile/core/storage/submit_queue_service.dart';
import 'package:hse_mobile/features/sync/application/submit_queue_controller.dart';

void main() {
  test('retryPending melewati item yang sedang diedit', () async {
    final box = _MemoryBox();
    final service = SubmitQueueService(box);
    final apiClient = _FakeApiClient();
    final processor = SubmitQueueProcessor(
      queueService: service,
      apiClient: apiClient,
    );

    await service.enqueue(
      SubmitQueueItem(
        id: 'locked',
        endpoint: '/example',
        method: 'POST',
        payload: const {'value': 'locked'},
        createdAt: DateTime(2026, 8, 3),
        locked: true,
      ),
    );
    await service.enqueue(
      SubmitQueueItem(
        id: 'pending',
        endpoint: '/example',
        method: 'POST',
        payload: const {'value': 'pending'},
        createdAt: DateTime(2026, 8, 3),
      ),
    );

    final sentCount = await processor.retryPending();

    expect(sentCount, 1);
    expect(apiClient.posts, 1);
    expect(service.findById('locked'), isNotNull);
    expect(service.findById('pending'), isNull);
  });
}

class _FakeApiClient extends ApiClient {
  _FakeApiClient() : super(Dio());

  int posts = 0;

  @override
  Future<T> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    posts++;
    return <String, dynamic>{} as T;
  }
}

class _MemoryBox extends Fake implements Box<dynamic> {
  final _values = <dynamic, dynamic>{};

  @override
  Iterable<dynamic> get values => _values.values;

  @override
  dynamic get(dynamic key, {dynamic defaultValue}) {
    return _values[key] ?? defaultValue;
  }

  @override
  Future<void> put(dynamic key, dynamic value) async {
    _values[key] = value;
  }

  @override
  Future<void> delete(dynamic key) async {
    _values.remove(key);
  }
}
