// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ipal_process_master_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ipalProcessMaster)
final ipalProcessMasterProvider = IpalProcessMasterProvider._();

final class IpalProcessMasterProvider
    extends
        $FunctionalProvider<
          AsyncValue<IpalProcessMaster>,
          IpalProcessMaster,
          FutureOr<IpalProcessMaster>
        >
    with
        $FutureModifier<IpalProcessMaster>,
        $FutureProvider<IpalProcessMaster> {
  IpalProcessMasterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ipalProcessMasterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ipalProcessMasterHash();

  @$internal
  @override
  $FutureProviderElement<IpalProcessMaster> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<IpalProcessMaster> create(Ref ref) {
    return ipalProcessMaster(ref);
  }
}

String _$ipalProcessMasterHash() => r'f75555ac8a1298a5848e3860cd3c78b0555c0b2b';
