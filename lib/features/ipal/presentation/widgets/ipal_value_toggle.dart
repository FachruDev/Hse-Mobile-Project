import 'package:flutter/material.dart';

import '../../../../color_config.dart';

class IpalToggleOption {
  const IpalToggleOption({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;
}

class IpalValueToggle extends StatelessWidget {
  const IpalValueToggle({
    required this.value,
    required this.options,
    required this.onChanged,
    super.key,
  });

  final String? value;
  final List<IpalToggleOption> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final option in options)
              _ToggleSegment(
                option: option,
                selected: value == option.value,
                onTap: () {
                  onChanged(value == option.value ? '' : option.value);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _ToggleSegment extends StatelessWidget {
  const _ToggleSegment({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final IpalToggleOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? option.color.withValues(alpha: 0.14)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              option.icon,
              size: 18,
              color: selected ? option.color : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              option.label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: selected ? option.color : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
