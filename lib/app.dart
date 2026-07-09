import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/application/auth_session_controller.dart';
import 'features/sync/application/submit_queue_auto_sync_controller.dart';

class HseMobileApp extends ConsumerStatefulWidget {
  const HseMobileApp({super.key});

  @override
  ConsumerState<HseMobileApp> createState() => _HseMobileAppState();
}

class _HseMobileAppState extends ConsumerState<HseMobileApp>
    with WidgetsBindingObserver {
  Timer? _sessionRefreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _sessionRefreshTimer = Timer.periodic(
      const Duration(minutes: 10),
      (_) => _refreshOnlineState(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sessionRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshOnlineState();
    }
  }

  void _refreshOnlineState() {
    ref.read(authSessionControllerProvider.notifier).refreshSession();
    ref.read(submitQueueAutoSyncControllerProvider).retryWhenReachable();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    ref.watch(submitQueueAutoSyncControllerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'HSE Platform',
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
