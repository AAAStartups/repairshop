import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../controllers/booking_flow_controller.dart';
import '../../../../core/widgets/qf_pressable.dart';
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
    {'id': 'morning', 'label': 'Morning Window', 'time': '9:00 AM – 12:00 PM', 'icon': Icons.wb_twilight_rounded, 'badge': 'Most Popular'},
    {'id': 'afternoon', 'label': 'Afternoon Window', 'time': '12:00 PM – 3:00 PM', 'icon': Icons.wb_sunny_rounded, 'badge': 'Fastest'},
    {'id': 'evening', 'label': 'Evening Window', 'time': '3:00 PM – 7:00 PM', 'icon': Icons.nights_stay_rounded, 'badge': null},
    {'id': 'night', 'label': 'Night Window', 'time': '7:00 PM – 9:00 PM', 'icon': Icons.dark_mode_rounded, 'badge': null},
  ];

  List<DateTime> get _next7Days => List.generate(7, (i) => DateTime.now().add(Duration(days: i)));

  @override
  void initState() {
    super.initState();
    final draft = ref.read(bookingFlowProvider);
    if (draft.pickupDate != null) _selectedDate = draft.pickupDate!;
    if (draft.pickupTimeSlot != null) {
      final match = _timeSlots.where((s) => s['label'] == draft.pickupTimeSlot || s['id'] == draft.pickupTimeSlot || s['time'] == draft.pickupTimeSlot);
      if (match.isNotEmpty) {
        _selectedSlot = match.first['id'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Schedule Pickup Slot',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF003A26),
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Choose convenient date & time for technician arrival',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5F6F67),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Step Indicator
            const QFStepIndicator(
              currentStep: 5,
              totalSteps: 5,
              title: 'Schedule Pickup',
              subtitle: 'Final Step before Review',
            ),

            // --- SCHEDULING CONTENT ---
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                children: [
                  // Free Pickup Guarantee Hero
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF003A26),
                      borderRadius: BorderRadius.circular(20),
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
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: Icon(Icons.two_wheeler_rounded, color: Color(0xFFEDB000), size: 24),
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Free Doorstep Handover',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Executive arrives in verified uniform with toolkit',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11.5,
                                  color: Colors.white70,
                                ),
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
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF003A26),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Date Selection Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Pickup Date',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF003A26),
                        ),
                      ),
                      Text(
                        DateFormat('MMMM yyyy').format(_selectedDate),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5F6F67),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Date Rail
                  SizedBox(
                    height: 84,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _next7Days.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final date = _next7Days[index];
                        final isSelected = DateFormat('yyyyMMdd').format(date) == DateFormat('yyyyMMdd').format(_selectedDate);
                        final isToday = index == 0;

                        return QFPressable(
                          onTap: () => setState(() => _selectedDate = date),
                          pressedScale: 0.94,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 66,
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF003A26) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFEDB000)
                                    : const Color(0xFFE8ECEA),
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected
                                      ? const Color(0xFF003A26).withValues(alpha: 0.25)
                                      : Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 8,
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
                                const SizedBox(height: 3),
                                Text(
                                  DateFormat('d').format(date),
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 20,
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

                  const SizedBox(height: 22),

                  // Time Slots Header
                  const Text(
                    'Available Time Windows',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF003A26),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Slot Cards
                  ..._timeSlots.map((slot) {
                    final isSelected = _selectedSlot == slot['id'];

                    return QFPressable(
                      onTap: () => setState(() => _selectedSlot = slot['id']),
                      pressedScale: 0.98,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF003A26) : const Color(0xFFE8ECEA),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? const Color(0xFF003A26).withValues(alpha: 0.1)
                                  : Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF003A26) : const Color(0xFFF4F6F5),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Icon(
                                  slot['icon'] as IconData,
                                  size: 22,
                                  color: isSelected ? const Color(0xFFEDB000) : const Color(0xFF003A26),
                                ),
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
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: isSelected ? const Color(0xFF003A26) : const Color(0xFF1F2D27),
                                        ),
                                      ),
                                      if (slot['badge'] != null) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEDB000).withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(5),
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
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF5F6F67),
                                    ),
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

            // --- BOTTOM CONTINUE ACTION BAR ---
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
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
              child: QFPressable(
                onTap: () {
                  final slotLabel = _timeSlots.firstWhere((s) => s['id'] == _selectedSlot)['time']!;
                  ref.read(bookingFlowProvider.notifier).updateSchedule(date: _selectedDate, slot: slotLabel);
                  context.push('/booking-summary');
                },
                pressedScale: 0.96,
                child: Container(
                  width: double.infinity,
                  height: 52,
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
                  child: const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Review Booking Summary',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
