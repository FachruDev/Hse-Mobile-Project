import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/shared/widgets/hse_brand_mark.dart';

void main() {
  testWidgets('uses the configured logo asset', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: HseBrandMark())),
    );

    final image = tester.widget<Image>(find.byType(Image));
    expect((image.image as AssetImage).assetName, 'assets/icons/logo.png');
  });
}
