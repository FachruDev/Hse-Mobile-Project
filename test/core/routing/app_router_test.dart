import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/core/routing/app_router.dart';
import 'package:hse_mobile/features/auth/application/auth_session_controller.dart';
import 'package:hse_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:hse_mobile/features/auth/domain/repositories/auth_repository.dart';

void main() {
  testWidgets(
    'redirects incomplete authenticated session instead of throwing',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(
              const _FakeAuthRepository(AuthSession(isAuthenticated: true)),
            ),
          ],
          child: Consumer(
            builder: (context, ref, _) {
              return MaterialApp.router(
                routerConfig: ref.watch(appRouterProvider),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final exception = tester.takeException();

      expect(exception, isNull);
      expect(find.text('Masuk'), findsWidgets);
    },
  );
}

class _FakeAuthRepository implements AuthRepository {
  const _FakeAuthRepository(this.session);

  final AuthSession session;

  @override
  Future<AuthSession> restoreSession() async => session;

  @override
  Future<AuthSession> refreshSession({bool force = false}) async => session;

  @override
  Future<AuthSession> login({
    required String login,
    required String password,
    required String deviceName,
  }) async {
    return session;
  }

  @override
  Future<void> logout() async {}

  @override
  Future<void> updatePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {}
}
