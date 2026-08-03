import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/features/ipal/application/ipal_log_controller.dart';

void main() {
  test('ipalSelectedDateProvider menyimpan tanggal pilihan operator', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(ipalSelectedDateProvider.notifier).set(DateTime(2026, 6, 8));

    expect(container.read(ipalSelectedDateProvider), DateTime(2026, 6, 8));
  });
}
