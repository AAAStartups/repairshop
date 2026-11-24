import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/qf_pressable.dart';
import '../../../tracking/data/tracking_repository.dart';

class TechnicianDashboardScreen extends ConsumerStatefulWidget {
  const TechnicianDashboardScreen({super.key});

  @override
  ConsumerState<TechnicianDashboardScreen> createState() => _TechnicianDashboardScreenState();
}

class _TechnicianDashboardScreenState extends ConsumerState<TechnicianDashboardScreen> {
  bool _isOnline = true;
  String _selectedPouchCode = 'TP-9924-BLR';
  bool _isPouchScanned = true;

  // 42-Point Diagnostic items
  final Map<String, bool> _diagnosticChecks = {
    'OLED Screen Digitizer & Multi-Touch (10-Point)': true,
    'TrueTone & Ambient Light Calibration': true,
    'FaceID / Biometric Fingerprint Sensor': true,
    'Battery Health Capacity & Thermal Probe': true,
    'Type-C Sub-Board Fast Charging IC (9V/2A)': true,
    'Rear Primary Camera OIS & 4K Video Focus': true,
    'Front TrueDepth Selfie Camera & Mic': true,
    'Stereo Dual Speakers & Earpiece Decibel': true,
    'Proximity Sensor & Accelerometer Gyro': true,
    'Acoustic Waterproofing Perimeter Seal': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003A26),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: QFPressable(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.white),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Technician Operations Hub',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              'Field Specialist: Rajesh Kannan • ID #QF-T881',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: Color(0xFFEDB000),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Text(
                _isOnline ? 'ONLINE' : 'OFFLINE',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: _isOnline ? const Color(0xFF10B981) : Colors.white60,
                ),
              ),
              Switch(
                value: _isOnline,
                activeColor: const Color(0xFF10B981),
                activeTrackColor: Colors.white24,
                onChanged: (val) {
                  setState(() => _isOnline = val);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isOnline ? 'You are now ONLINE for doorstep dispatch.' : 'You are now OFFLINE.'),
                      backgroundColor: const Color(0xFF003A26),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          // Fleet Status Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF080C0A),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDB000).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.electric_moped_rounded, color: Color(0xFFEDB000), size: 24),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assigned Vehicle: KA-03-QF-9081',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'ESD Clean Kit & Thermal Diagnostics Onboard',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('READY', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF10B981))),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Current Active Dispatch Ticket
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEDB000), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF003A26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'ACTIVE DISPATCH • QF-89421',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                    const Text('Slot: 10:00 - 12:00 PM', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF5F6F67))),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Arjun Verma • +91 98765 43210',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF003A26)),
                ),
                const SizedBox(height: 4),
                const Text(
                  '#402, Green Glen Layout, Outer Ring Road, Bellandur, Bengaluru - 560103',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12.5, color: Color(0xFF5F6F67)),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.phone_iphone_rounded, color: Color(0xFF003A26), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Apple iPhone 15 Pro • OEM Screen & Digitizer',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF003A26)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Map & Contact Actions
                Row(
                  children: [
                    Expanded(
                      child: QFPressable(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Launching Google Maps Turn-by-Turn Navigation...')),
                          );
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF003A26),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.navigation_rounded, color: Color(0xFFEDB000), size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'Navigate to Doorstep',
                                  style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    QFPressable(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Calling customer Arjun Verma...')),
                        );
                      },
                      child: Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F6F4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE8ECEA)),
                        ),
                        child: const Icon(Icons.phone_rounded, color: Color(0xFF003A26), size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Tamper-Proof Pouch Scanner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFD1D9D6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tamper-Proof Pouch Verification',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF003A26)),
                    ),
                    Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF003A26)),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Scan the security barcode on the high-grade ESD tamper bag in customer presence.',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 11.5, color: Color(0xFF5F6F67)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F6F4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Seal ID: $_selectedPouchCode',
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF003A26)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    QFPressable(
                      onTap: () {
                        setState(() => _isPouchScanned = true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('✓ Barcode TP-9924-BLR successfully validated and locked to order.')),
                        );
                      },
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: _isPouchScanned ? const Color(0xFF10B981) : const Color(0xFFEDB000),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            _isPouchScanned ? '✓ SEAL VERIFIED' : 'SCAN BARCODE',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF003A26)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // 42-Point Diagnostic Digital Checklist
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFD1D9D6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '42-Point Diagnostic Checklist',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF003A26)),
                    ),
                    Text(
                      '10 Core Checked',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Record initial hardware inspection before transporting to cleanroom facility.',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 11.5, color: Color(0xFF5F6F67)),
                ),
                const SizedBox(height: 12),
                ..._diagnosticChecks.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            entry.key,
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1F2D27)),
                          ),
                        ),
                        Switch(
                          value: entry.value,
                          activeColor: const Color(0xFF10B981),
                          onChanged: (val) {
                            setState(() => _diagnosticChecks[entry.key] = val);
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Advance Milestone Button
          QFPressable(
            onTap: () async {
              final repo = ref.read(trackingRepositoryProvider);
              await repo.advanceStage('QF-89421');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Stage completed! Transferred to Central Cleanroom Lab.'),
                    backgroundColor: Color(0xFF003A26),
                  ),
                );
              }
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
                      'Complete Stage & Seal in Tamper Pouch',
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

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
