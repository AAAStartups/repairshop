import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/qf_pressable.dart';

class RepairTrackingScreen extends StatefulWidget {
  final String orderId;
  const RepairTrackingScreen({super.key, required this.orderId});

  @override
  State<RepairTrackingScreen> createState() => _RepairTrackingScreenState();
}

class _RepairTrackingScreenState extends State<RepairTrackingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;

  static final List<Map<String, dynamic>> _stages = [
    {
      'title': 'Booking Confirmed',
      'sub': 'Your doorstep repair ticket has been registered',
      'icon': Icons.check_circle_rounded,
      'done': true,
      'active': false,
      'time': 'Today, 10:15 AM',
    },
    {
      'title': 'Technician Assigned',
      'sub': 'Senior Specialist assigned with anti-static kit',
      'icon': Icons.badge_rounded,
      'done': true,
      'active': false,
      'time': 'Today, 10:30 AM',
    },
    {
      'title': 'Device Picked Up & Sealed',
      'sub': 'En route to authorized repair lab in tamper-proof pouch #TP-992',
      'icon': Icons.local_shipping_rounded,
      'done': false,
      'active': true,
      'time': 'Live Now',
    },
    {
      'title': 'Received at Central Lab',
      'sub': 'Device will be unboxed under HD camera monitoring',
      'icon': Icons.storefront_rounded,
      'done': false,
      'active': false,
    },
    {
      'title': '42-Point Diagnostic Scan',
      'sub': 'Display, battery health, thermal & logic board test',
      'icon': Icons.biotech_rounded,
      'done': false,
      'active': false,
    },
    {
      'title': 'Transparent Quote Shared',
      'sub': 'Exact OEM parts and labor quotation generated',
      'icon': Icons.receipt_long_rounded,
      'done': false,
      'active': false,
    },
    {
      'title': 'Awaiting Customer Approval',
      'sub': '1-tap approval in app before technician proceeds',
      'icon': Icons.thumb_up_alt_rounded,
      'done': false,
      'active': false,
    },
    {
      'title': 'Precision Repair in Cleanroom',
      'sub': 'Original components installed with ESD protection',
      'icon': Icons.build_circle_rounded,
      'done': false,
      'active': false,
    },
    {
      'title': 'Post-Repair Quality Check',
      'sub': 'Touch calibration, water-seal replacement & stress test',
      'icon': Icons.verified_rounded,
      'done': false,
      'active': false,
    },
    {
      'title': 'Packed with Warranty Certificate',
      'sub': '180-day QuickFix guarantee card enclosed in sealed box',
      'icon': Icons.inventory_2_rounded,
      'done': false,
      'active': false,
    },
    {
      'title': 'Out for Return Delivery',
      'sub': 'Executive arriving at your doorstep with device',
      'icon': Icons.two_wheeler_rounded,
      'done': false,
      'active': false,
    },
    {
      'title': 'Doorstep Verification & Handover',
      'sub': 'Inspect phone functionality with executive, pay post-check',
      'icon': Icons.task_alt_rounded,
      'done': false,
      'active': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: QFPressable(
          onTap: () => context.go('/home'),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8ECEA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF003A26)),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Live Repair Tracker',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF003A26),
              ),
            ),
            Text(
              'Tracking #${widget.orderId}',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: Color(0xFF5F6F67),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Status refreshed: Executive on schedule')),
              );
            },
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF003A26)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Live Hero Status Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF003A26), Color(0xFF1F2D27)],
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF003A26).withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Live Radar Pulse Pill
                    AnimatedBuilder(
                      animation: _pulseCtrl,
                      builder: (_, __) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.15 + (_pulseCtrl.value * 0.15)),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF10B981)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF10B981).withValues(alpha: 0.8),
                                      blurRadius: 6 * _pulseCtrl.value,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'STAGE 3 OF 12 • IN TRANSIT',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF10B981),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Row(
                      children: [
                        Icon(Icons.shield_outlined, color: Color(0xFFEDB000), size: 16),
                        SizedBox(width: 4),
                        Text(
                          '₹50K Insured',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFEDB000),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'En Route to Repair Lab',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Estimated arrival at central diagnostics facility by 02:45 PM',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.5,
                    color: Colors.white70,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 16),

                // Overall Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: 3 / 12,
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFEDB000)),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pickup Complete (25%)',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: Colors.white60),
                    ),
                    Text(
                      'Return by Tomorrow 6 PM',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFEDB000)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 2. Assigned Technician Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFD1D9D6)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFF003A26),
                  child: const Text(
                    'RV',
                    style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w800, color: Color(0xFFEDB000), fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Ramesh Verma',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF003A26),
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 16),
                        ],
                      ),
                      Text(
                        'Assigned Pickup Executive • 4.9 ★ (1,420+ trips)',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 11.5, color: Color(0xFF5F6F67)),
                      ),
                    ],
                  ),
                ),
                QFPressable(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Calling Ramesh Verma (+91 98765 43210)...')),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF003A26),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.phone_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // 3. 12-Stage Visual Stepper Timeline
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Complete 12-Stage Lifecycle',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF003A26),
                  ),
                ),
                Text(
                  'End-to-End Tracking',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5F6F67),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFD1D9D6)),
            ),
            child: Column(
              children: _stages.asMap().entries.map((entry) {
                final i = entry.key;
                final stage = entry.value;
                final isLast = i == _stages.length - 1;
                final isDone = stage['done'] as bool;
                final isActive = stage['active'] as bool;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Node with line
                    Column(
                      children: [
                        if (isActive)
                          AnimatedBuilder(
                            animation: _pulseCtrl,
                            builder: (_, __) {
                              return Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDB000),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFEDB000).withValues(alpha: 0.3 + (_pulseCtrl.value * 0.4)),
                                      blurRadius: 10 + (4 * _pulseCtrl.value),
                                      spreadRadius: 2 * _pulseCtrl.value,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(Icons.sync_rounded, color: Color(0xFF003A26), size: 18),
                                ),
                              );
                            },
                          )
                        else
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: isDone ? const Color(0xFF003A26) : const Color(0xFFF3F6F4),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDone ? const Color(0xFF003A26) : const Color(0xFFD1D9D6),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: isDone
                                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                                  : Text(
                                      '${i + 1}',
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF5F6F67),
                                      ),
                                    ),
                            ),
                          ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: isActive ? 46 : 38,
                            color: isDone ? const Color(0xFF003A26) : const Color(0xFFE8ECEA),
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // Stage Text Content
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: isLast ? 0 : 16, top: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${i + 1}. ${stage['title']}',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13.5,
                                      fontWeight: (isDone || isActive) ? FontWeight.w800 : FontWeight.w600,
                                      color: isActive
                                          ? const Color(0xFF003A26)
                                          : (isDone ? const Color(0xFF003A26) : const Color(0xFF5F6F67)),
                                    ),
                                  ),
                                ),
                                if (stage['time'] != null)
                                  Text(
                                    stage['time'] as String,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11,
                                      fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                                      color: isActive ? const Color(0xFF10B981) : const Color(0xFF5F6F67),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              stage['sub'] as String,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.5,
                                color: isActive ? const Color(0xFF003A26) : const Color(0xFF5F6F67),
                                fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                                height: 1.3,
                              ),
                            ),
                            if (isActive) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF003A26).withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.shield_outlined, size: 14, color: Color(0xFF003A26)),
                                    SizedBox(width: 6),
                                    Text(
                                      'Tamper-evident seal intact',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF003A26),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // 4. Support & Help Card
          QFPressable(
            onTap: () => context.push('/support'),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD1D9D6)),
              ),
              child: const Row(
                children: [
                  Text('💬', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Have a Question or Need Changes?',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF003A26),
                          ),
                        ),
                        Text(
                          'Chat with senior support or request manager call',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Color(0xFF5F6F67)),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF5F6F67)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
