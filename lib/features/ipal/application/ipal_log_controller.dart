import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/permissions/app_permissions.dart';
import '../../../shared/utils/api_response_parser.dart';
import '../../auth/application/auth_session_controller.dart';
import '../data/ipal_log_repository.dart';

part 'ipal_log_controller.g.dart';

@Riverpod(keepAlive: true)
class IpalSelectedDate extends _$IpalSelectedDate {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void set(DateTime date) {
    state = DateTime(date.year, date.month, date.day);
  }
}

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
        AppPermissions.ipalLogsCreate,
        AppPermissions.ipalLogsViewAll,
        AppPermissions.ipalLogsView,
      ])) {
    return null;
  }

  final selectedDate = ref.watch(ipalSelectedDateProvider);
  final selectedDateText = _dateText(selectedDate);
  final response = await ref
      .watch(ipalLogRepositoryProvider)
      .listLogs(
        dateFrom: selectedDateText,
        dateTo: selectedDateText,
        perPage: 1,
      );

  for (final row in apiRows(response)) {
    if (textValue(row['tanggal'], fallback: '') == selectedDateText) {
      return row;
    }
  }

  return null;
}

@riverpod
Future<Map<String, IpalProcessReference>> ipalProcessReferences(Ref ref) async {
  final session = ref.watch(authSessionControllerProvider).value;
  final user = session?.user;
  if (user == null || !user.hasPermission(AppPermissions.ipalLogsCreate)) {
    return const <String, IpalProcessReference>{};
  }

  final selectedDate = ref.watch(ipalSelectedDateProvider);
  final response = await ref
      .watch(ipalLogRepositoryProvider)
      .processReferences(date: _dateText(selectedDate));
  final rows = apiRows(response);
  if (rows.isEmpty) return const <String, IpalProcessReference>{};

  final references = <String, IpalProcessReference>{};

  for (final row in rows) {
    final code = textValue(row['code'], fallback: '');
    final unit = switch (code) {
      'debit_inlet_flow_meter' => 'm3',
      'water_meter' => 'm3',
      _ => null,
    };
    if (unit == null) continue;

    final number = _numValue(row['previous_value']);
    final value = textValue(
      row['previous_display'],
      fallback: number == null ? '-' : _formatReferenceNumber(number),
    );

    references[code] = IpalProcessReference(
      code: code,
      section: textValue(row['section'], fallback: ''),
      name: textValue(row['name'], fallback: ''),
      date: textValue(row['previous_date'], fallback: '-'),
      value: value,
      number: number,
      unit: unit,
    );
  }

  return references;
}

String _dateText(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

class IpalProcessReference {
  const IpalProcessReference({
    required this.code,
    required this.section,
    required this.name,
    required this.date,
    required this.value,
    required this.unit,
    this.number,
  });

  final String code;
  final String section;
  final String name;
  final String date;
  final String value;
  final String unit;
  final num? number;
}

num? _numValue(Object? value) {
  if (value is num) return value;
  if (value is String) return num.tryParse(value);
  return null;
}

String _formatReferenceNumber(num value) {
  if (value % 1 == 0) return value.toInt().toString();
  return value.toString();
}
