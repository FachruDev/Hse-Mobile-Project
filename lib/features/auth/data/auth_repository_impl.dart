import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/storage/secure_token_storage.dart';
import '../domain/entities/auth_session.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_remote_data_source.dart';

part 'auth_repository_impl.g.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureTokenStorage tokenStorage,
  }) : _remoteDataSource = remoteDataSource,
       _tokenStorage = tokenStorage;

  final AuthRemoteDataSource _remoteDataSource;
  final SecureTokenStorage _tokenStorage;

  @override
  Future<AuthSession> restoreSession() async {
    final token = await _tokenStorage.readToken();
    if (token == null || token.isEmpty) return const AuthSession();

    try {
      final user = await _remoteDataSource.me();
      return AuthSession.authenticated(user: user);
    } on ApiException catch (error) {
      if (error.isUnauthorized) {
        await _tokenStorage.clearToken();
        return const AuthSession();
      }
      rethrow;
    }
  }

  @override
  Future<AuthSession> login({
    required String userId,
    required String email,
    required String deviceName,
  }) async {
    final result = await _remoteDataSource.login(
      userId: userId,
      email: email,
      deviceName: deviceName,
    );
    await _tokenStorage.writeToken(result.token);
    return AuthSession.authenticated(user: result.user);
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.logout();
    } on ApiException catch (error) {
      if (!error.isUnauthorized) rethrow;
    } finally {
      await _tokenStorage.clearToken();
    }
  }
}

@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSource(ref.watch(apiClientProvider));
}
