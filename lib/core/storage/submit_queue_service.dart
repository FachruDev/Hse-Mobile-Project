import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show StreamProvider;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'hive_box_names.dart';
import 'json_storage_codec.dart';

part 'submit_queue_service.freezed.dart';
part 'submit_queue_service.g.dart';

class SubmitQueueService {
  const SubmitQueueService(this._box);

  final Box<dynamic> _box;

  Future<void> enqueue(SubmitQueueItem item) async {
    await _box.put(item.id, JsonStorageCodec.normalize(item.toJson()));
  }

  Future<void> upsertIpal(SubmitQueueItem item) async {
    final date = item.displayDate ?? item.payload['tanggal']?.toString();
    final existing = pendingItems().where((pendingItem) {
      return pendingItem.endpoint == '/ipal/logs' &&
          (pendingItem.displayDate ??
                  pendingItem.payload['tanggal']?.toString()) ==
              date;
    }).firstOrNull;

    if (existing == null) {
      await enqueue(item);
      return;
    }

    await enqueue(
      existing.copyWith(
        payload: item.payload,
        createdAt: item.createdAt,
        attempts: 0,
        status: SubmitQueueStatus.pending.name,
        lastError: null,
        moduleLabel: item.moduleLabel,
        displayDate: item.displayDate,
        locked: false,
      ),
    );
  }

  List<SubmitQueueItem> pendingItems() {
    return _box.values
        .whereType<Map>()
        .map(
          (item) => SubmitQueueItem.fromJson(
            JsonStorageCodec.normalizeMap(item) ?? const <String, dynamic>{},
          ),
        )
        .where((item) => item.status != SubmitQueueStatus.done.name)
        .toList(growable: false);
  }

  SubmitQueueItem? findById(String id) {
    final item = JsonStorageCodec.normalizeMap(_box.get(id));
    if (item == null) return null;

    final queueItem = SubmitQueueItem.fromJson(item);
    if (queueItem.status == SubmitQueueStatus.done.name) return null;

    return queueItem;
  }

  Future<void> markDone(String id) => _box.delete(id);

  Future<void> deleteItem(String id) => _box.delete(id);

  Future<void> markFailed(SubmitQueueItem item, String errorMessage) {
    return enqueue(
      item.copyWith(
        locked: false,
        status: SubmitQueueStatus.failed.name,
        attempts: item.attempts + 1,
        lastError: errorMessage,
      ),
    );
  }

  Future<void> updatePayload(
    String id,
    Map<String, dynamic> payload, {
    String? moduleLabel,
    String? displayDate,
  }) async {
    final item = findById(id);
    if (item == null) return;

    await enqueue(
      item.copyWith(
        payload: payload,
        moduleLabel: moduleLabel ?? item.moduleLabel,
        displayDate: displayDate ?? item.displayDate,
        locked: false,
        status: SubmitQueueStatus.pending.name,
        lastError: null,
      ),
    );
  }

  Future<void> lockItem(String id) async {
    final item = findById(id);
    if (item == null) return;

    await enqueue(item.copyWith(locked: true));
  }

  Future<void> unlockItem(String id) async {
    final item = findById(id);
    if (item == null) return;

    await enqueue(item.copyWith(locked: false));
  }
}

enum SubmitQueueStatus { pending, failed, done }

@freezed
abstract class SubmitQueueItem with _$SubmitQueueItem {
  const factory SubmitQueueItem({
    required String id,
    required String endpoint,
    required String method,
    required Map<String, dynamic> payload,
    required DateTime createdAt,
    @Default(0) int attempts,
    @Default('pending') String status,
    @Default(false) bool locked,
    String? moduleLabel,
    String? displayDate,
    String? lastError,
  }) = _SubmitQueueItem;

  factory SubmitQueueItem.fromJson(Map<String, dynamic> json) =>
      _$SubmitQueueItemFromJson(json);
}

@Riverpod(keepAlive: true)
SubmitQueueService submitQueueService(Ref ref) {
  return SubmitQueueService(Hive.box<dynamic>(HiveBoxNames.submitQueue));
}

final submitQueueItemsProvider = StreamProvider<List<SubmitQueueItem>>((ref) {
  final box = Hive.box<dynamic>(HiveBoxNames.submitQueue);
  final service = ref.watch(submitQueueServiceProvider);

  return box
      .watch()
      .map((_) => service.pendingItems())
      .startWith(service.pendingItems());
});

extension _StartWith<T> on Stream<T> {
  Stream<T> startWith(T value) async* {
    yield value;
    yield* this;
  }
}
