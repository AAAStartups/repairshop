import 'package:flutter/material.dart';

class QFStepIndicator extends StatelessWidget {
  final int currentStep; // 1 to 5
  final int totalSteps;
  final String title;
  final String? subtitle;

  const QFStepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: List.generate(totalSteps, (index) {
              final step = index + 1;
              final isPassed = step < currentStep;
              final isCurrent = step == currentStep;

              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 6),
                  decoration: BoxDecoration(
                    color: isPassed
                        ? const Color(0xFF003A26)
                        : (isCurrent ? const Color(0xFFEDB000) : const Color(0xFFE8ECEA)),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'STEP $currentStep OF $totalSteps',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF5F6F67),
                  letterSpacing: 0.6,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF003A26),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

