// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ipal_log_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ipalLogRemoteDataSource)
final ipalLogRemoteDataSourceProvider = IpalLogRemoteDataSourceProvider._();

final class IpalLogRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          IpalLogRemoteDataSource,
          IpalLogRemoteDataSource,
          IpalLogRemoteDataSource
        >
    with $Provider<IpalLogRemoteDataSource> {
  IpalLogRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ipalLogRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ipalLogRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<IpalLogRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IpalLogRemoteDataSource create(Ref ref) {
    return ipalLogRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IpalLogRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IpalLogRemoteDataSource>(value),
    );
  }
}

String _$ipalLogRemoteDataSourceHash() =>
    r'f7dbbd6fa1dddcf9753fb4f71f819942d9c29649';

@ProviderFor(ipalLogRepository)
final ipalLogRepositoryProvider = IpalLogRepositoryProvider._();

final class IpalLogRepositoryProvider
    extends
        $FunctionalProvider<
          IpalLogRepository,
          IpalLogRepository,
          IpalLogRepository
        >
    with $Provider<IpalLogRepository> {
  IpalLogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ipalLogRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ipalLogRepositoryHash();

  @$internal
  @override
  $ProviderElement<IpalLogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IpalLogRepository create(Ref ref) {
    return ipalLogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IpalLogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IpalLogRepository>(value),
    );
  }
}

String _$ipalLogRepositoryHash() => r'23a55120a4d4c3e56f5c35dc976694f40ebaf981';
