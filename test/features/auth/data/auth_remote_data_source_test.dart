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
}

class _MockApiClient extends Mock implements ApiClient {}
