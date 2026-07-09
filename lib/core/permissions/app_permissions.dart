import '../../features/auth/domain/entities/app_user.dart';

class AppPermissions {
  const AppPermissions._();

  static const masterChecklistView = 'master.checklist.view';
  static const masterProcessView = 'master.process.view';
  static const masterBatchView = 'master.batch.view';

  static const ipalLogsCreate = 'ipal.logs.create';
  static const ipalLogsView = 'ipal.logs.view';
  static const ipalLogsSubmit = 'ipal.logs.submit';
  static const ipalLogsApprove = 'ipal.logs.approve';

  static const b3StorageMasterView = 'b3storage.master.view';
  static const b3StorageLogsCreate = 'b3storage.logs.create';
  static const b3StorageLogsSelectUser = 'b3storage.logs.select-user';
  static const b3StorageLogsView = 'b3storage.logs.view';
  static const b3StorageLogsUpdate = 'b3storage.logs.update';
  static const b3StorageLogsDelete = 'b3storage.logs.delete';
  static const b3StorageMonthlyReportView = 'b3storage.monthly-report.view';
  static const b3StorageMonthlyApprovalApprove =
      'b3storage.monthly-approval.approve';
}

extension AppUserPermissionChecks on AppUser {
  bool canAny(Iterable<String> permissions) => hasAnyPermission(permissions);

  bool canAll(Iterable<String> permissions) {
    return permissions.every(hasPermission);
  }
}
