import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/shared/pdf/hse_pdf_builders.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  late Uint8List regularFontBytes;
  late Uint8List boldFontBytes;

  setUpAll(() async {
    await initializeDateFormatting('id_ID');
    regularFontBytes = await File(
      'assets/fonts/roboto-regular.ttf',
    ).readAsBytes();
    boldFontBytes = await File('assets/fonts/roboto-bold.ttf').readAsBytes();
  });

  test('builds IPAL detail PDF bytes', () async {
    final bytes = await HsePdfBuilders.ipalDailyDetail(
      {
        'tanggal': '2026-07-09',
        'operator': {'name': 'Operator IPAL', 'external_id': 'operator.01'},
        'checklist': {
          'values': [
            {
              'status': 'OK',
              'note': 'Normal',
              'item': {
                'name': 'Pompa Transfer',
                'standard_condition': 'Berfungsi',
              },
            },
          ],
        },
        'process_log': {
          'status': 'SUBMITTED',
          'values': [
            {
              'value_number': 7.1,
              'note': 'Stabil',
              'item': {'name': 'pH', 'standard_condition': '6 - 9'},
            },
          ],
          'batches': [],
          'approval': {},
        },
      },
      regularFontBytes: regularFontBytes,
      boldFontBytes: boldFontBytes,
    );

    expect(bytes.length, greaterThan(1000));
    expect(ascii.decode(bytes.take(4).toList()), '%PDF');
  });

  test('builds B3 detail PDF bytes', () async {
    final bytes = await HsePdfBuilders.b3LogDetail(
      {
        'movement_type': 'MASUK',
        'movement_date': '2026-07-09',
        'movement_time': '08:30:00',
        'weight_kg': '12.5',
        'document_number': 'DOC-001',
        'waste_type': {'name': 'Lampu TL Bekas'},
        'initiator_department': {'name': 'Engineering'},
        'operator': {'name': 'Operator B3'},
      },
      regularFontBytes: regularFontBytes,
      boldFontBytes: boldFontBytes,
    );

    expect(bytes.length, greaterThan(1000));
    expect(ascii.decode(bytes.take(4).toList()), '%PDF');
  });
}
