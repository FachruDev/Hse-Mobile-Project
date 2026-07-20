import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/core/permissions/app_permissions.dart';
import 'package:hse_mobile/features/auth/domain/entities/app_user.dart';
import 'package:hse_mobile/shared/navigation/mobile_menu.dart';

void main() {
  test('non-HSE user only sees B3 form and own B3 history', () {
    const user = AppUser(
      id: 1,
      userId: 'angki.p',
      email: 'angki.p@example.test',
      name: 'Angki P',
      permissions: [
        AppPermissions.b3StorageMasterView,
        AppPermissions.b3StorageLogsCreate,
        AppPermissions.b3StorageLogsViewOwn,
      ],
    );

    final items = visibleMobileMenuSections(user)
        .expand((section) => section.items)
        .map((item) => item.path)
        .toList(growable: false);

    expect(items, contains('/form/b3'));
    expect(items, contains('/riwayat/b3'));
    expect(items, isNot(contains('/form/ipal/proses')));
    expect(items, isNot(contains('/form/ipal/checklist')));
    expect(items, isNot(contains('/riwayat/ipal')));
  });

  test('IPAL operator sees IPAL form menu with create permission only', () {
    const user = AppUser(
      id: 2,
      userId: 'hermawan',
      email: 'hermawan@example.test',
      name: 'Hermawan',
      permissions: [AppPermissions.ipalLogsCreate, AppPermissions.ipalLogsView],
    );

    final items = visibleMobileMenuSections(user)
        .expand((section) => section.items)
        .map((item) => item.path)
        .toList(growable: false);

    expect(items, contains('/form/ipal/proses'));
    expect(items, contains('/form/ipal/checklist'));
    expect(items, contains('/riwayat/ipal'));
  });
}
