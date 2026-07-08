// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ipal_log_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
    required ({int month, int year}) super.argument,
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
    final argument = this.argument as ({int month, int year});
    return ipalLogList(ref, month: argument.month, year: argument.year);
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

String _$ipalLogListHash() => r'812bd2355f4ae3edca93d9b0db764d182d8e37bf';

final class IpalLogListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, dynamic>>,
          ({int month, int year})
        > {
  IpalLogListFamily._()
    : super(
        retry: null,
        name: r'ipalLogListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IpalLogListProvider call({required int month, required int year}) =>
      IpalLogListProvider._(argument: (month: month, year: year), from: this);

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

String _$ipalTodayLogHash() => r'7d1ccd3c118f4d1a20731698c5fdc1749d94b46f';
