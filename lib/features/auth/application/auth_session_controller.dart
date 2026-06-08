import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/session/unauthorized_signal.dart';
import '../../../core/storage/secure_token_storage.dart';
import '../data/auth_repository_impl.dart';
import '../domain/entities/auth_session.dart';
import '../domain/repositories/auth_repository.dart';

part 'auth_session_controller.g.dart';

@riverpod
class AuthSessionController extends _$AuthSessionController {
  @override
  FutureOr<AuthSession> build() {
    ref.watch(unauthorizedSignalProvider);
    return ref.watch(authRepositoryProvider).restoreSession();
  }

  Future<void> login({required String userId, required String email}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .login(userId: userId, email: email, deviceName: 'flutter-mobile'),
    );
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(AuthSession());
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    tokenStorage: ref.watch(secureTokenStorageProvider),
  );
}
