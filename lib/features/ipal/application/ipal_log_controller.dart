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

@riverpod
Future<Map<String, IpalProcessReference>> ipalProcessReferences(Ref ref) async {
  final session = ref.watch(authSessionControllerProvider).value;
  final user = session?.user;
  if (user == null ||
      !user.canAny([
        AppPermissions.ipalLogsViewOwn,
        AppPermissions.ipalLogsViewAll,
        AppPermissions.ipalLogsView,
      ])) {
    return const <String, IpalProcessReference>{};
  }

  final today = DateTime.now();
  final response = await ref
      .watch(ipalLogRepositoryProvider)
      .listLogs(
        dateFrom: _dateText(today.subtract(const Duration(days: 60))),
        dateTo: _dateText(today.subtract(const Duration(days: 1))),
        perPage: 100,
      );
  final rows = apiRows(response);
  if (rows.isEmpty) return const <String, IpalProcessReference>{};

  final latestLogId = _intValue(rows.first['id']);
  if (latestLogId == null) return const <String, IpalProcessReference>{};

  final latestLogDate = textValue(rows.first['tanggal'], fallback: '-');
  final detail = await ref
      .watch(ipalLogRepositoryProvider)
      .detailLog(latestLogId);
  final data = apiDataMap(detail);
  final values = _listValue(pathValue(data, ['process_log', 'values']));
  final references = <String, IpalProcessReference>{};

  for (final value in values) {
    final item = _mapValue(value['item']);
    final code = textValue(item['code'], fallback: '');
    final unit = switch (code) {
      'debit_inlet_flow_meter' => 'm3',
      'water_meter' => 'm3',
      _ => null,
    };
    if (unit == null) continue;

    final number = _numValue(value['value_number']);
    final text = textValue(value['value_text'], fallback: '');
    final displayValue = number != null ? _formatReferenceNumber(number) : text;

    if (displayValue.isEmpty) continue;

    references[code] = IpalProcessReference(
      date: latestLogDate,
      value: displayValue,
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
    required this.date,
    required this.value,
    required this.unit,
    this.number,
  });

  final String date;
  final String value;
  final String unit;
  final num? number;
}

int? _intValue(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
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

Map<String, dynamic> _mapValue(Object? value) {
  if (value is Map) return Map<String, dynamic>.from(value);
  return const <String, dynamic>{};
}

List<Map<String, dynamic>> _listValue(Object? value) {
  if (value is! List) return const <Map<String, dynamic>>[];
  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList(growable: false);
}
