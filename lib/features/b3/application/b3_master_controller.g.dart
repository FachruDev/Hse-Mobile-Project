// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'b3_master_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(b3Master)
final b3MasterProvider = B3MasterProvider._();

final class B3MasterProvider
    extends
        $FunctionalProvider<
          AsyncValue<B3MasterState>,
          B3MasterState,
          FutureOr<B3MasterState>
        >
    with $FutureModifier<B3MasterState>, $FutureProvider<B3MasterState> {
  B3MasterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'b3MasterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$b3MasterHash();

  @$internal
  @override
  $FutureProviderElement<B3MasterState> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<B3MasterState> create(Ref ref) {
    return b3Master(ref);
  }
}

String _$b3MasterHash() => r'86a5b552a8f7ec998312f05afdd68a4ab6aba6f4';
