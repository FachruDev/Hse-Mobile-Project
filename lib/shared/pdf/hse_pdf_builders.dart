import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../utils/api_response_parser.dart';
import '../utils/hse_datetime_formatter.dart';

class HsePdfBuilders {
  const HsePdfBuilders._();

  static Future<Uint8List> ipalDailyDetail(
    Map<String, dynamic> data, {
    Uint8List? logoBytes,
    Uint8List? regularFontBytes,
    Uint8List? boldFontBytes,
  }) async {
    final document = pw.Document();
    final logo = _logo(logoBytes);
    final pageTheme = _pageTheme(
      regularFontBytes: regularFontBytes,
      boldFontBytes: boldFontBytes,
    );
    final processLog = _map(pathValue(data, ['process_log']));
    final status = textValue(processLog['status'], fallback: 'DRAFT');

    document.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (context) => [
          _header(
            logo: logo,
            title: 'Catatan Harian IPAL',
            subtitle:
                'Dokumen ini dibuat dari data checklist, catatan proses, dan batch mixing harian IPAL.',
          ),
          _metaTable([
            ['Tanggal', HseDateTimeFormatter.date(data['tanggal'])],
            ['Operator', _operatorLabel(data)],
            ['Status', status],
          ]),
          pw.SizedBox(height: 14),
          _sectionTitle('Checklist Harian'),
          _checklistTable(data),
          pw.SizedBox(height: 14),
          _sectionTitle('Catatan Proses'),
          _processTable(data),
          pw.SizedBox(height: 14),
          _sectionTitle('Batch Mixing'),
          _batchTable(data),
          pw.SizedBox(height: 18),
          _signatureTable([
            [
              'Operator IPAL',
              textValue(pathValue(data, ['operator', 'name'])),
            ],
            ['Status Dokumen', status],
          ]),
        ],
      ),
    );

    return document.save();
  }

  static Future<Uint8List> b3LogDetail(
    Map<String, dynamic> data, {
    Uint8List? logoBytes,
    Uint8List? regularFontBytes,
    Uint8List? boldFontBytes,
  }) async {
    final document = pw.Document();
    final logo = _logo(logoBytes);
    final pageTheme = _pageTheme(
      regularFontBytes: regularFontBytes,
      boldFontBytes: boldFontBytes,
    );
    final wasteName = textValue(
      pathValue(data, ['waste_type', 'name']),
      fallback: textValue(data['waste_type_other']),
    );
    final departmentName = textValue(
      pathValue(data, ['initiator_department', 'name']),
      fallback: textValue(data['initiator_department_other']),
    );
    final initiatorUserName = textValue(
      data['initiator_user_name'],
      fallback: textValue(pathValue(data, ['initiator_user', 'name'])),
    );
    final operatorName = textValue(
      pathValue(data, ['operator', 'name']),
      fallback: textValue(data['operator_name']),
    );

    document.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (context) => [
          _header(
            logo: logo,
            title: 'Detail Form Penyimpanan Limbah B3',
            subtitle:
                'Dokumen ini dibuat dari data log penyimpanan limbah B3 yang dipilih.',
          ),
          _detailTable([
            ['Tipe Pergerakan', textValue(data['movement_type'])],
            [
              'Tanggal dan Jam',
              HseDateTimeFormatter.dateAndTime(
                data['movement_date'],
                data['movement_time'],
              ),
            ],
            ['Jenis Limbah', wasteName],
            ['Berat (Kg)', '${textValue(data['weight_kg'])} kg'],
            ['No. Dokumen', textValue(data['document_number'])],
            ['Dept. Inisiator', departmentName],
            ['Petugas Dept. Inisiator', initiatorUserName],
            ['Operator TPS LB3', operatorName],
            ['Catatan', textValue(data['note'])],
            ['Dibuat Pada', HseDateTimeFormatter.dateTime(data['created_at'])],
          ]),
          pw.SizedBox(height: 18),
          _signatureTable([
            ['Petugas Dept. Inisiator', initiatorUserName],
            ['Operator TPS LB3', operatorName],
          ]),
        ],
      ),
    );

    return document.save();
  }

  static pw.PageTheme _pageTheme({
    required Uint8List? regularFontBytes,
    required Uint8List? boldFontBytes,
  }) {
    final regularFont = regularFontBytes == null
        ? null
        : pw.Font.ttf(ByteData.sublistView(regularFontBytes));
    final boldFont = boldFontBytes == null
        ? null
        : pw.Font.ttf(ByteData.sublistView(boldFontBytes));

    return pw.PageTheme(
      margin: const pw.EdgeInsets.all(28),
      theme: regularFont == null
          ? pw.ThemeData.base()
          : pw.ThemeData.withFont(base: regularFont, bold: boldFont),
    );
  }

  static pw.MemoryImage? _logo(Uint8List? logoBytes) {
    if (logoBytes == null || logoBytes.isEmpty) return null;
    return pw.MemoryImage(logoBytes);
  }

  static pw.Widget _header({
    required pw.MemoryImage? logo,
    required String title,
    required String subtitle,
  }) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (logo != null) ...[
          pw.Container(
            width: 42,
            height: 42,
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
            ),
            child: pw.Image(logo, fit: pw.BoxFit.contain),
          ),
          pw.SizedBox(width: 12),
        ],
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                title.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                subtitle,
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _sectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Text(
        title,
        style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _metaTable(List<List<String>> rows) {
    return pw.Container(
      width: 360,
      margin: const pw.EdgeInsets.only(top: 12),
      child: pw.Table(
        columnWidths: const {
          0: pw.FixedColumnWidth(88),
          1: pw.FlexColumnWidth(),
        },
        children: [
          for (final row in rows)
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 3),
                  child: pw.Text(
                    row[0],
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 3),
                  child: pw.Text(
                    ': ${row[1]}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  static pw.Widget _detailTable(List<List<String>> rows) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      columnWidths: const {
        0: pw.FixedColumnWidth(150),
        1: pw.FlexColumnWidth(),
      },
      children: [
        for (final row in rows)
          pw.TableRow(
            children: [
              _cell(row[0], bold: true, background: PdfColors.grey200),
              _cell(row[1]),
            ],
          ),
      ],
    );
  }

  static pw.Widget _checklistTable(Map<String, dynamic> data) {
    final values = _list(pathValue(data, ['checklist', 'values']));
    return _dataTable(
      headers: ['No', 'Item', 'Standar', 'Status', 'Catatan'],
      rows: [
        for (var index = 0; index < values.length; index++)
          [
            '${index + 1}',
            textValue(pathValue(values[index], ['item', 'name'])),
            textValue(pathValue(values[index], ['item', 'standard_condition'])),
            _checklistStatusLabel(values[index]['status']),
            textValue(values[index]['note']),
          ],
      ],
      emptyText: 'Tidak ada data checklist.',
    );
  }

  static pw.Widget _processTable(Map<String, dynamic> data) {
    final values = _list(pathValue(data, ['process_log', 'values']));
    return _dataTable(
      headers: ['No', 'Proses', 'Standar', 'Kondisi Aktual', 'Catatan'],
      rows: [
        for (var index = 0; index < values.length; index++)
          [
            '${index + 1}',
            textValue(pathValue(values[index], ['item', 'name'])),
            textValue(pathValue(values[index], ['item', 'standard_condition'])),
            _actualValue(values[index]),
            textValue(values[index]['note']),
          ],
      ],
      emptyText: 'Tidak ada data catatan proses.',
    );
  }

  static pw.Widget _batchTable(Map<String, dynamic> data) {
    final batches = _list(pathValue(data, ['process_log', 'batches']));
    final rows = <List<String>>[];
    for (final batch in batches) {
      final values = _list(batch['values']);
      if (values.isEmpty) {
        rows.add(['Batch ${textValue(batch['batch_no'])}', '-', '-']);
        continue;
      }

      for (final value in values) {
        rows.add([
          'Batch ${textValue(batch['batch_no'])}',
          textValue(pathValue(value, ['item', 'name'])),
          _actualValue(value),
        ]);
      }
    }

    return _dataTable(
      headers: ['Batch', 'Item', 'Nilai Aktual'],
      rows: rows,
      emptyText: 'Tidak ada data batch mixing.',
    );
  }

  static pw.Widget _dataTable({
    required List<String> headers,
    required List<List<String>> rows,
    required String emptyText,
  }) {
    if (rows.isEmpty) {
      return pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey400),
        ),
        child: pw.Text(
          emptyText,
          textAlign: pw.TextAlign.center,
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            for (final header in headers)
              _cell(header, bold: true, center: true),
          ],
        ),
        for (final row in rows)
          pw.TableRow(children: [for (final value in row) _cell(value)]),
      ],
    );
  }

  static pw.Widget _signatureTable(List<List<String>> signatures) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: [
        pw.TableRow(
          children: [
            for (final signature in signatures)
              pw.Container(
                height: 76,
                padding: const pw.EdgeInsets.all(8),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      signature[0],
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                    pw.SizedBox(height: 18),
                    pw.Text(
                      signature[1],
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _cell(
    String value, {
    bool bold = false,
    bool center = false,
    PdfColor? background,
  }) {
    return pw.Container(
      color: background,
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        value,
        textAlign: center ? pw.TextAlign.center : pw.TextAlign.left,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static String _operatorLabel(Map<String, dynamic> data) {
    final name = textValue(pathValue(data, ['operator', 'name']));
    final externalId = textValue(
      pathValue(data, ['operator', 'external_id']),
      fallback: '',
    );

    return externalId.isEmpty ? name : '$name ($externalId)';
  }

  static String _actualValue(Map<String, dynamic> value) {
    final number = textValue(value['value_number'], fallback: '');
    if (number.isNotEmpty) return number;

    return textValue(value['value_text']);
  }

  static String _checklistStatusLabel(Object? status) {
    return switch (textValue(status, fallback: '')) {
      'OK' => 'Ya',
      'NOT_OK' => 'Tidak',
      'NA' => 'N/A',
      _ => '-',
    };
  }

  static Map<String, dynamic> _map(Object? value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }

  static List<Map<String, dynamic>> _list(Object? value) {
    if (value is! List) return const <Map<String, dynamic>>[];
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }
}
