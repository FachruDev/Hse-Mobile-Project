import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/core/network/api_client.dart';
import 'package:hse_mobile/features/auth/data/auth_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  test('login mengirim payload login dan password', () async {
    final apiClient = _MockApiClient();
    final dataSource = AuthRemoteDataSource(apiClient);

    when(
      () => apiClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: any(named: 'data'),
      ),
    ).thenAnswer(
      (_) async => {
        'data': {
          'access_token': 'token',
          'user': {
            'id': 1,
            'user_id': 'irvan.m',
            'email': 'irvan.m@galenium.local',
            'name': 'Irvan Maulana',
            'department': null,
            'roles': <String>[],
            'permissions': <String>[],
          },
        },
      },
    );

    await dataSource.login(
      login: 'irvan.m',
      password: 'Gpl12345!',
      deviceName: 'flutter-test',
    );

    final capturedPayload = verify(
      () => apiClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: captureAny(named: 'data'),
      ),
    ).captured.single;

    expect(capturedPayload, {
      'login': 'irvan.m',
      'password': 'Gpl12345!',
      'device_name': 'flutter-test',
    });
  });

  test('updatePassword mengirim PATCH password akun sendiri', () async {
    final apiClient = _MockApiClient();
    final dataSource = AuthRemoteDataSource(apiClient);

    when(
      () => apiClient.patch<Map<String, dynamic>>(
        '/auth/password',
        data: any(named: 'data'),
      ),
    ).thenAnswer((_) async => {'message': 'Password berhasil diperbarui.'});

    await dataSource.updatePassword(
      currentPassword: 'Gpl12345!',
      password: 'NewPass123!',
      passwordConfirmation: 'NewPass123!',
    );

    final capturedPayload = verify(
      () => apiClient.patch<Map<String, dynamic>>(
        '/auth/password',
        data: captureAny(named: 'data'),
      ),
    ).captured.single;

    expect(capturedPayload, {
      'current_password': 'Gpl12345!',
      'password': 'NewPass123!',
      'password_confirmation': 'NewPass123!',
    });
  });
}

class _MockApiClient extends Mock implements ApiClient {}
