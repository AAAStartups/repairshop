import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/qf_pressable.dart';
import '../../data/tracking_repository.dart';

class RepairTrackingScreen extends ConsumerStatefulWidget {
  final String orderId;
  const RepairTrackingScreen({super.key, required this.orderId});

  @override
  ConsumerState<RepairTrackingScreen> createState() => _RepairTrackingScreenState();
}

class _RepairTrackingScreenState extends ConsumerState<RepairTrackingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  bool _isAdvancing = false;

  static final List<Map<String, dynamic>> _defaultStages = [
    {
      'title': 'Booking Confirmed',
      'sub': 'Your doorstep repair ticket has been registered',
      'icon': Icons.check_circle_rounded,
      'time': '10:15 AM',
    },
    {
      'title': 'Technician Assigned',
      'sub': 'Certified Technician assigned with ESD mobile toolkit',
      'icon': Icons.badge_rounded,
      'time': '10:30 AM',
    },
    {
      'title': 'Device Picked Up & Sealed',
      'sub': 'En route to authorized repair lab in tamper-proof pouch #TP-992',
      'icon': Icons.local_shipping_rounded,
      'time': 'Live Now',
    },
    {
      'title': 'Received at Central Cleanroom Lab',
      'sub': 'Device unboxed under HD camera monitoring',
      'icon': Icons.storefront_rounded,
    },
    {
      'title': '42-Point Diagnostic Scan',
      'sub': 'Display, battery health, thermal & logic board test',
      'icon': Icons.biotech_rounded,
    },
    {
      'title': 'Transparent Quote Shared',
      'sub': 'Exact OEM parts and zero-advance quotation verified',
      'icon': Icons.receipt_long_rounded,
    },
    {
      'title': 'Awaiting Customer Approval',
      'sub': '1-tap approval in app before technician proceeds',
      'icon': Icons.thumb_up_alt_rounded,
    },
    {
      'title': 'Precision Repair in Cleanroom',
      'sub': 'Original components installed with ESD protection',
      'icon': Icons.build_circle_rounded,
    },
    {
      'title': 'Post-Repair Quality Check',
      'sub': 'Touch calibration, water-seal replacement & stress test',
      'icon': Icons.verified_rounded,
    },
    {
      'title': 'Packed with Warranty Certificate',
      'sub': '180-day QuickFix guarantee certificate enclosed in box',
      'icon': Icons.inventory_2_rounded,
    },
    {
      'title': 'Out for Return Delivery',
      'sub': 'Executive arriving at your doorstep with repaired device',
      'icon': Icons.two_wheeler_rounded,
    },
    {
      'title': 'Doorstep Verification & Handover',
      'sub': 'Inspect phone functionality with executive, pay post-check',
      'icon': Icons.task_alt_rounded,
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

  Future<void> _handleAdvanceStage() async {
    setState(() => _isAdvancing = true);
    final success = await ref.read(trackingRepositoryProvider).advanceStage(widget.orderId);
    if (mounted) {
      ref.invalidate(orderTrackingProvider(widget.orderId));
      setState(() => _isAdvancing = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⏩ Order advanced to the next milestone in real-time!'),
            backgroundColor: Color(0xFF003A26),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showDoorstepPaymentModal(BuildContext context, Map<String, dynamic>? order) {
    final total = order?['totalAmount'] != null ? '₹${(order!['totalAmount'] as num).toInt()}' : '₹3,899';
    final device = order?['device'] ?? 'Apple iPhone 15 Pro';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8ECEA),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Doorstep Post-Service Payment',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF003A26),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Zero Advance • Verify phone first before paying',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: const Color(0xFF5F6F67),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'VERIFIED',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Amount Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F6F4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8ECEA)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Payable Amount',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Color(0xFF5F6F67),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        device,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: Color(0xFF003A26),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    total,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF003A26),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Dynamic UPI QR Visual
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFEDB000), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.qr_code_2_rounded, size: 140, color: Color(0xFF003A26)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/e/e1/UPI-Logo-vector.svg',
                          height: 14,
                          errorBuilder: (_, __, ___) => const Text('UPI', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Scan with any UPI App (GPay, PhonePe, Paytm)',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF5F6F67),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Pay & Claim Warranty Button
            QFPressable(
              onTap: () {
                Navigator.pop(ctx);
                context.push('/warranty/${widget.orderId}?device=${Uri.encodeComponent(device)}&amount=${total.replaceAll("₹", "")}');
              },
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDB000),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEDB000).withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded, color: Color(0xFF003A26)),
                      SizedBox(width: 8),
                      Text(
                        'Simulate Payment & View 180-Day Guarantee',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF003A26),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(orderTrackingProvider(widget.orderId));
    final order = orderAsync.valueOrNull;

    if (orderAsync.isLoading && order == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF3F6F4),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
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
          title: Text(
            'Order #${widget.orderId}',
            style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF003A26)),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Color(0xFF003A26)),
              SizedBox(height: 16),
              Text(
                'Retrieving live lab telemetry...',
                style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Color(0xFF5F6F67), fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );
    }

    if (order == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF3F6F4),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
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
          title: Text(
            'Order #${widget.orderId}',
            style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF003A26)),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.search_off_rounded, size: 64, color: Color(0xFF5F6F67)),
                const SizedBox(height: 16),
                Text(
                  'Order #${widget.orderId} Not Found',
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF003A26)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'No active booking found with this tracking ID. Please verify the booking reference number.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Color(0xFF5F6F67)),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003A26),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentStageIndex = (order['currentStageIndex'] as int?) ?? 1;
    final totalAmount = '₹${(order['totalAmount'] as num? ?? 0).toInt()}';
    final device = (order['device'] as String?) ?? 'Device';
    final tech = order['technician'];
    final techName = tech?['name'] ?? 'Assigned Specialist';
    final techVehicle = tech?['vehicle'] ?? 'QuickFix Express Unit';
    final techRating = (tech?['rating'] as num?)?.toDouble() ?? 4.9;

    final activeStage = _defaultStages[(currentStageIndex - 1).clamp(0, _defaultStages.length - 1)];

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
              ref.invalidate(orderTrackingProvider(widget.orderId));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Status refreshed: Pulling latest lab telemetry...'),
                  backgroundColor: Color(0xFF003A26),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF003A26)),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF003A26),
        onRefresh: () async {
          ref.invalidate(orderTrackingProvider(widget.orderId));
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 1. Live Hero Status Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF003A26), Color(0xFF080C0A)],
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
                                Text(
                                  'STAGE $currentStageIndex OF 12 • LIVE',
                                  style: const TextStyle(
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

                  Text(
                    activeStage['title'] as String,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.4,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    activeStage['sub'] as String,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.5,
                      color: Colors.white.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Device & Total Estimate Strip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.phone_iphone_rounded, color: Color(0xFFEDB000), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              device,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'ZERO ADVANCE • ',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFEDB000),
                              ),
                            ),
                            Text(
                              totalAmount,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
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

            const SizedBox(height: 14),

            // 2. Doorstep Executive Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFD1D9D6)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFF003A26),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Icon(Icons.engineering_rounded, color: Color(0xFFEDB000), size: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              techName,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF003A26),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                '✓ CERTIFIED',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$techVehicle • $techRating ★',
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 11.5, color: Color(0xFF5F6F67)),
                        ),
                      ],
                    ),
                  ),
                  QFPressable(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Calling $techName (+91 99887 76655)...'),
                          backgroundColor: const Color(0xFF003A26),
                        ),
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

            const SizedBox(height: 14),

            // Interactive Actions Bar (Advance Stage & View Warranty Certificate)
            Row(
              children: [
                Expanded(
                  child: QFPressable(
                    onTap: _isAdvancing ? null : _handleAdvanceStage,
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF003A26)),
                      ),
                      child: Center(
                        child: _isAdvancing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF003A26)),
                              )
                            : const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.fast_forward_rounded, color: Color(0xFF003A26), size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    'Advance Milestone ⏩',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF003A26),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: QFPressable(
                    onTap: () => _showDoorstepPaymentModal(context, order),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDB000),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEDB000).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.payments_rounded, color: Color(0xFF003A26), size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Pay & Warranty',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF003A26),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                    'Live Updates',
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
                children: _defaultStages.asMap().entries.map((entry) {
                  final i = entry.key;
                  final stageIndex = i + 1;
                  final stage = entry.value;
                  final isLast = i == _defaultStages.length - 1;

                  final isDone = stageIndex < currentStageIndex;
                  final isActive = stageIndex == currentStageIndex;

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
                                        '$stageIndex',
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
                                      '$stageIndex. ${stage['title']}',
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

            // 4. Support & Warranty Guarantee Strip
            QFPressable(
              onTap: () => context.push('/warranty/${widget.orderId}?device=${Uri.encodeComponent(device)}&amount=${totalAmount.replaceAll("₹", "")}'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEDB000), width: 1.2),
                ),
                child: const Row(
                  children: [
                    Text('🛡️', style: TextStyle(fontSize: 24)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '180-Day QuickFix Diamond Warranty',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF003A26),
                            ),
                          ),
                          Text(
                            'Tap to view your active warranty certificate & cleanroom seal',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Color(0xFF5F6F67)),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF003A26)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
