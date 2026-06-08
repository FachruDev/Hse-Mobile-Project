import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../color_config.dart';
import '../../features/auth/application/auth_session_controller.dart';
import '../widgets/hse_brand_mark.dart';

class HseAppDrawer extends ConsumerWidget {
  const HseAppDrawer({required this.selectedPath, super.key});

  final String selectedPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionControllerProvider).value;
    final user = session?.user;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                children: [
                  const HseBrandMark(size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HSE Mobile',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.department?.name ?? 'Departemen',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _DrawerItem(
                    selected: selectedPath == '/beranda',
                    icon: Icons.dashboard_outlined,
                    label: 'Dashboard',
                    onTap: () => _go(context, '/beranda'),
                  ),
                  _DrawerItem(
                    selected: selectedPath == '/form/ipal/proses',
                    icon: Icons.fact_check_outlined,
                    label: 'Catatan Proses IPAL',
                    onTap: () => _go(context, '/form/ipal/proses'),
                  ),
                  _DrawerItem(
                    selected: selectedPath == '/form/ipal/checklist',
                    icon: Icons.checklist_outlined,
                    label: 'Checklist Harian',
                    onTap: () => _go(context, '/form/ipal/checklist'),
                  ),
                  _DrawerItem(
                    selected: selectedPath == '/form/b3',
                    icon: Icons.inventory_2_outlined,
                    label: 'Penyimpanan Limbah B3',
                    onTap: () => _go(context, '/form/b3'),
                  ),
                  _DrawerItem(
                    selected: selectedPath == '/laporan/b3',
                    icon: Icons.assignment_outlined,
                    label: 'Laporan Bulanan B3',
                    onTap: () => _go(context, '/laporan/b3'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Keluar'),
              onTap: () async {
                Navigator.of(context).pop();
                await ref.read(authSessionControllerProvider.notifier).logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _go(BuildContext context, String path) {
    Navigator.of(context).pop();
    context.go(path);
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        selected: selected,
        selectedColor: AppColors.primary,
        selectedTileColor: AppColors.primary.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: Icon(icon),
        title: Text(label),
        onTap: onTap,
      ),
    );
  }
}
