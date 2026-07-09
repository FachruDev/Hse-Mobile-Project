import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/storage/local_cache_service.dart';
import '../../../core/storage/secure_token_storage.dart';
import '../domain/entities/app_user.dart';
import '../domain/entities/auth_session.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_remote_data_source.dart';

part 'auth_repository_impl.g.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureTokenStorage tokenStorage,
    required LocalCacheService sessionCache,
  }) : _remoteDataSource = remoteDataSource,
       _tokenStorage = tokenStorage,
       _sessionCache = sessionCache;

  static const _userCacheKey = 'auth_user';

  final AuthRemoteDataSource _remoteDataSource;
  final SecureTokenStorage _tokenStorage;
  final LocalCacheService _sessionCache;

  @override
  Future<AuthSession> restoreSession() async {
    final token = await _tokenStorage.readToken();
    if (token == null || token.isEmpty) return const AuthSession();

    final cachedUser = _readCachedUser();
    if (cachedUser != null && _sessionCache.isFresh(_userCacheKey)) {
      return AuthSession.authenticated(user: cachedUser);
    }

    return refreshSession(force: true);
  }

  @override
  Future<AuthSession> refreshSession({bool force = false}) async {
    final token = await _tokenStorage.readToken();
    if (token == null || token.isEmpty) return const AuthSession();

    try {
      final user = await _remoteDataSource.me();
      await _sessionCache.writeFreshJson(_userCacheKey, user.toJson());
      return AuthSession.authenticated(user: user);
    } on ApiException catch (error) {
      if (error.isUnauthorized) {
        await _tokenStorage.clearToken();
        await _sessionCache.remove(_userCacheKey);
        return const AuthSession();
      }
      final cachedUser = _readCachedUser();
      if (cachedUser != null) {
        return AuthSession.authenticated(user: cachedUser);
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
    await _sessionCache.writeFreshJson(_userCacheKey, result.user.toJson());
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
      await _sessionCache.remove(_userCacheKey);
    }
  }

  AppUser? _readCachedUser() {
    final cached = _sessionCache.readJsonMap(_userCacheKey);
    if (cached == null) return null;
    return AppUser.fromJson(cached);
  }
}

@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSource(ref.watch(apiClientProvider));
}
