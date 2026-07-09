import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/features/ipal/application/ipal_log_controller.dart';
import 'package:hse_mobile/features/ipal/presentation/widgets/ipal_today_log_guard.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID');
  });

  testWidgets('shows lock state when today log already exists', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ipalTodayLogProvider.overrideWith(
            (ref) async => {
              'id': 10,
              'tanggal': '2026-07-09',
              'operator': {'name': 'Operator IPAL'},
              'process_log': {'status': 'SUBMITTED'},
            },
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: IpalTodayLogGuard(child: Text('Form'))),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('Log IPAL hari ini sudah ada'), findsOneWidget);
    expect(find.textContaining('09 Juli 2026'), findsOneWidget);
    expect(find.text('Lihat Detail'), findsOneWidget);
    expect(find.text('Form'), findsNothing);
  });
}
