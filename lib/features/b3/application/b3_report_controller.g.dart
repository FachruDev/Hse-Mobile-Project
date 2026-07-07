// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'b3_report_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(b3MonthlyReport)
final b3MonthlyReportProvider = B3MonthlyReportFamily._();

final class B3MonthlyReportProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  B3MonthlyReportProvider._({
    required B3MonthlyReportFamily super.from,
    required ({int month, int year}) super.argument,
  }) : super(
         retry: null,
         name: r'b3MonthlyReportProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$b3MonthlyReportHash();

  @override
  String toString() {
    return r'b3MonthlyReportProvider'
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
    return b3MonthlyReport(ref, month: argument.month, year: argument.year);
  }

  @override
  bool operator ==(Object other) {
    return other is B3MonthlyReportProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$b3MonthlyReportHash() => r'cc70ba481984bb267e9c6c4e91d40e1d121dbeaf';

final class B3MonthlyReportFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, dynamic>>,
          ({int month, int year})
        > {
  B3MonthlyReportFamily._()
    : super(
        retry: null,
        name: r'b3MonthlyReportProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  B3MonthlyReportProvider call({required int month, required int year}) =>
      B3MonthlyReportProvider._(
        argument: (month: month, year: year),
        from: this,
      );

  @override
  String toString() => r'b3MonthlyReportProvider';
}
