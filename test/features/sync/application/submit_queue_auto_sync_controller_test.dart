import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/features/sync/application/submit_queue_auto_sync_controller.dart';

void main() {
  test(
    'retryWhenReachable mengirim antrean saat online dan API reachable',
    () async {
      var retryCount = 0;
      final controller = SubmitQueueAutoSyncController(
        connectivityChanges: const Stream.empty(),
        checkConnectivity: () async => [ConnectivityResult.wifi],
        retryPending: () async {
          retryCount++;
          return 1;
        },
        isApiReachable: () async => true,
        isAuthenticated: () => true,
      );

      final result = await controller.retryWhenReachable();

      expect(result, 1);
      expect(retryCount, 1);
    },
  );

  test(
    'retryWhenReachable tidak retry saat offline atau belum login',
    () async {
      var retryCount = 0;
      final controller = SubmitQueueAutoSyncController(
        connectivityChanges: const Stream.empty(),
        checkConnectivity: () async => [ConnectivityResult.none],
        retryPending: () async {
          retryCount++;
          return 1;
        },
        isApiReachable: () async => true,
        isAuthenticated: () => true,
      );

      expect(await controller.retryWhenReachable(), 0);
      expect(retryCount, 0);

      final unauthenticatedController = SubmitQueueAutoSyncController(
        connectivityChanges: const Stream.empty(),
        checkConnectivity: () async => [ConnectivityResult.wifi],
        retryPending: () async {
          retryCount++;
          return 1;
        },
        isApiReachable: () async => true,
        isAuthenticated: () => false,
      );

      expect(await unauthenticatedController.retryWhenReachable(), 0);
      expect(retryCount, 0);
    },
  );

  test('retryWhenReachable tidak menjalankan retry paralel', () async {
    var retryCount = 0;
    final completer = Completer<void>();
    final controller = SubmitQueueAutoSyncController(
      connectivityChanges: const Stream.empty(),
      checkConnectivity: () async => [ConnectivityResult.wifi],
      retryPending: () async {
        retryCount++;
        await completer.future;
        return 1;
      },
      isApiReachable: () async => true,
      isAuthenticated: () => true,
    );

    final firstRetry = controller.retryWhenReachable();
    final secondRetry = controller.retryWhenReachable();

    await Future<void>.delayed(Duration.zero);
    completer.complete();

    expect(await firstRetry, 1);
    expect(await secondRetry, 0);
    expect(retryCount, 1);
  });

  test('start retry saat koneksi berubah online', () async {
    final connectivityChanges = StreamController<List<ConnectivityResult>>();
    var retryCount = 0;
    final controller = SubmitQueueAutoSyncController(
      connectivityChanges: connectivityChanges.stream,
      checkConnectivity: () async => [ConnectivityResult.wifi],
      retryPending: () async {
        retryCount++;
        return 1;
      },
      isApiReachable: () async => true,
      isAuthenticated: () => true,
    );

    controller.start();
    connectivityChanges.add([ConnectivityResult.wifi]);
    await Future<void>.delayed(Duration.zero);
    await controller.dispose();
    await connectivityChanges.close();

    expect(retryCount, greaterThanOrEqualTo(1));
  });
}
