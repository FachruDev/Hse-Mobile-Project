import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/shared/widgets/hse_confirm_dialog.dart';

void main() {
  testWidgets('returns true when confirm action is selected', (tester) async {
    bool? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                result = await showHseConfirmDialog(
                  context: context,
                  title: 'Konfirmasi',
                  message: 'Lanjutkan aksi ini?',
                  confirmLabel: 'Lanjutkan',
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lanjutkan'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
  });

  testWidgets('returns false when cancel action is selected', (tester) async {
    bool? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                result = await showHseConfirmDialog(
                  context: context,
                  title: 'Konfirmasi',
                  message: 'Batalkan aksi ini?',
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();

    expect(result, isFalse);
  });
}
