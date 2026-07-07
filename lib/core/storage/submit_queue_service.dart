import 'package:hive_flutter/hive_flutter.dart';
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

  Future<void> markDone(String id) => _box.delete(id);

  Future<void> markFailed(SubmitQueueItem item, String errorMessage) {
    return enqueue(
      item.copyWith(
        status: SubmitQueueStatus.failed.name,
        attempts: item.attempts + 1,
        lastError: errorMessage,
      ),
    );
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
    String? lastError,
  }) = _SubmitQueueItem;

  factory SubmitQueueItem.fromJson(Map<String, dynamic> json) =>
      _$SubmitQueueItemFromJson(json);
}

@Riverpod(keepAlive: true)
SubmitQueueService submitQueueService(Ref ref) {
  return SubmitQueueService(Hive.box<dynamic>(HiveBoxNames.submitQueue));
}
