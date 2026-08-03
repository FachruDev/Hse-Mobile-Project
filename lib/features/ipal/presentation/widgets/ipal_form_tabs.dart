import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum IpalFormTab { checklist, process }

class IpalFormTabs extends StatelessWidget {
  const IpalFormTabs({required this.selected, super.key});

  final IpalFormTab selected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 420;
        final tabs = [
          _TabButton(
            selected: selected == IpalFormTab.checklist,
            icon: Icons.checklist_outlined,
            label: 'Checklist',
            onPressed: () => _go(context, IpalFormTab.checklist),
          ),
          _TabButton(
            selected: selected == IpalFormTab.process,
            icon: Icons.fact_check_outlined,
            label: 'Proses',
            onPressed: () => _go(context, IpalFormTab.process),
          ),
        ];

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [tabs.first, const SizedBox(height: 8), tabs.last],
          );
        }

        return Row(
          children: [
            Expanded(child: tabs.first),
            const SizedBox(width: 8),
            Expanded(child: tabs.last),
          ],
        );
      },
    );
  }

  void _go(BuildContext context, IpalFormTab target) {
    if (target == selected) return;

    context.go(
      target == IpalFormTab.checklist
          ? '/form/ipal/checklist'
          : '/form/ipal/proses',
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Flexible(
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );

    if (selected) {
      return FilledButton(onPressed: onPressed, child: child);
    }

    return OutlinedButton(onPressed: onPressed, child: child);
  }
}
