import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../booking/presentation/controllers/booking_flow_controller.dart';
import '../../../../core/widgets/qf_pressable.dart';
import '../../../../core/widgets/qf_step_indicator.dart';
import '../../domain/models/repair_service_model.dart';

class RepairSelectionScreen extends ConsumerWidget {
  const RepairSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingFlowProvider);
    final selectedIds = draft.selectedServiceIds;
    final brandName = draft.brandName ?? 'Apple';
    final modelName = draft.modelName ?? 'Device';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F5),
      body: SafeArea(
        child: Column(
          children: [
            // --- TOP APP BAR ---
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  QFPressable(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8ECEA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: Color(0xFF003A26),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Required Service(s)',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF003A26),
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF003A26).withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '$brandName $modelName',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF003A26),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Step Indicator
            const QFStepIndicator(
              currentStep: 3,
              totalSteps: 5,
              title: 'Select Issues',
              subtitle: 'Select one or more repairs',
            ),

            // Informational Notice Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              color: const Color(0xFF003A26).withValues(alpha: 0.06),
              child: const Row(
                children: [
                  Icon(Icons.touch_app_rounded, size: 15, color: Color(0xFF003A26)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Multi-select allowed. Free doorstep diagnosis is always included.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF003A26),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- REPAIR SERVICES LIST ---
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                physics: const BouncingScrollPhysics(),
                itemCount: mockRepairServices.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final service = mockRepairServices[index];
                  final isSelected = selectedIds.contains(service.id);

                  return QFPressable(
                    onTap: () {
                      ref.read(bookingFlowProvider.notifier).toggleService(
                            service.id,
                            service.name,
                            service.estimatedPrice ?? 0,
                          );
                    },
                    pressedScale: 0.98,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF003A26)
                              : const Color(0xFFE8ECEA),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? const Color(0xFF003A26).withValues(alpha: 0.1)
                                : Colors.black.withValues(alpha: 0.02),
                            blurRadius: isSelected ? 12 : 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Emoji / Service Icon Badge
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF003A26)
                                  : const Color(0xFFF3F6F4),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                service.iconEmoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Service Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        service.name,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w800,
                                          color: isSelected
                                              ? const Color(0xFF003A26)
                                              : const Color(0xFF1F2D27),
                                        ),
                                      ),
                                    ),
                                    // Custom Animated Checkbox
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: isSelected ? const Color(0xFFEDB000) : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(0xFFEDB000)
                                              : const Color(0xFFD1D9D6),
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(Icons.check_rounded, color: Color(0xFF003A26), size: 16)
                                          : null,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  service.description,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11.5,
                                    color: Color(0xFF5F6F67),
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Badges Row: Price + Turnaround + Warranty
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                                      decoration: BoxDecoration(
                                        color: service.isPriceOnInspection
                                            ? const Color(0xFFE8ECEA)
                                            : const Color(0xFFEDB000).withValues(alpha: 0.18),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        service.priceDisplay,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: service.isPriceOnInspection
                                              ? const Color(0xFF5F6F67)
                                              : const Color(0xFF003A26),
                                        ),
                                      ),
                                    ),
                                    if (service.estimatedTime != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3F6F4),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: const Color(0xFFE8ECEA)),
                                        ),
                                        child: Text(
                                          '⏱ ${service.estimatedTime}',
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF5F6F67),
                                          ),
                                        ),
                                      ),
                                    if (service.warrantyPeriod != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '🛡 ${service.warrantyPeriod}',
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF065F46),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // --- STICKY FLOATING SUMMARY BAR ---
            if (selectedIds.isNotEmpty)
              Container(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 18,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF003A26),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${selectedIds.length} SELECTED',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            draft.estimatedCost > 0
                                ? '₹${draft.estimatedCost.toInt()} est.'
                                : 'Price on diagnosis',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF003A26),
                            ),
                          ),
                        ],
                      ),
                    ),
                    QFPressable(
                      onTap: () => context.push('/describe-problem'),
                      pressedScale: 0.94,
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDB000),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFEDB000).withValues(alpha: 0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'Next: Details',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.5,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF003A26),
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, color: Color(0xFF003A26), size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
