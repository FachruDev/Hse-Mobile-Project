import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hse_mobile/core/storage/submit_queue_service.dart';
import 'package:hse_mobile/features/sync/presentation/widgets/submit_queue_status_banner.dart';

void main() {
  testWidgets('menampilkan status dan detail antrean submit', (tester) async {
    final item = SubmitQueueItem(
      id: 'queue-1',
      endpoint: '/ipal/logs',
      method: 'POST',
      payload: const {'tanggal': '2026-07-13'},
      createdAt: DateTime(2026, 7, 13),
      attempts: 1,
      status: SubmitQueueStatus.failed.name,
      lastError: 'Server belum bisa dijangkau.',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          submitQueueItemsProvider.overrideWith((ref) => Stream.value([item])),
        ],
        child: const MaterialApp(
          home: Scaffold(body: SubmitQueueStatusBanner()),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('1 form menunggu jaringan'), findsOneWidget);
    expect(find.text('Detail Antrean'), findsOneWidget);

    await tester.tap(find.text('Detail Antrean'));
    await tester.pumpAndSettle();

    expect(find.text('Log IPAL'), findsOneWidget);
    expect(find.text('Gagal sementara - percobaan 1'), findsOneWidget);
    expect(find.text('Server belum bisa dijangkau.'), findsOneWidget);
  });
}
