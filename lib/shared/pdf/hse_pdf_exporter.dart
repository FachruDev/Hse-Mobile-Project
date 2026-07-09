import 'dart:io';

import 'package:flutter/services.dart';
import 'package:printing/printing.dart';

class HsePdfExporter {
  const HsePdfExporter._();

  static Future<HsePdfExportResult> preview({
    required String fileName,
    required Future<Uint8List> Function(HsePdfExportAssets assets) build,
  }) async {
    final assets = await _assets();
    final pdfBytes = await build(assets);

    try {
      await Printing.layoutPdf(name: fileName, onLayout: (_) async => pdfBytes);
      return const HsePdfExportResult.previewed();
    } on MissingPluginException {
      final file = File('${Directory.systemTemp.path}/$fileName');
      await file.writeAsBytes(pdfBytes, flush: true);
      return HsePdfExportResult.savedToFile(file.path);
    }
  }

  static Future<HsePdfExportAssets> _assets() async {
    return HsePdfExportAssets(
      logoBytes: await _assetBytes('assets/icons/logo.png'),
      regularFontBytes: await _assetBytes('assets/fonts/roboto-regular.ttf'),
      boldFontBytes: await _assetBytes('assets/fonts/roboto-bold.ttf'),
    );
  }

  static Future<Uint8List?> _assetBytes(String path) async {
    try {
      final data = await rootBundle.load(path);
      return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    } catch (_) {
      return null;
    }
  }
}

class HsePdfExportAssets {
  const HsePdfExportAssets({
    required this.logoBytes,
    required this.regularFontBytes,
    required this.boldFontBytes,
  });

  final Uint8List? logoBytes;
  final Uint8List? regularFontBytes;
  final Uint8List? boldFontBytes;
}

class HsePdfExportResult {
  const HsePdfExportResult._({this.savedPath});

  const HsePdfExportResult.previewed() : this._();

  const HsePdfExportResult.savedToFile(String path) : this._(savedPath: path);

  final String? savedPath;

  bool get savedByFallback => savedPath != null;
}
