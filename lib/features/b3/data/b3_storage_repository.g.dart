// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'b3_storage_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(b3StorageRemoteDataSource)
final b3StorageRemoteDataSourceProvider = B3StorageRemoteDataSourceProvider._();

final class B3StorageRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          B3StorageRemoteDataSource,
          B3StorageRemoteDataSource,
          B3StorageRemoteDataSource
        >
    with $Provider<B3StorageRemoteDataSource> {
  B3StorageRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'b3StorageRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$b3StorageRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<B3StorageRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  B3StorageRemoteDataSource create(Ref ref) {
    return b3StorageRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(B3StorageRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<B3StorageRemoteDataSource>(value),
    );
  }
}

String _$b3StorageRemoteDataSourceHash() =>
    r'e3c1f80fd1cb7d51fcc3af6110db0e859e332a04';

@ProviderFor(b3StorageRepository)
final b3StorageRepositoryProvider = B3StorageRepositoryProvider._();

final class B3StorageRepositoryProvider
    extends
        $FunctionalProvider<
          B3StorageRepository,
          B3StorageRepository,
          B3StorageRepository
        >
    with $Provider<B3StorageRepository> {
  B3StorageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'b3StorageRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$b3StorageRepositoryHash();

  @$internal
  @override
  $ProviderElement<B3StorageRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  B3StorageRepository create(Ref ref) {
    return b3StorageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(B3StorageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<B3StorageRepository>(value),
    );
  }
}

String _$b3StorageRepositoryHash() =>
    r'25e8afdfd4ca1670c4685fdb9d7c1ab0406cc84a';
