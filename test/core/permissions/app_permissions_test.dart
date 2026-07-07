import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/core/permissions/app_permissions.dart';
import 'package:hse_mobile/features/auth/domain/entities/app_user.dart';

void main() {
  test('canAll bernilai true hanya jika semua permission tersedia', () {
    const user = AppUser(
      id: 1,
      userId: 'EMP001',
      email: 'operator@example.test',
      name: 'Operator',
      permissions: [
        AppPermissions.masterChecklistView,
        AppPermissions.ipalLogsCreate,
      ],
    );

    expect(
      user.canAll([
        AppPermissions.masterChecklistView,
        AppPermissions.ipalLogsCreate,
      ]),
      isTrue,
    );
    expect(
      user.canAll([
        AppPermissions.masterChecklistView,
        AppPermissions.ipalLogsSubmit,
      ]),
      isFalse,
    );
  });
}
