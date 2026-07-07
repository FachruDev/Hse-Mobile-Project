import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/application/auth_session_controller.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/b3/presentation/b3_log_detail_screen.dart';
import '../../features/b3/presentation/b3_log_list_screen.dart';
import '../../features/b3/presentation/b3_monthly_report_screen.dart';
import '../../features/b3/presentation/b3_storage_form_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/ipal/presentation/ipal_checklist_form_screen.dart';
import '../../features/ipal/presentation/ipal_log_detail_screen.dart';
import '../../features/ipal/presentation/ipal_log_list_screen.dart';
import '../../features/ipal/presentation/ipal_process_form_screen.dart';
import '../permissions/app_permissions.dart';
import 'not_authorized_screen.dart';
import 'splash_screen.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

const _routePermissions = <String, List<String>>{
  '/form/ipal/proses': [
    AppPermissions.masterProcessView,
    AppPermissions.masterBatchView,
    AppPermissions.ipalLogsCreate,
  ],
  '/form/ipal/checklist': [
    AppPermissions.masterChecklistView,
    AppPermissions.ipalLogsCreate,
  ],
  '/form/b3': [
    AppPermissions.b3StorageMasterView,
    AppPermissions.b3StorageLogsCreate,
  ],
  '/riwayat/ipal': [AppPermissions.ipalLogsView],
  '/riwayat/b3': [AppPermissions.b3StorageLogsView],
  '/laporan/b3': [AppPermissions.b3StorageMonthlyReportView],
};

List<String>? _requiredPermissionsForPath(String path) {
  final exact = _routePermissions[path];
  if (exact != null) return exact;

  if (path.startsWith('/riwayat/ipal/')) {
    return _routePermissions['/riwayat/ipal'];
  }
  if (path.startsWith('/riwayat/b3/')) {
    return _routePermissions['/riwayat/b3'];
  }
  return null;
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authSessionControllerProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/beranda',
    redirect: (context, state) {
      final path = state.uri.path;
      final isLogin = path == '/login';
      final isSplash = path == '/splash';
      final session = authState.value;

      if (authState.isLoading) {
        return isSplash ? null : '/splash';
      }

      if (session == null || !session.isAuthenticated) {
        return isLogin ? null : '/login';
      }

      if (isLogin || isSplash) return '/beranda';

      final requiredPermissions = _requiredPermissionsForPath(path);
      if (requiredPermissions != null &&
          !session.user!.canAll(requiredPermissions)) {
        return '/tidak-berwenang';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/beranda',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/form/ipal/proses',
        builder: (context, state) => const IpalProcessFormScreen(),
      ),
      GoRoute(
        path: '/form/ipal/checklist',
        builder: (context, state) => const IpalChecklistFormScreen(),
      ),
      GoRoute(
        path: '/form/b3',
        builder: (context, state) => const B3StorageFormScreen(),
      ),
      GoRoute(
        path: '/riwayat/ipal',
        builder: (context, state) => const IpalLogListScreen(),
      ),
      GoRoute(
        path: '/riwayat/ipal/:id',
        builder: (context, state) => IpalLogDetailScreen(
          logId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: '/riwayat/b3',
        builder: (context, state) => const B3LogListScreen(),
      ),
      GoRoute(
        path: '/riwayat/b3/:id',
        builder: (context, state) => B3LogDetailScreen(
          logId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: '/laporan/b3',
        builder: (context, state) => const B3MonthlyReportScreen(),
      ),
      GoRoute(
        path: '/tidak-berwenang',
        builder: (context, state) => const NotAuthorizedScreen(),
      ),
    ],
  );
}
