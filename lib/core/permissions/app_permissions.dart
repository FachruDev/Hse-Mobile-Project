import '../../features/auth/domain/entities/app_user.dart';

class AppPermissions {
  const AppPermissions._();

  static const masterChecklistView = 'master.checklist.view';
  static const masterProcessView = 'master.process.view';
  static const masterBatchView = 'master.batch.view';

  static const ipalLogsCreate = 'ipal.logs.create';
  static const ipalLogsViewAll = 'ipal.logs.view-all';
  static const ipalLogsView = 'ipal.logs.view';
  static const ipalLogsSubmit = 'ipal.logs.submit';
  // Approve harian IPAL di API memakai ipal.logs.approve-daily (ipal.logs.approve tidak dimiliki role mana pun).
  static const ipalLogsApprove = 'ipal.logs.approve-daily';
  static const ipalLogsReopen = 'ipal.logs.reopen';

  // Hanya untuk halaman master data. Form B3 cukup b3storage.logs.create: API mengizinkan daftar jenis limbah &
  // dept inisiator untuk user yang boleh membuat/mengubah log B3.
  static const b3StorageMasterView = 'b3storage.master.view';
  static const b3StorageLogsCreate = 'b3storage.logs.create';
  static const b3StorageLogsViewOwn = 'b3storage.logs.view-own';
  static const b3StorageLogsViewAll = 'b3storage.logs.view-all';
  static const b3StorageLogsView = 'b3storage.logs.view';
  static const b3StorageLogsUpdate = 'b3storage.logs.update';
  static const b3StorageLogsDelete = 'b3storage.logs.delete';
}

extension AppUserPermissionChecks on AppUser {
  bool canAny(Iterable<String> permissions) => hasAnyPermission(permissions);

  bool canAll(Iterable<String> permissions) {
    return permissions.every(hasPermission);
  }
}
