import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/core/files/upload_image_optimizer.dart';
import 'package:image/image.dart' as img;

void main() {
  test('optimize mengecilkan foto besar untuk upload antrean', () async {
    final source = await _largeImageFile('optimizer');
    addTearDown(() {
      if (source.existsSync()) source.deleteSync();
    });

    final optimized = await UploadImageOptimizer.optimize(source.path);

    expect(optimized, isNotNull);
    expect(await optimized!.length(), lessThanOrEqualTo(900 * 1024));
  });

  test('optimize melewati path kosong atau file hilang', () async {
    expect(await UploadImageOptimizer.optimize(null), isNull);
    expect(
      await UploadImageOptimizer.optimize('C:/file/tidak/ada.jpg'),
      isNull,
    );
  });
}

Future<File> _largeImageFile(String prefix) async {
  final random = Random(42);
  final image = img.Image(width: 1200, height: 1200);
  for (final pixel in image) {
    pixel
      ..r = random.nextInt(256)
      ..g = random.nextInt(256)
      ..b = random.nextInt(256);
  }

  final file = File(
    '${Directory.systemTemp.path}/$prefix-${DateTime.now().microsecondsSinceEpoch}.jpg',
  );
  await file.writeAsBytes(img.encodeJpg(image, quality: 100));

  return file;
}
