import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/features/ipal/presentation/widgets/ipal_floating_scroll_controls.dart';

void main() {
  testWidgets('scrolls to bottom and back to top', (tester) async {
    final controller = ScrollController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              ListView(
                controller: controller,
                children: const [SizedBox(height: 2200)],
              ),
              IpalFloatingScrollControls(controller: controller),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pumpAndSettle();

    expect(controller.offset, closeTo(controller.position.maxScrollExtent, 1));

    await tester.tap(find.byIcon(Icons.keyboard_arrow_up));
    await tester.pumpAndSettle();

    expect(controller.offset, closeTo(0, 1));
  });
}
