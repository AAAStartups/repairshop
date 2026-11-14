import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Button visual variants for the QuickFix design system.
enum QFButtonVariant {
  primary,
  accent,
  secondary,
  glass,
  outlined,
  ghost,
}

/// A high-end consumer-grade animated button component (inspired by CRED, Zepto, Apple).
///
/// Features:
/// - Gradient fills (Deep Forest Green or Golden Amber)
/// - Continuous subtle shimmer light sweep reflection
/// - Looping ambient breathing pulse glow
/// - Spring press animation with tactile haptic feedback
/// - Colored elevation glow shadows matching the button hue
/// - Secondary and Frosted Glass variants with blur
class QFButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final QFButtonVariant variant;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? customLeading;
  final Widget? customTrailing;
  final double? width;
  final double height;
  final double borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool showShimmer;
  final bool showPulse;
  final bool enableHaptic;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final double? elevation;

  const QFButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.variant = QFButtonVariant.primary,
    this.prefixIcon,
    this.suffixIcon,
    this.customLeading,
    this.customTrailing,
    this.width,
    this.height = 56,
    this.borderRadius = 16,
    this.fontSize,
    this.fontWeight,
    this.showShimmer = false,
    this.showPulse = false,
    this.enableHaptic = true,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.boxShadow,
    this.elevation,
  });

  /// Factory constructor for a primary button with continuous shimmer effect.
  factory QFButton.shimmer({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
    QFButtonVariant variant = QFButtonVariant.primary,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Widget? customLeading,
    Widget? customTrailing,
    double? width,
    double height = 56,
    double borderRadius = 16,
  }) {
    return QFButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      variant: variant,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      customLeading: customLeading,
      customTrailing: customTrailing,
      width: width,
      height: height,
      borderRadius: borderRadius,
      showShimmer: true,
    );
  }

  /// Factory constructor for a pulsing glowing button (e.g. for urgent checkout or emergency repair).
  factory QFButton.pulse({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
    QFButtonVariant variant = QFButtonVariant.accent,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Widget? customLeading,
    Widget? customTrailing,
    double? width,
    double height = 56,
    double borderRadius = 16,
  }) {
    return QFButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      variant: variant,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      customLeading: customLeading,
      customTrailing: customTrailing,
      width: width,
      height: height,
      borderRadius: borderRadius,
      showPulse: true,
    );
  }

  /// Factory constructor for an Apple-style frosted glass button.
  factory QFButton.glass({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Widget? customLeading,
    Widget? customTrailing,
    double? width,
    double height = 56,
    double borderRadius = 16,
    Color? textColor,
  }) {
    return QFButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      variant: QFButtonVariant.glass,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      customLeading: customLeading,
      customTrailing: customTrailing,
      width: width,
      height: height,
      borderRadius: borderRadius,
      textColor: textColor,
    );
  }

  @override
  State<QFButton> createState() => _QFButtonState();
}

class _QFButtonState extends State<QFButton> with TickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnimation;

  AnimationController? _shimmerController;
  AnimationController? _pulseController;
  Animation<double>? _pulseAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    // Spring press scale controller
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.965).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOutCubic),
    );

    _initShimmerIfNeeded();
    _initPulseIfNeeded();
  }

  void _initShimmerIfNeeded() {
    if (widget.showShimmer && _shimmerController == null) {
      _shimmerController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2600),
      )..repeat();
    }
  }

  void _initPulseIfNeeded() {
    if (widget.showPulse && _pulseController == null) {
      _pulseController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1400),
      );
      _pulseAnimation = CurvedAnimation(
        parent: _pulseController!,
        curve: Curves.easeInOut,
      );
      _pulseController!.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant QFButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showShimmer != oldWidget.showShimmer) {
      if (widget.showShimmer) {
        _initShimmerIfNeeded();
      } else {
        _shimmerController?.dispose();
        _shimmerController = null;
      }
    }

    if (widget.showPulse != oldWidget.showPulse) {
      if (widget.showPulse) {
        _initPulseIfNeeded();
      } else {
        _pulseController?.dispose();
        _pulseController = null;
        _pulseAnimation = null;
      }
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    _shimmerController?.dispose();
    _pulseController?.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed == null || widget.isLoading) return;
    if (widget.enableHaptic) {
      HapticFeedback.lightImpact();
    }
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed == null || widget.isLoading) return;
    _pressController.reverse();
  }

  void _onTapCancel() {
    if (widget.onPressed == null || widget.isLoading) return;
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Determine colors, gradients, and borders
    Color fgColor;
    Color? bgColor = widget.backgroundColor;
    Gradient? bgGradient = widget.gradient;
    Color? borderColor = widget.borderColor;
    Color glowColor;

    switch (widget.variant) {
      case QFButtonVariant.primary:
        bgGradient ??= const LinearGradient(
          colors: [Color(0xFF003A26), Color(0xFF005A3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        fgColor = widget.textColor ?? Colors.white;
        glowColor = const Color(0xFF003A26);
        break;

      case QFButtonVariant.accent:
        bgGradient ??= const LinearGradient(
          colors: [Color(0xFFEDB000), Color(0xFFFFC72C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        fgColor = widget.textColor ?? const Color(0xFF003A26);
        glowColor = const Color(0xFFEDB000);
        break;

      case QFButtonVariant.secondary:
        bgColor ??= isDark ? const Color(0xFF1B2E24) : const Color(0xFFF1F6F3);
        fgColor = widget.textColor ?? (isDark ? Colors.white : const Color(0xFF003A26));
        borderColor ??= isDark
            ? const Color(0xFF2E4336)
            : const Color(0xFF003A26).withValues(alpha: 0.12);
        glowColor = const Color(0xFF003A26).withValues(alpha: 0.15);
        break;

      case QFButtonVariant.glass:
        bgColor ??= isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.white.withValues(alpha: 0.55);
        fgColor = widget.textColor ?? (isDark ? Colors.white : const Color(0xFF003A26));
        borderColor ??= isDark
            ? Colors.white.withValues(alpha: 0.20)
            : Colors.white.withValues(alpha: 0.65);
        glowColor = Colors.white.withValues(alpha: 0.2);
        break;

      case QFButtonVariant.outlined:
        bgColor ??= Colors.transparent;
        fgColor = widget.textColor ?? (isDark ? const Color(0xFF00D187) : const Color(0xFF003A26));
        borderColor ??= fgColor.withValues(alpha: 0.85);
        glowColor = fgColor.withValues(alpha: 0.15);
        break;

      case QFButtonVariant.ghost:
        bgColor ??= Colors.transparent;
        fgColor = widget.textColor ?? (isDark ? Colors.white : const Color(0xFF003A26));
        glowColor = Colors.transparent;
        break;
    }

    final double effectiveRadius = widget.borderRadius;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: isDisabled ? null : widget.onPressed,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _pressController,
            if (_pulseAnimation != null) _pulseAnimation!,
          ]),
          builder: (context, child) {
            final scale = _scaleAnimation.value;
            final pulseVal = _pulseAnimation?.value ?? 0.0;

            // Generate elevated shadow with colored glow
            List<BoxShadow> shadows = [];
            if (!isDisabled && widget.boxShadow != null) {
              shadows = widget.boxShadow!;
            } else if (!isDisabled && widget.variant != QFButtonVariant.ghost) {
              if (widget.variant == QFButtonVariant.primary) {
                final double blur = 16.0 * scale + (widget.showPulse ? pulseVal * 8.0 : 0.0);
                final double spread = -2.0 + (widget.showPulse ? pulseVal * 2.5 : 0.0);
                shadows = [
                  BoxShadow(
                    color: glowColor.withValues(alpha: (0.28 + (widget.showPulse ? pulseVal * 0.12 : 0.0)) * scale),
                    blurRadius: blur,
                    offset: Offset(0, 7.0 * scale),
                    spreadRadius: spread,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06 * scale),
                    blurRadius: 4.0 * scale,
                    offset: Offset(0, 2.0 * scale),
                  ),
                ];
              } else if (widget.variant == QFButtonVariant.accent) {
                final double blur = 18.0 * scale + (widget.showPulse ? pulseVal * 10.0 : 0.0);
                final double spread = -1.0 + (widget.showPulse ? pulseVal * 3.0 : 0.0);
                shadows = [
                  BoxShadow(
                    color: glowColor.withValues(alpha: (0.38 + (widget.showPulse ? pulseVal * 0.14 : 0.0)) * scale),
                    blurRadius: blur,
                    offset: Offset(0, 8.0 * scale),
                    spreadRadius: spread,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05 * scale),
                    blurRadius: 4.0 * scale,
                    offset: Offset(0, 2.0 * scale),
                  ),
                ];
              } else if (widget.variant == QFButtonVariant.secondary ||
                  widget.variant == QFButtonVariant.glass) {
                shadows = [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: (isDark ? 0.20 : 0.04) * scale),
                    blurRadius: 10.0 * scale,
                    offset: Offset(0, 4.0 * scale),
                  ),
                ];
              }
            }

            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: isDisabled ? 0.5 : (_isHovered ? 0.95 : 1.0),
                child: Container(
                  width: widget.width ?? double.infinity,
                  height: widget.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(effectiveRadius),
                    boxShadow: shadows,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(effectiveRadius),
                    child: _buildButtonBody(
                      context: context,
                      bgColor: bgColor,
                      bgGradient: bgGradient,
                      borderColor: borderColor,
                      fgColor: fgColor,
                      effectiveRadius: effectiveRadius,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildButtonBody({
    required BuildContext context,
    required Color? bgColor,
    required Gradient? bgGradient,
    required Color? borderColor,
    required Color fgColor,
    required double effectiveRadius,
  }) {
    final isGlass = widget.variant == QFButtonVariant.glass;

    Widget content = Container(
      decoration: BoxDecoration(
        color: bgGradient == null ? bgColor : null,
        gradient: bgGradient,
        borderRadius: BorderRadius.circular(effectiveRadius),
        border: borderColor != null
            ? Border.all(
                color: borderColor,
                width: widget.variant == QFButtonVariant.outlined ? 1.5 : 1.2,
              )
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Subtle shimmer sweep light reflection
          if (widget.showShimmer && _shimmerController != null && widget.onPressed != null)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _shimmerController!,
                builder: (context, _) {
                  final progress = _shimmerController!.value;
                  // Sweep in the first 60% of the cycle, then brief pause
                  final sweepRatio = (progress / 0.6).clamp(0.0, 1.0);
                  final isSweeping = progress <= 0.6;

                  if (!isSweeping) return const SizedBox.shrink();

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final translateX = -width + (2 * width * sweepRatio);

                      return Transform.translate(
                        offset: Offset(translateX, 0),
                        child: Transform.rotate(
                          angle: 0.35,
                          child: Container(
                            width: width * 0.35,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withValues(alpha: 0.0),
                                  Colors.white.withValues(
                                    alpha: widget.variant == QFButtonVariant.accent ? 0.35 : 0.22,
                                  ),
                                  Colors.white.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

          // Button content (Label, Loader, Icons)
          Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (widget.customLeading != null) ...[
                          widget.customLeading!,
                          const SizedBox(width: 8),
                        ] else if (widget.prefixIcon != null) ...[
                          Icon(widget.prefixIcon, color: fgColor, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            widget.label,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: widget.fontSize ?? 16,
                              fontWeight: widget.fontWeight ?? FontWeight.w600,
                              color: fgColor,
                              letterSpacing: 0.15,
                            ),
                          ),
                        ),
                        if (widget.customTrailing != null) ...[
                          const SizedBox(width: 8),
                          widget.customTrailing!,
                        ] else if (widget.suffixIcon != null) ...[
                          const SizedBox(width: 8),
                          Icon(widget.suffixIcon, color: fgColor, size: 20),
                        ],
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );

    if (isGlass) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: content,
      );
    }

    return content;
  }
}
