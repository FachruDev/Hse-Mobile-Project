import 'package:flutter/services.dart';
import 'package:printing/printing.dart';

class HsePdfExporter {
  const HsePdfExporter._();

  static Future<void> preview({
    required String fileName,
    required Future<Uint8List> Function(Uint8List? logoBytes) build,
  }) async {
    final logoBytes = await _logoBytes();
    final pdfBytes = await build(logoBytes);

    await Printing.layoutPdf(name: fileName, onLayout: (_) async => pdfBytes);
  }

  static Future<Uint8List?> _logoBytes() async {
    try {
      final data = await rootBundle.load('assets/icons/logo.png');
      return data.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }
}
