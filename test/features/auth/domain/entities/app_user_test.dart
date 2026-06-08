import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/features/auth/domain/entities/app_user.dart';

void main() {
  test('hasAnyPermission bernilai true saat salah satu permission cocok', () {
    const user = AppUser(
      id: 1,
      userId: 'operator.ipal',
      email: 'operator.ipal@local',
      name: 'Operator IPAL',
      permissions: ['ipal.logs.create'],
    );

    expect(
      user.hasAnyPermission(['ipal.logs.submit', 'ipal.logs.create']),
      isTrue,
    );
  });
}
