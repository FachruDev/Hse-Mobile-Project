// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'b3_report_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(b3ReportRepository)
final b3ReportRepositoryProvider = B3ReportRepositoryProvider._();

final class B3ReportRepositoryProvider
    extends
        $FunctionalProvider<
          B3ReportRepository,
          B3ReportRepository,
          B3ReportRepository
        >
    with $Provider<B3ReportRepository> {
  B3ReportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'b3ReportRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$b3ReportRepositoryHash();

  @$internal
  @override
  $ProviderElement<B3ReportRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  B3ReportRepository create(Ref ref) {
    return b3ReportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(B3ReportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<B3ReportRepository>(value),
    );
  }
}

String _$b3ReportRepositoryHash() =>
    r'7da14b7adac62d84bb602dba1787552354060add';
