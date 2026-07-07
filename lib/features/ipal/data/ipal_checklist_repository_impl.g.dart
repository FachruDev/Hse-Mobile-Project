// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ipal_checklist_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ipalChecklistRemoteDataSource)
final ipalChecklistRemoteDataSourceProvider =
    IpalChecklistRemoteDataSourceProvider._();

final class IpalChecklistRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          IpalChecklistRemoteDataSource,
          IpalChecklistRemoteDataSource,
          IpalChecklistRemoteDataSource
        >
    with $Provider<IpalChecklistRemoteDataSource> {
  IpalChecklistRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ipalChecklistRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ipalChecklistRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<IpalChecklistRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IpalChecklistRemoteDataSource create(Ref ref) {
    return ipalChecklistRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IpalChecklistRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IpalChecklistRemoteDataSource>(
        value,
      ),
    );
  }
}

String _$ipalChecklistRemoteDataSourceHash() =>
    r'2a9a053ed4a09f67dfc62aaf42532ff89f5f0824';

@ProviderFor(ipalChecklistRepository)
final ipalChecklistRepositoryProvider = IpalChecklistRepositoryProvider._();

final class IpalChecklistRepositoryProvider
    extends
        $FunctionalProvider<
          IpalChecklistRepository,
          IpalChecklistRepository,
          IpalChecklistRepository
        >
    with $Provider<IpalChecklistRepository> {
  IpalChecklistRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ipalChecklistRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ipalChecklistRepositoryHash();

  @$internal
  @override
  $ProviderElement<IpalChecklistRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IpalChecklistRepository create(Ref ref) {
    return ipalChecklistRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IpalChecklistRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IpalChecklistRepository>(value),
    );
  }
}

String _$ipalChecklistRepositoryHash() =>
    r'ddbc3be87351bb88be6220bd0e6d158049039f40';
