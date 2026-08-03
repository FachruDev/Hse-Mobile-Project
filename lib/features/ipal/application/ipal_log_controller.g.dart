// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ipal_log_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IpalSelectedDate)
final ipalSelectedDateProvider = IpalSelectedDateProvider._();

final class IpalSelectedDateProvider
    extends $NotifierProvider<IpalSelectedDate, DateTime> {
  IpalSelectedDateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ipalSelectedDateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ipalSelectedDateHash();

  @$internal
  @override
  IpalSelectedDate create() => IpalSelectedDate();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$ipalSelectedDateHash() => r'412dfb8b7f7a7b7ff1b4b1521c9d848a11474ad3';

abstract class _$IpalSelectedDate extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ipalLogList)
final ipalLogListProvider = IpalLogListFamily._();

final class IpalLogListProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  IpalLogListProvider._({
    required IpalLogListFamily super.from,
    required ({int month, int year, String? dateFrom, String? dateTo})
    super.argument,
  }) : super(
         retry: null,
         name: r'ipalLogListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ipalLogListHash();

  @override
  String toString() {
    return r'ipalLogListProvider'
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
    return ipalLogList(
      ref,
      month: argument.month,
      year: argument.year,
      dateFrom: argument.dateFrom,
      dateTo: argument.dateTo,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IpalLogListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ipalLogListHash() => r'3d8ecd99f86ac21c36ed75fdc4b9660489227e3b';

final class IpalLogListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, dynamic>>,
          ({int month, int year, String? dateFrom, String? dateTo})
        > {
  IpalLogListFamily._()
    : super(
        retry: null,
        name: r'ipalLogListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IpalLogListProvider call({
    required int month,
    required int year,
    String? dateFrom,
    String? dateTo,
  }) => IpalLogListProvider._(
    argument: (month: month, year: year, dateFrom: dateFrom, dateTo: dateTo),
    from: this,
  );

  @override
  String toString() => r'ipalLogListProvider';
}

@ProviderFor(ipalLogDetail)
final ipalLogDetailProvider = IpalLogDetailFamily._();

final class IpalLogDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  IpalLogDetailProvider._({
    required IpalLogDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'ipalLogDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ipalLogDetailHash();

  @override
  String toString() {
    return r'ipalLogDetailProvider'
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
    return ipalLogDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IpalLogDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ipalLogDetailHash() => r'08086f16742a51b8d6e68c70e9ae849626b32500';

final class IpalLogDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<String, dynamic>>, int> {
  IpalLogDetailFamily._()
    : super(
        retry: null,
        name: r'ipalLogDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IpalLogDetailProvider call(int logId) =>
      IpalLogDetailProvider._(argument: logId, from: this);

  @override
  String toString() => r'ipalLogDetailProvider';
}

@ProviderFor(ipalTodayLog)
final ipalTodayLogProvider = IpalTodayLogProvider._();

final class IpalTodayLogProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>?>,
          Map<String, dynamic>?,
          FutureOr<Map<String, dynamic>?>
        >
    with
        $FutureModifier<Map<String, dynamic>?>,
        $FutureProvider<Map<String, dynamic>?> {
  IpalTodayLogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ipalTodayLogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ipalTodayLogHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>?> create(Ref ref) {
    return ipalTodayLog(ref);
  }
}

String _$ipalTodayLogHash() => r'60fa909377d2afe47ea0e1a1dbe9e9f427577081';

@ProviderFor(ipalProcessReferences)
final ipalProcessReferencesProvider = IpalProcessReferencesProvider._();

final class IpalProcessReferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, IpalProcessReference>>,
          Map<String, IpalProcessReference>,
          FutureOr<Map<String, IpalProcessReference>>
        >
    with
        $FutureModifier<Map<String, IpalProcessReference>>,
        $FutureProvider<Map<String, IpalProcessReference>> {
  IpalProcessReferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ipalProcessReferencesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ipalProcessReferencesHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, IpalProcessReference>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, IpalProcessReference>> create(Ref ref) {
    return ipalProcessReferences(ref);
  }
}

String _$ipalProcessReferencesHash() =>
    r'ebfcad1266e233b42a68334f547236ec840cfdc5';
