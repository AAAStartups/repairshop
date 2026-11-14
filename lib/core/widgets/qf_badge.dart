import 'package:flutter/material.dart';
import 'qf_animated_pulse.dart';

enum QFBadgeVariant { success, warning, error, info, primary, accent, neutral }

class QFBadge extends StatelessWidget {
  final String label;
  final QFBadgeVariant variant;
  final IconData? icon;
  final bool filled;
  final bool isPulsing;

  const QFBadge({
    super.key,
    required this.label,
    this.variant = QFBadgeVariant.primary,
    this.icon,
    this.filled = false,
    this.isPulsing = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (variant) {
      case QFBadgeVariant.success:
        bgColor = filled ? const Color(0xFF10B981) : const Color(0xFF10B981).withValues(alpha: 0.12);
        textColor = filled ? Colors.white : const Color(0xFF10B981);
        break;
      case QFBadgeVariant.warning:
        bgColor = filled ? const Color(0xFFEDB000) : const Color(0xFFEDB000).withValues(alpha: 0.15);
        textColor = filled ? const Color(0xFF003A26) : const Color(0xFFD4A000);
        break;
      case QFBadgeVariant.error:
        bgColor = filled ? const Color(0xFFEF4444) : const Color(0xFFEF4444).withValues(alpha: 0.12);
        textColor = filled ? Colors.white : const Color(0xFFEF4444);
        break;
      case QFBadgeVariant.info:
        bgColor = filled ? const Color(0xFF3B82F6) : const Color(0xFF3B82F6).withValues(alpha: 0.12);
        textColor = filled ? Colors.white : const Color(0xFF3B82F6);
        break;
      case QFBadgeVariant.accent:
        bgColor = filled ? const Color(0xFFEDB000) : const Color(0xFFEDB000).withValues(alpha: 0.15);
        textColor = const Color(0xFF003A26);
        break;
      case QFBadgeVariant.neutral:
        bgColor = const Color(0xFFE8ECEA);
        textColor = const Color(0xFF5F6F67);
        break;
      default:
        bgColor = filled ? const Color(0xFF003A26) : const Color(0xFF003A26).withValues(alpha: 0.08);
        textColor = filled ? Colors.white : const Color(0xFF003A26);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isPulsing) ...[
            QFAnimatedPulse(
              size: 6.0,
              glowRadius: 10.0,
              color: textColor,
              showCoreGlow: true,
            ),
            const SizedBox(width: 5),
          ] else if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
