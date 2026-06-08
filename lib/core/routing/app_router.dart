import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/application/auth_session_controller.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/forms/presentation/protected_placeholder_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import 'not_authorized_screen.dart';
import 'splash_screen.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

const _routePermissions = <String, List<String>>{
  '/form/ipal/proses': ['ipal.logs.create', 'ipal.logs.submit'],
  '/form/ipal/checklist': ['ipal.logs.create'],
  '/form/b3': ['b3storage.logs.create'],
  '/laporan/b3': ['b3storage.monthly-report.view'],
};

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

      final requiredPermissions = _routePermissions[path];
      if (requiredPermissions != null &&
          !session.user!.hasAnyPermission(requiredPermissions)) {
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
        builder: (context, state) => const ProtectedPlaceholderScreen(
          title: 'Catatan Proses IPAL',
          description: 'Proses harian dan batch mixing.',
          selectedPath: '/form/ipal/proses',
        ),
      ),
      GoRoute(
        path: '/form/ipal/checklist',
        builder: (context, state) => const ProtectedPlaceholderScreen(
          title: 'Checklist Pemeriksaan Harian',
          description: 'Status unit dan catatan pemeriksaan.',
          selectedPath: '/form/ipal/checklist',
        ),
      ),
      GoRoute(
        path: '/form/b3',
        builder: (context, state) => const ProtectedPlaceholderScreen(
          title: 'Form Penyimpanan Limbah B3',
          description: 'Log masuk atau keluar TPS LB3.',
          selectedPath: '/form/b3',
        ),
      ),
      GoRoute(
        path: '/laporan/b3',
        builder: (context, state) => const ProtectedPlaceholderScreen(
          title: 'Laporan Bulanan B3',
          description: 'Rekap dan approval bulanan penyimpanan limbah B3.',
          selectedPath: '/laporan/b3',
        ),
      ),
      GoRoute(
        path: '/tidak-berwenang',
        builder: (context, state) => const NotAuthorizedScreen(),
      ),
    ],
  );
}
