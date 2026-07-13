import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../color_config.dart';
import '../../features/auth/application/auth_session_controller.dart';
import '../navigation/mobile_menu.dart';
import '../widgets/hse_brand_mark.dart';

class HseAppDrawer extends ConsumerStatefulWidget {
  const HseAppDrawer({required this.selectedPath, super.key});

  final String selectedPath;

  @override
  ConsumerState<HseAppDrawer> createState() => _HseAppDrawerState();
}

class _HseAppDrawerState extends ConsumerState<HseAppDrawer> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authSessionControllerProvider).value;
    final user = session?.user;
    final query = _query.trim().toLowerCase();
    final sections = visibleMobileMenuSections(user)
        .map(
          (section) => MobileMenuSection(
            title: section.title,
            items: section.items
                .where(
                  (item) =>
                      query.isEmpty ||
                      item.title.toLowerCase().contains(query) ||
                      item.subtitle.toLowerCase().contains(query),
                )
                .toList(growable: false),
          ),
        )
        .where((section) => section.items.isNotEmpty)
        .toList(growable: false);

    return Drawer(
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Column(
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                child: Row(
                  children: [
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: HseBrandMark(size: 42),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Pengguna',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppColors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.department?.name ?? 'Departemen',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.white.withValues(
                                    alpha: 0.82,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.white),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: 'Cari menu',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Hapus pencarian',
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        ),
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  _DrawerItem(
                    selected: widget.selectedPath == '/beranda',
                    icon: Icons.dashboard_outlined,
                    label: 'Dashboard',
                    subtitle: 'Ringkasan dan draft lokal',
                    onTap: () => _go(context, '/beranda'),
                  ),
                  for (final section in sections) ...[
                    _DrawerSectionTitle(section.title),
                    for (final item in section.items)
                      _DrawerItem(
                        selected: widget.selectedPath == item.path,
                        icon: item.icon,
                        label: item.title,
                        subtitle: item.subtitle,
                        onTap: () => _go(context, item.path),
                      ),
                  ],
                  if (sections.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Menu tidak ditemukan.'),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Keluar'),
              onTap: _confirmLogout,
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

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.logout, color: AppColors.primary),
        title: const Text('Keluar dari aplikasi?'),
        content: const Text(
          'Sesi Anda akan diakhiri. Pastikan draft yang sedang dikerjakan sudah tersimpan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    Navigator.of(context).pop();
    await ref.read(authSessionControllerProvider.notifier).logout();
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.selected,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        selected: selected,
        selectedColor: AppColors.primary,
        selectedTileColor: AppColors.primaryPastel,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: DecoratedBox(
          decoration: BoxDecoration(
            color: selected ? AppColors.white : AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 20),
          ),
        ),
        title: Text(label),
        subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        onTap: onTap,
      ),
    );
  }
}

class _DrawerSectionTitle extends StatelessWidget {
  const _DrawerSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
