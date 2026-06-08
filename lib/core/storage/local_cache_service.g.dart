// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_cache_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(masterDataCache)
final masterDataCacheProvider = MasterDataCacheProvider._();

final class MasterDataCacheProvider
    extends
        $FunctionalProvider<
          LocalCacheService,
          LocalCacheService,
          LocalCacheService
        >
    with $Provider<LocalCacheService> {
  MasterDataCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'masterDataCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$masterDataCacheHash();

  @$internal
  @override
  $ProviderElement<LocalCacheService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalCacheService create(Ref ref) {
    return masterDataCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalCacheService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalCacheService>(value),
    );
  }
}

String _$masterDataCacheHash() => r'c1f1b6cfbea1f88cbca9726102849bb4421ce969';

@ProviderFor(formDraftCache)
final formDraftCacheProvider = FormDraftCacheProvider._();

final class FormDraftCacheProvider
    extends
        $FunctionalProvider<
          LocalCacheService,
          LocalCacheService,
          LocalCacheService
        >
    with $Provider<LocalCacheService> {
  FormDraftCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'formDraftCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$formDraftCacheHash();

  @$internal
  @override
  $ProviderElement<LocalCacheService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalCacheService create(Ref ref) {
    return formDraftCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalCacheService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalCacheService>(value),
    );
  }
}

String _$formDraftCacheHash() => r'2be1996fc229aafa9693fbec82279b6f69452251';
