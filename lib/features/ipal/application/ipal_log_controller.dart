import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/permissions/app_permissions.dart';
import '../../../shared/utils/api_response_parser.dart';
import '../../auth/application/auth_session_controller.dart';
import '../data/ipal_log_repository.dart';

part 'ipal_log_controller.g.dart';

@riverpod
Future<Map<String, dynamic>> ipalLogList(
  Ref ref, {
  required int month,
  required int year,
  String? dateFrom,
  String? dateTo,
}) {
  return ref
      .watch(ipalLogRepositoryProvider)
      .listLogs(month: month, year: year, dateFrom: dateFrom, dateTo: dateTo);
}

@riverpod
Future<Map<String, dynamic>> ipalLogDetail(Ref ref, int logId) {
  return ref.watch(ipalLogRepositoryProvider).detailLog(logId);
}

@riverpod
Future<Map<String, dynamic>?> ipalTodayLog(Ref ref) async {
  final session = ref.watch(authSessionControllerProvider).value;
  final user = session?.user;
  if (user == null ||
      !user.canAny([
        AppPermissions.ipalLogsViewOwn,
        AppPermissions.ipalLogsViewAll,
        AppPermissions.ipalLogsView,
      ])) {
    return null;
  }

  final today = DateTime.now();
  final todayText = _dateText(today);
  final response = await ref
      .watch(ipalLogRepositoryProvider)
      .listLogs(month: today.month, year: today.year, perPage: 100);

  for (final row in apiRows(response)) {
    if (textValue(row['tanggal'], fallback: '') != todayText) continue;
    final operatorId = pathValue(row, ['operator', 'id']);
    final operatorExternalId = textValue(
      pathValue(row, ['operator', 'external_id']),
      fallback: '',
    );

    if (operatorId?.toString() == user.id.toString() ||
        operatorExternalId == user.userId) {
      return row;
    }
  }

  return null;
}

String _dateText(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}
