import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/shared/utils/hse_datetime_formatter.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID');
  });

  test('formats Indonesian date and time labels', () {
    expect(HseDateTimeFormatter.date('2026-07-09'), '09 Juli 2026');
    expect(
      HseDateTimeFormatter.date('2026-07-10T00:00:00.000000Z'),
      '10 Juli 2026',
    );
    expect(
      HseDateTimeFormatter.date('2026-07-30T00:00:00.000000Z'),
      '30 Juli 2026',
    );
    expect(
      HseDateTimeFormatter.date('2026-07-29T17:00:00.000000Z'),
      '30 Juli 2026',
    );
    expect(HseDateTimeFormatter.time('14:30:00'), '14:30');
    expect(
      HseDateTimeFormatter.dateAndTime('2026-07-09', '14:30:00'),
      '09 Juli 2026, 14:30',
    );
    expect(
      HseDateTimeFormatter.dateAndTime(
        '2026-07-30T00:00:00.000000Z',
        '08:15:00',
      ),
      '30 Juli 2026, 08:15',
    );
    expect(
      HseDateTimeFormatter.dateAndTime(
        '2026-07-29T17:00:00.000000Z',
        '08:15:00',
      ),
      '30 Juli 2026, 08:15',
    );
  });
}
