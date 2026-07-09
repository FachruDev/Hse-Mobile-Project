import 'package:intl/intl.dart';

class HseDateTimeFormatter {
  const HseDateTimeFormatter._();

  static final DateFormat _dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');
  static final DateFormat _shortDateFormat = DateFormat('dd MMM yyyy', 'id_ID');
  static final DateFormat _timeFormat = DateFormat('HH:mm', 'id_ID');
  static final DateFormat _dateTimeFormat = DateFormat(
    'dd MMMM yyyy, HH:mm',
    'id_ID',
  );

  static String date(Object? value, {String fallback = '-'}) {
    final parsed = _parseDateTime(value);
    if (parsed == null) return fallback;
    return _dateFormat.format(parsed);
  }

  static String shortDate(Object? value, {String fallback = '-'}) {
    final parsed = _parseDateTime(value);
    if (parsed == null) return fallback;
    return _shortDateFormat.format(parsed);
  }

  static String time(Object? value, {String fallback = '-'}) {
    final parsed = _parseTime(value);
    if (parsed == null) return fallback;
    return _timeFormat.format(parsed);
  }

  static String dateTime(Object? value, {String fallback = '-'}) {
    final parsed = _parseDateTime(value);
    if (parsed == null) return fallback;
    return _dateTimeFormat.format(parsed);
  }

  static String dateAndTime(
    Object? date,
    Object? time, {
    String fallback = '-',
  }) {
    final parsedDate = _parseDateTime(date);
    final parsedTime = _parseTime(time);
    if (parsedDate == null && parsedTime == null) return fallback;
    if (parsedDate == null) return _timeFormat.format(parsedTime!);
    if (parsedTime == null) return _dateFormat.format(parsedDate);

    final combined = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );
    return _dateTimeFormat.format(combined);
  }

  static DateTime? _parseDateTime(Object? value) {
    if (value is DateTime) return value;
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) return null;

    return DateTime.tryParse(text);
  }

  static DateTime? _parseTime(Object? value) {
    if (value is DateTime) return value;
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) return null;

    final dateTime = DateTime.tryParse(text);
    if (dateTime != null) return dateTime;

    final match = RegExp(r'^(\d{1,2}):(\d{2})(?::(\d{2}))?$').firstMatch(text);
    if (match == null) return null;

    final hour = int.tryParse(match.group(1) ?? '');
    final minute = int.tryParse(match.group(2) ?? '');
    if (hour == null || minute == null || hour > 23 || minute > 59) {
      return null;
    }

    return DateTime(0, 1, 1, hour, minute);
  }
}
