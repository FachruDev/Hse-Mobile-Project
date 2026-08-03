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
  bool _atTop = true;
  bool _atBottom = false;
  int _scrollToken = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_syncEdgeState);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncEdgeState());
  }

  @override
  void didUpdateWidget(IpalFloatingScrollControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) return;

    oldWidget.controller.removeListener(_syncEdgeState);
    widget.controller.addListener(_syncEdgeState);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncEdgeState());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncEdgeState);
    _scrollToken++;
    super.dispose();
  }

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
                  canUp: !_atTop,
                  canDown: !_atBottom,
                  onUp: _atTop ? null : _scrollToTop,
                  onDown: _atBottom ? null : _scrollToBottom,
                  onHide: () {
                    HapticFeedback.selectionClick();
                    setState(() => _collapsed = true);
                  },
                ),
        ),
      ),
    );
  }

  void _syncEdgeState() {
    if (!mounted || !widget.controller.hasClients) return;

    final position = widget.controller.position;
    final atTop = position.pixels <= position.minScrollExtent + 2;
    final atBottom = position.pixels >= position.maxScrollExtent - 2;
    if (atTop == _atTop && atBottom == _atBottom) return;

    setState(() {
      _atTop = atTop;
      _atBottom = atBottom;
    });
  }

  void _scrollToTop() {
    if (!widget.controller.hasClients) return;

    HapticFeedback.selectionClick();
    _animateToEdge(() => 0);
  }

  void _scrollToBottom() {
    if (!widget.controller.hasClients) return;

    HapticFeedback.selectionClick();
    _animateToEdge(() => widget.controller.position.maxScrollExtent);
  }

  Future<void> _animateToEdge(double Function() targetResolver) async {
    final token = ++_scrollToken;

    if (!mounted || !widget.controller.hasClients) return;

    final position = widget.controller.position;
    final target = targetResolver().clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    final current = widget.controller.offset.clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    final distance = (target - current).abs();
    if (distance < 2) {
      _syncEdgeState();
      return;
    }

    if (widget.controller.offset != current) {
      widget.controller.jumpTo(current);
    }

    final milliseconds = (260 + distance * 0.16).clamp(320, 950).round();
    await widget.controller.animateTo(
      target,
      duration: Duration(milliseconds: milliseconds),
      curve: Curves.easeOutCubic,
    );

    if (!mounted || token != _scrollToken || !widget.controller.hasClients) {
      return;
    }

    final finalTarget = target.clamp(
      widget.controller.position.minScrollExtent,
      widget.controller.position.maxScrollExtent,
    );
    if ((widget.controller.offset - finalTarget).abs() > 1) {
      widget.controller.jumpTo(finalTarget);
    }
    _syncEdgeState();
  }
}

class _ScrollPill extends StatelessWidget {
  const _ScrollPill({
    required this.canUp,
    required this.canDown,
    required this.onUp,
    required this.onDown,
    required this.onHide,
    super.key,
  });

  final bool canUp;
  final bool canDown;
  final VoidCallback? onUp;
  final VoidCallback? onDown;
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
            _PillIcon(
              icon: Icons.keyboard_arrow_up,
              onTap: onUp,
              enabled: canUp,
            ),
            _PillIcon(
              icon: Icons.keyboard_arrow_down,
              onTap: onDown,
              enabled: canDown,
            ),
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
  const _PillIcon({
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 22,
            color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
