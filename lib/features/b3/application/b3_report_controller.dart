import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/b3_report_repository.dart';

part 'b3_report_controller.g.dart';

@riverpod
Future<Map<String, dynamic>> b3MonthlyReport(
  Ref ref, {
  required int month,
  required int year,
}) {
  return ref
      .watch(b3ReportRepositoryProvider)
      .monthlyReport(month: month, year: year);
}
