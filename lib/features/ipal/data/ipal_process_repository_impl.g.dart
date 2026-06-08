// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ipal_process_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ipalProcessRemoteDataSource)
final ipalProcessRemoteDataSourceProvider =
    IpalProcessRemoteDataSourceProvider._();

final class IpalProcessRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          IpalProcessRemoteDataSource,
          IpalProcessRemoteDataSource,
          IpalProcessRemoteDataSource
        >
    with $Provider<IpalProcessRemoteDataSource> {
  IpalProcessRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ipalProcessRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ipalProcessRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<IpalProcessRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IpalProcessRemoteDataSource create(Ref ref) {
    return ipalProcessRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IpalProcessRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IpalProcessRemoteDataSource>(value),
    );
  }
}

String _$ipalProcessRemoteDataSourceHash() =>
    r'854f05164a8549e5f8ba47c53d54cc9453abddf0';

@ProviderFor(ipalProcessRepository)
final ipalProcessRepositoryProvider = IpalProcessRepositoryProvider._();

final class IpalProcessRepositoryProvider
    extends
        $FunctionalProvider<
          IpalProcessRepository,
          IpalProcessRepository,
          IpalProcessRepository
        >
    with $Provider<IpalProcessRepository> {
  IpalProcessRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ipalProcessRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ipalProcessRepositoryHash();

  @$internal
  @override
  $ProviderElement<IpalProcessRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IpalProcessRepository create(Ref ref) {
    return ipalProcessRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IpalProcessRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IpalProcessRepository>(value),
    );
  }
}

String _$ipalProcessRepositoryHash() =>
    r'cf8dbcec939487315d2c130d4353594da0a59ae1';
