import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../auth/application/auth_session_controller.dart';
import 'submit_queue_controller.dart';

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final submitQueueAutoSyncControllerProvider =
    Provider<SubmitQueueAutoSyncController>((ref) {
      final connectivity = ref.watch(connectivityProvider);
      final apiClient = ref.watch(apiClientProvider);
      final queueProcessor = ref.watch(submitQueueProcessorProvider);
      final controller = SubmitQueueAutoSyncController(
        connectivityChanges: connectivity.onConnectivityChanged,
        checkConnectivity: connectivity.checkConnectivity,
        retryPending: queueProcessor.retryPending,
        isApiReachable: () async {
          try {
            await apiClient.get<Map<String, dynamic>>('/auth/me');
            return true;
          } catch (_) {
            return false;
          }
        },
        isAuthenticated: () {
          final session = ref.read(authSessionControllerProvider).value;
          return session?.isAuthenticated ?? false;
        },
      );

      ref.listen(authSessionControllerProvider, (_, next) {
        final session = next.value;
        if (session?.isAuthenticated ?? false) {
          controller.retryWhenReachable();
        }
      });

      controller.start();
      ref.onDispose(controller.dispose);
      return controller;
    });

class SubmitQueueAutoSyncController {
  SubmitQueueAutoSyncController({
    required Stream<List<ConnectivityResult>> connectivityChanges,
    required Future<List<ConnectivityResult>> Function() checkConnectivity,
    required Future<int> Function() retryPending,
    required Future<bool> Function() isApiReachable,
    required bool Function() isAuthenticated,
  }) : _connectivityChanges = connectivityChanges,
       _checkConnectivity = checkConnectivity,
       _retryPending = retryPending,
       _isApiReachable = isApiReachable,
       _isAuthenticated = isAuthenticated;

  final Stream<List<ConnectivityResult>> _connectivityChanges;
  final Future<List<ConnectivityResult>> Function() _checkConnectivity;
  final Future<int> Function() _retryPending;
  final Future<bool> Function() _isApiReachable;
  final bool Function() _isAuthenticated;

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isRetrying = false;

  void start() {
    _subscription ??= _connectivityChanges.listen((results) {
      if (_hasNetwork(results)) {
        retryWhenReachable();
      }
    });

    retryWhenReachable();
  }

  Future<int> retryWhenReachable() async {
    if (_isRetrying || !_isAuthenticated()) return 0;

    _isRetrying = true;
    try {
      final results = await _checkConnectivity();
      if (!_hasNetwork(results)) return 0;
      if (!await _isApiReachable()) return 0;

      return _retryPending();
    } finally {
      _isRetrying = false;
    }
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  bool _hasNetwork(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }
}
