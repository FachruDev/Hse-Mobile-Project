import '../entities/auth_session.dart';

abstract interface class AuthRepository {
  Future<AuthSession> restoreSession();

  Future<AuthSession> login({
    required String userId,
    required String email,
    required String deviceName,
  });

  Future<void> logout();
}
