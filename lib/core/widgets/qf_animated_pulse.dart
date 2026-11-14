import 'package:flutter/material.dart';

/// A reusable looping pulse and glow ring widget designed for live status
/// indicators, radar dots, and active real-time badges (e.g. live tracking,
/// active technician status, and diagnostics).
class QFAnimatedPulse extends StatefulWidget {
  /// The base diameter of the central core dot or content.
  final double size;

  /// The maximum outer radius the glowing rings expand to.
  final double glowRadius;

  /// The primary color of the pulse rings and core dot.
  final Color color;

  /// Number of concentric expanding rings.
  final int ringCount;

  /// Animation cycle duration.
  final Duration duration;

  /// Easing curve for ring expansion and fade-out.
  final Curve curve;

  /// Whether the pulse animation is actively running.
  final bool isActive;

  /// Whether to render an ambient soft glow behind the central core.
  final bool showCoreGlow;

  /// Optional widget to display at the center instead of a solid dot.
  final Widget? child;

  const QFAnimatedPulse({
    super.key,
    this.size = 10.0,
    this.glowRadius = 24.0,
    this.color = const Color(0xFF00C853),
    this.ringCount = 2,
    this.duration = const Duration(milliseconds: 1800),
    this.curve = Curves.easeOutCubic,
    this.isActive = true,
    this.showCoreGlow = true,
    this.child,
  });

  /// Factory preset for an active online / live status dot (green).
  factory QFAnimatedPulse.live({
    Key? key,
    double size = 10.0,
    double glowRadius = 22.0,
    bool isActive = true,
  }) {
    return QFAnimatedPulse(
      key: key,
      size: size,
      glowRadius: glowRadius,
      color: const Color(0xFF00C853),
      isActive: isActive,
    );
  }

  /// Factory preset for in-progress / warning / technician working dot (amber).
  factory QFAnimatedPulse.warning({
    Key? key,
    double size = 10.0,
    double glowRadius = 22.0,
    bool isActive = true,
  }) {
    return QFAnimatedPulse(
      key: key,
      size: size,
      glowRadius: glowRadius,
      color: const Color(0xFFEDB000),
      isActive: isActive,
    );
  }

  /// Factory preset for brand deep forest green pulse.
  factory QFAnimatedPulse.primary({
    Key? key,
    double size = 10.0,
    double glowRadius = 22.0,
    bool isActive = true,
  }) {
    return QFAnimatedPulse(
      key: key,
      size: size,
      glowRadius: glowRadius,
      color: const Color(0xFF005A3C),
      isActive: isActive,
    );
  }

  @override
  State<QFAnimatedPulse> createState() => _QFAnimatedPulseState();
}

class _QFAnimatedPulseState extends State<QFAnimatedPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant QFAnimatedPulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        if (!_controller.isAnimating) _controller.repeat();
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double boxSize = (widget.glowRadius * 2).clamp(widget.size, 200.0);

    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Concentric animated pulse rings
          if (widget.isActive)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  size: Size(boxSize, boxSize),
                  painter: _PulseRingsPainter(
                    progress: _controller.value,
                    color: widget.color,
                    ringCount: widget.ringCount,
                    coreRadius: widget.size / 2,
                    maxRadius: widget.glowRadius,
                    curve: widget.curve,
                  ),
                );
              },
            ),

          // Central core dot or custom child
          if (widget.child != null)
            widget.child!
          else
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
                boxShadow: widget.showCoreGlow
                    ? [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.6),
                          blurRadius: widget.size * 0.8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}

/// Custom painter for phased expanding ripple rings.
class _PulseRingsPainter extends CustomPainter {
  final double progress;
  final Color color;
  final int ringCount;
  final double coreRadius;
  final double maxRadius;
  final Curve curve;

  _PulseRingsPainter({
    required this.progress,
    required this.color,
    required this.ringCount,
    required this.coreRadius,
    required this.maxRadius,
    required this.curve,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final totalDistance = maxRadius - coreRadius;

    for (int i = 0; i < ringCount; i++) {
      final ringOffset = (progress + (i / ringCount)) % 1.0;
      final curvedProgress = curve.transform(ringOffset);

      final currentRadius = coreRadius + (totalDistance * curvedProgress);
      // Smooth fade-out towards outer edge
      final alpha = (1.0 - curvedProgress).clamp(0.0, 1.0) * 0.45;

      // Soft filled disc
      final fillPaint = Paint()
        ..color = color.withValues(alpha: alpha * 0.4)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, currentRadius, fillPaint);

      // Fine outer glow stroke
      final strokePaint = Paint()
        ..color = color.withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;
      canvas.drawCircle(center, currentRadius, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PulseRingsPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.ringCount != ringCount ||
        oldDelegate.coreRadius != coreRadius ||
        oldDelegate.maxRadius != maxRadius;
  }
}

/// A ready-to-use badge that pairs [QFAnimatedPulse] with an active status label
/// (e.g. "LIVE TRACKING", "TECHNICIAN ASSIGNED", "IN DIAGNOSTICS").
class QFAnimatedPulseBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? backgroundColor;
  final Color? textColor;
  final double dotSize;
  final double glowRadius;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const QFAnimatedPulseBadge({
    super.key,
    required this.label,
    this.color = const Color(0xFF00C853),
    this.backgroundColor,
    this.textColor,
    this.dotSize = 8.0,
    this.glowRadius = 14.0,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? color.withValues(alpha: 0.12);
    final effectiveText = textColor ?? color;
    final radius = borderRadius ?? BorderRadius.circular(999);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: effectiveBg,
            borderRadius: radius,
            border: Border.all(
              color: color.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              QFAnimatedPulse(
                size: dotSize,
                glowRadius: glowRadius,
                color: color,
                showCoreGlow: true,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: textStyle ??
                    TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: effectiveText,
                      letterSpacing: 0.4,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
