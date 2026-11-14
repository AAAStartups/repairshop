import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A modern interactive card component featuring subtle spring press feedback,
/// soft elevation glow shadows, and dark/light adaptive styling.
class QFCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final double elevation;
  final Gradient? gradient;
  final bool enableSpring;

  const QFCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 16,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.elevation = 0,
    this.gradient,
    this.enableSpring = true,
  });

  @override
  State<QFCard> createState() => _QFCardState();
}

class _QFCardState extends State<QFCard> with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null && widget.enableSpring) {
      HapticFeedback.selectionClick();
      _pressController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null && widget.enableSpring) {
      _pressController.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null && widget.enableSpring) {
      _pressController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = widget.backgroundColor ?? (isDark ? const Color(0xFF1F2D27) : Colors.white);
    final border = widget.borderColor ?? (isDark ? const Color(0xFF2E3D37) : const Color(0xFFD1D9D6).withValues(alpha: 0.8));

    final cardContent = Container(
      padding: widget.padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.gradient == null ? bg : null,
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: border, width: 1),
      ),
      child: widget.child,
    );

    return AnimatedBuilder(
      animation: _pressController,
      builder: (context, child) => Transform.scale(
        scale: widget.onTap != null && widget.enableSpring ? _scaleAnimation.value : 1.0,
        child: child,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        elevation: widget.elevation,
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          splashColor: const Color(0xFF003A26).withValues(alpha: 0.05),
          highlightColor: Colors.transparent,
          child: cardContent,
        ),
      ),
    );
  }
}
