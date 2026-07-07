// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_queue_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(submitQueueProcessor)
final submitQueueProcessorProvider = SubmitQueueProcessorProvider._();

final class SubmitQueueProcessorProvider
    extends
        $FunctionalProvider<
          SubmitQueueProcessor,
          SubmitQueueProcessor,
          SubmitQueueProcessor
        >
    with $Provider<SubmitQueueProcessor> {
  SubmitQueueProcessorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'submitQueueProcessorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$submitQueueProcessorHash();

  @$internal
  @override
  $ProviderElement<SubmitQueueProcessor> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubmitQueueProcessor create(Ref ref) {
    return submitQueueProcessor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubmitQueueProcessor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubmitQueueProcessor>(value),
    );
  }
}

String _$submitQueueProcessorHash() =>
    r'7f6f8480d670cf9dcc1ca31913bcb3633b9eb8b0';
