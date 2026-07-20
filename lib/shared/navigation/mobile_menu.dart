import 'package:flutter/material.dart';

import '../../core/permissions/app_permissions.dart';
import '../../features/auth/domain/entities/app_user.dart';

class MobileMenuSection {
  const MobileMenuSection({required this.title, required this.items});

  final String title;
  final List<MobileMenuItem> items;
}

class MobileMenuItem {
  const MobileMenuItem({
    required this.title,
    required this.subtitle,
    required this.path,
    required this.icon,
    required this.requiredAll,
    this.requiredAny = const <String>[],
  });

  final String title;
  final String subtitle;
  final String path;
  final IconData icon;
  final List<String> requiredAll;
  final List<String> requiredAny;

  bool isVisibleFor(AppUser? user) {
    if (user == null) return false;

    final hasAll = requiredAll.every(user.hasPermission);
    final hasAny = requiredAny.isEmpty || requiredAny.any(user.hasPermission);

    return hasAll && hasAny;
  }
}

const mobileMenuSections = <MobileMenuSection>[
  MobileMenuSection(
    title: 'Form',
    items: [
      MobileMenuItem(
        title: 'Catatan Proses IPAL',
        subtitle: 'Proses harian dan batch mixing',
        path: '/form/ipal/proses',
        icon: Icons.fact_check_outlined,
        requiredAll: [AppPermissions.ipalLogsCreate],
      ),
      MobileMenuItem(
        title: 'Checklist Harian',
        subtitle: 'Status unit dan pemeriksaan harian',
        path: '/form/ipal/checklist',
        icon: Icons.checklist_outlined,
        requiredAll: [AppPermissions.ipalLogsCreate],
      ),
      MobileMenuItem(
        title: 'Penyimpanan Limbah B3',
        subtitle: 'Input limbah masuk atau keluar TPS LB3',
        path: '/form/b3',
        icon: Icons.inventory_2_outlined,
        requiredAll: [
          AppPermissions.b3StorageMasterView,
          AppPermissions.b3StorageLogsCreate,
        ],
      ),
    ],
  ),
  MobileMenuSection(
    title: 'Riwayat',
    items: [
      MobileMenuItem(
        title: 'Riwayat IPAL',
        subtitle: 'Log harian IPAL',
        path: '/riwayat/ipal',
        icon: Icons.history_outlined,
        requiredAll: [],
        requiredAny: [
          AppPermissions.ipalLogsViewOwn,
          AppPermissions.ipalLogsViewAll,
          AppPermissions.ipalLogsView,
        ],
      ),
      MobileMenuItem(
        title: 'Riwayat B3',
        subtitle: 'Log penyimpanan limbah B3',
        path: '/riwayat/b3',
        icon: Icons.receipt_long_outlined,
        requiredAll: [],
        requiredAny: [
          AppPermissions.b3StorageLogsViewOwn,
          AppPermissions.b3StorageLogsViewAll,
          AppPermissions.b3StorageLogsView,
        ],
      ),
    ],
  ),
];

List<MobileMenuSection> visibleMobileMenuSections(AppUser? user) {
  return mobileMenuSections
      .map(
        (section) => MobileMenuSection(
          title: section.title,
          items: section.items
              .where((item) => item.isVisibleFor(user))
              .toList(growable: false),
        ),
      )
      .where((section) => section.items.isNotEmpty)
      .toList(growable: false);
}
