// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'b3_storage_log_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(b3StorageLogList)
final b3StorageLogListProvider = B3StorageLogListFamily._();

final class B3StorageLogListProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  B3StorageLogListProvider._({
    required B3StorageLogListFamily super.from,
    required ({int month, int year, String? dateFrom, String? dateTo})
    super.argument,
  }) : super(
         retry: null,
         name: r'b3StorageLogListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$b3StorageLogListHash();

  @override
  String toString() {
    return r'b3StorageLogListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    final argument =
        this.argument
            as ({int month, int year, String? dateFrom, String? dateTo});
    return b3StorageLogList(
      ref,
      month: argument.month,
      year: argument.year,
      dateFrom: argument.dateFrom,
      dateTo: argument.dateTo,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is B3StorageLogListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$b3StorageLogListHash() => r'cc94bc733e881608833804f4b14e1038956ac8a1';

final class B3StorageLogListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, dynamic>>,
          ({int month, int year, String? dateFrom, String? dateTo})
        > {
  B3StorageLogListFamily._()
    : super(
        retry: null,
        name: r'b3StorageLogListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  B3StorageLogListProvider call({
    required int month,
    required int year,
    String? dateFrom,
    String? dateTo,
  }) => B3StorageLogListProvider._(
    argument: (month: month, year: year, dateFrom: dateFrom, dateTo: dateTo),
    from: this,
  );

  @override
  String toString() => r'b3StorageLogListProvider';
}

@ProviderFor(b3StorageLogDetail)
final b3StorageLogDetailProvider = B3StorageLogDetailFamily._();

final class B3StorageLogDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  B3StorageLogDetailProvider._({
    required B3StorageLogDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'b3StorageLogDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$b3StorageLogDetailHash();

  @override
  String toString() {
    return r'b3StorageLogDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    final argument = this.argument as int;
    return b3StorageLogDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is B3StorageLogDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$b3StorageLogDetailHash() =>
    r'7f5aa46e033a2606fb6739a7a826f9c21cace3f0';

final class B3StorageLogDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<String, dynamic>>, int> {
  B3StorageLogDetailFamily._()
    : super(
        retry: null,
        name: r'b3StorageLogDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  B3StorageLogDetailProvider call(int logId) =>
      B3StorageLogDetailProvider._(argument: logId, from: this);

  @override
  String toString() => r'b3StorageLogDetailProvider';
}

@ProviderFor(b3StorageLogPhoto)
final b3StorageLogPhotoProvider = B3StorageLogPhotoFamily._();

final class B3StorageLogPhotoProvider
    extends
        $FunctionalProvider<
          AsyncValue<Uint8List>,
          Uint8List,
          FutureOr<Uint8List>
        >
    with $FutureModifier<Uint8List>, $FutureProvider<Uint8List> {
  B3StorageLogPhotoProvider._({
    required B3StorageLogPhotoFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'b3StorageLogPhotoProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$b3StorageLogPhotoHash();

  @override
  String toString() {
    return r'b3StorageLogPhotoProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Uint8List> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Uint8List> create(Ref ref) {
    final argument = this.argument as int;
    return b3StorageLogPhoto(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is B3StorageLogPhotoProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$b3StorageLogPhotoHash() => r'5be3b506e24bed1ed656abf1061545774d9f9afa';

final class B3StorageLogPhotoFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Uint8List>, int> {
  B3StorageLogPhotoFamily._()
    : super(
        retry: null,
        name: r'b3StorageLogPhotoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  B3StorageLogPhotoProvider call(int logId) =>
      B3StorageLogPhotoProvider._(argument: logId, from: this);

  @override
  String toString() => r'b3StorageLogPhotoProvider';
}
