import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/ipal_log_repository.dart';

part 'ipal_log_controller.g.dart';

@riverpod
Future<Map<String, dynamic>> ipalLogList(
  Ref ref, {
  required int month,
  required int year,
}) {
  return ref
      .watch(ipalLogRepositoryProvider)
      .listLogs(month: month, year: year);
}

@riverpod
Future<Map<String, dynamic>> ipalLogDetail(Ref ref, int logId) {
  return ref.watch(ipalLogRepositoryProvider).detailLog(logId);
}
