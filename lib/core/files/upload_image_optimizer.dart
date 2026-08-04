import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as img;

class UploadImageOptimizer {
  const UploadImageOptimizer._();

  static const maxUploadBytes = 900 * 1024;
  static const maxDimension = 1280;
  static const pickerImageQuality = 68;
  static const pickerMaxDimension = 1280.0;

  static Future<File?> optimize(String? path) async {
    if (path == null || path.isEmpty) return null;

    final source = File(path);
    if (!await source.exists()) return null;

    final sourceLength = await source.length();
    if (sourceLength <= maxUploadBytes) return source;

    final bytes = await source.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return source;

    var image = img.bakeOrientation(decoded);
    final longestSide = max(image.width, image.height);
    if (longestSide > maxDimension) {
      final scale = maxDimension / longestSide;
      image = img.copyResize(
        image,
        width: max(1, (image.width * scale).round()),
        height: max(1, (image.height * scale).round()),
        interpolation: img.Interpolation.average,
      );
    }

    final optimizedDirectory = Directory(
      '${Directory.systemTemp.path}${Platform.pathSeparator}hse-mobile-uploads',
    );
    if (!await optimizedDirectory.exists()) {
      await optimizedDirectory.create(recursive: true);
    }

    final baseName = _safeBaseName(source.uri.pathSegments.last);
    final lastModified = await source.lastModified();
    final target = File(
      '${optimizedDirectory.path}${Platform.pathSeparator}'
      '${baseName}_${sourceLength}_${lastModified.microsecondsSinceEpoch}.jpg',
    );

    if (await target.exists() && await target.length() <= maxUploadBytes) {
      return target;
    }

    for (final quality in const [72, 62, 52, 42, 34]) {
      await target.writeAsBytes(img.encodeJpg(image, quality: quality));
      if (await target.length() <= maxUploadBytes) {
        return target;
      }
    }

    return target;
  }

  static String _safeBaseName(String value) {
    final name = value.split('.').first;
    final safe = name.replaceAll(RegExp(r'[^a-zA-Z0-9_-]+'), '_');
    return safe.isEmpty ? 'upload' : safe;
  }
}
