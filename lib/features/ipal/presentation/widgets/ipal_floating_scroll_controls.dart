import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../color_config.dart';

class IpalFloatingScrollControls extends StatefulWidget {
  const IpalFloatingScrollControls({required this.controller, super.key});

  final ScrollController controller;

  @override
  State<IpalFloatingScrollControls> createState() =>
      _IpalFloatingScrollControlsState();
}

class _IpalFloatingScrollControlsState
    extends State<IpalFloatingScrollControls> {
  bool _collapsed = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 12,
      child: SafeArea(
        minimum: const EdgeInsets.only(bottom: 6),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          reverseDuration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.18),
                  end: Offset.zero,
                ).animate(curved),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.92, end: 1).animate(curved),
                  child: child,
                ),
              ),
            );
          },
          child: _collapsed
              ? _CollapsedHandle(
                  key: const ValueKey('collapsed-scroll-handle'),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _collapsed = false);
                  },
                )
              : _ScrollPill(
                  key: const ValueKey('expanded-scroll-pill'),
                  onUp: _scrollToTop,
                  onDown: _scrollToBottom,
                  onHide: () {
                    HapticFeedback.selectionClick();
                    setState(() => _collapsed = true);
                  },
                ),
        ),
      ),
    );
  }

  void _scrollToTop() {
    if (!widget.controller.hasClients) return;

    HapticFeedback.selectionClick();
    _animateTo(0);
  }

  void _scrollToBottom() {
    if (!widget.controller.hasClients) return;

    HapticFeedback.selectionClick();
    _animateTo(widget.controller.position.maxScrollExtent);
  }

  void _animateTo(double target) {
    final current = widget.controller.offset;
    final distance = (target - current).abs();
    if (distance < 8) return;

    final milliseconds = (320 + distance * 0.28).clamp(420, 980).round();
    widget.controller.animateTo(
      target,
      duration: Duration(milliseconds: milliseconds),
      curve: Curves.easeInOutCubic,
    );
  }
}

class _ScrollPill extends StatelessWidget {
  const _ScrollPill({
    required this.onUp,
    required this.onDown,
    required this.onHide,
    super.key,
  });

  final VoidCallback onUp;
  final VoidCallback onDown;
  final VoidCallback onHide;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PillIcon(icon: Icons.keyboard_arrow_up, onTap: onUp),
            _PillIcon(icon: Icons.keyboard_arrow_down, onTap: onDown),
            _PillIcon(icon: Icons.visibility_off_outlined, onTap: onHide),
          ],
        ),
      ),
    );
  }
}

class _CollapsedHandle extends StatelessWidget {
  const _CollapsedHandle({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.88),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.unfold_more, size: 20),
          ),
        ),
      ),
    );
  }
}

class _PillIcon extends StatelessWidget {
  const _PillIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 22, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
