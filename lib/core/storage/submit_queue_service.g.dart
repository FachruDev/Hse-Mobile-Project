// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_queue_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubmitQueueItem _$SubmitQueueItemFromJson(Map<String, dynamic> json) =>
    _SubmitQueueItem(
      id: json['id'] as String,
      endpoint: json['endpoint'] as String,
      method: json['method'] as String,
      payload: json['payload'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      attempts: (json['attempts'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'pending',
      lastError: json['lastError'] as String?,
    );

Map<String, dynamic> _$SubmitQueueItemToJson(_SubmitQueueItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'endpoint': instance.endpoint,
      'method': instance.method,
      'payload': instance.payload,
      'createdAt': instance.createdAt.toIso8601String(),
      'attempts': instance.attempts,
      'status': instance.status,
      'lastError': instance.lastError,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(submitQueueService)
final submitQueueServiceProvider = SubmitQueueServiceProvider._();

final class SubmitQueueServiceProvider
    extends
        $FunctionalProvider<
          SubmitQueueService,
          SubmitQueueService,
          SubmitQueueService
        >
    with $Provider<SubmitQueueService> {
  SubmitQueueServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'submitQueueServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$submitQueueServiceHash();

  @$internal
  @override
  $ProviderElement<SubmitQueueService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubmitQueueService create(Ref ref) {
    return submitQueueService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubmitQueueService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubmitQueueService>(value),
    );
  }
}

String _$submitQueueServiceHash() =>
    r'192d64c83da4b65d0951fe787065f9dfada3ab48';
