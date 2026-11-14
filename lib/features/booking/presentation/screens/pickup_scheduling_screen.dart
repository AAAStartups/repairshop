import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../controllers/booking_flow_controller.dart';
import '../../../../core/widgets/qf_step_indicator.dart';

class PickupSchedulingScreen extends ConsumerStatefulWidget {
  const PickupSchedulingScreen({super.key});

  @override
  ConsumerState<PickupSchedulingScreen> createState() => _PickupSchedulingScreenState();
}

class _PickupSchedulingScreenState extends ConsumerState<PickupSchedulingScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedSlot = 'morning';

  final List<Map<String, dynamic>> _timeSlots = [
    {'id': 'morning', 'label': 'Morning Window', 'time': '9:00 AM – 12:00 PM', 'emoji': '🌅', 'badge': 'Most Popular'},
    {'id': 'afternoon', 'label': 'Afternoon Window', 'time': '12:00 PM – 3:00 PM', 'emoji': '☀️', 'badge': 'Quickest'},
    {'id': 'evening', 'label': 'Evening Window', 'time': '3:00 PM – 7:00 PM', 'emoji': '🌇', 'badge': null},
    {'id': 'night', 'label': 'Night Window', 'time': '7:00 PM – 9:00 PM', 'emoji': '🌙', 'badge': null},
  ];

  List<DateTime> get _next7Days => List.generate(7, (i) => DateTime.now().add(Duration(days: i)));

  @override
  void initState() {
    super.initState();
    final draft = ref.read(bookingFlowProvider);
    if (draft.pickupDate != null) _selectedDate = draft.pickupDate!;
    if (draft.pickupTimeSlot != null) {
      final match = _timeSlots.where((s) => s['label'] == draft.pickupTimeSlot || s['id'] == draft.pickupTimeSlot);
      if (match.isNotEmpty) {
        _selectedSlot = match.first['id'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFE8ECEA), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF003A26)),
          ),
        ),
        title: const Text(
          'Select Pickup Slot',
          style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF003A26)),
        ),
      ),
      body: Column(
        children: [
          QFStepIndicator(
            currentStep: 5,
            totalSteps: 5,
            title: 'Schedule Pickup',
            subtitle: 'Final Step',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(18),
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF003A26), Color(0xFF004D33)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF003A26).withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(child: Text('🚚', style: TextStyle(fontSize: 22))),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Free Doorstep Handover',
                              style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Executive arrives in verified uniform with toolkit',
                              style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDB000),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'FREE',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF003A26)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Preferred Date',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF003A26)),
                    ),
                    Text(
                      DateFormat('MMMM yyyy').format(_selectedDate),
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF5F6F67)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 85,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _next7Days.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final date = _next7Days[index];
                      final isSelected = DateFormat('yyyyMMdd').format(date) == DateFormat('yyyyMMdd').format(_selectedDate);
                      final isToday = index == 0;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedDate = date),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 64,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF003A26) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? const Color(0xFFEDB000) : const Color(0xFFD1D9D6).withValues(alpha: 0.8),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? const Color(0xFF003A26).withValues(alpha: 0.25)
                                    : Colors.black.withValues(alpha: 0.02),
                                blurRadius: isSelected ? 10 : 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isToday ? 'TODAY' : DateFormat('EEE').format(date).toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected ? const Color(0xFFEDB000) : const Color(0xFF5F6F67),
                                  letterSpacing: 0.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('d').format(date),
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: isSelected ? Colors.white : const Color(0xFF003A26),
                                ),
                              ),
                              Text(
                                DateFormat('MMM').format(date),
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white70 : const Color(0xFF5F6F67),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Available Time Windows',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF003A26)),
                ),
                const SizedBox(height: 12),
                ..._timeSlots.map((slot) {
                  final isSelected = _selectedSlot == slot['id'];

                  return GestureDetector(
                    onTap: () => setState(() => _selectedSlot = slot['id']),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF003A26) : const Color(0xFFD1D9D6).withValues(alpha: 0.8),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? const Color(0xFF003A26).withValues(alpha: 0.1)
                                : Colors.black.withValues(alpha: 0.02),
                            blurRadius: isSelected ? 12 : 4,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF003A26) : const Color(0xFFF3F6F4),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(slot['emoji']!, style: const TextStyle(fontSize: 20)),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      slot['label']!,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF003A26),
                                      ),
                                    ),
                                    if (slot['badge'] != null) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEDB000).withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          slot['badge']!,
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF003A26),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  slot['time']!,
                                  style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF5F6F67)),
                                ),
                              ],
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? const Color(0xFF003A26) : Colors.transparent,
                              border: Border.all(
                                color: isSelected ? const Color(0xFF003A26) : const Color(0xFFD1D9D6),
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? const Center(
                                    child: Icon(Icons.check_rounded, color: Color(0xFFEDB000), size: 14),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
            color: Colors.white,
            child: GestureDetector(
              onTap: () {
                final slotLabel = _timeSlots.firstWhere((s) => s['id'] == _selectedSlot)['time']!;
                ref.read(bookingFlowProvider.notifier).updateSchedule(date: _selectedDate, slot: slotLabel);
                context.push('/booking-summary');
              },
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEDB000), Color(0xFFF9BF1C)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEDB000).withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Review Booking Summary',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF003A26)),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, color: Color(0xFF003A26), size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
