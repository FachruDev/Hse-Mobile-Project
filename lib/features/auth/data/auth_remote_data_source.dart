import '../../../core/network/api_client.dart';
import '../domain/entities/app_user.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<LoginResult> login({
    required String userId,
    required String email,
    required String deviceName,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'user_id': userId, 'email': email, 'device_name': deviceName},
    );

    final data = Map<String, dynamic>.from(response['data'] as Map);
    return LoginResult(
      token: data['access_token'].toString(),
      user: AppUser.fromJson(Map<String, dynamic>.from(data['user'] as Map)),
    );
  }

  Future<AppUser> me() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/auth/me');
    final data = Map<String, dynamic>.from(response['data'] as Map);
    return AppUser.fromJson(Map<String, dynamic>.from(data['user'] as Map));
  }

  Future<void> logout() async {
    await _apiClient.post<Map<String, dynamic>>('/auth/logout');
  }
}

class LoginResult {
  const LoginResult({required this.token, required this.user});

  final String token;
  final AppUser user;
}
