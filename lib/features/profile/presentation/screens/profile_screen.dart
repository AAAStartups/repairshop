import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../core/widgets/qf_pressable.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    if (!auth.isAuthenticated) {
      return _GuestProfileView(ref: ref);
    }

    final menuItems = [
      {'icon': Icons.person_outline_rounded, 'title': 'Personal Information', 'badge': null},
      {'icon': Icons.location_on_outlined, 'title': 'Saved Addresses', 'badge': '2 Saved'},
      {'icon': Icons.smartphone_rounded, 'title': 'My Registered Devices', 'badge': 'iPhone 16 Pro'},
      {'icon': Icons.receipt_long_rounded, 'title': 'Invoices & Warranty Cards', 'badge': 'Available'},
      {'icon': Icons.headset_mic_rounded, 'title': 'Dedicated Concierge Support', 'badge': '24/7 Priority'},
      {'icon': Icons.security_rounded, 'title': 'Data Privacy & Device Security', 'badge': null},
      {'icon': Icons.description_outlined, 'title': 'Terms of Service', 'badge': null},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F4),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header Profile Hero Card
          Container(
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF003A26), Color(0xFF1F2D27)],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDB000),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEDB000).withValues(alpha: 0.3),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'JD',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF003A26),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                auth.user?.name ?? 'John Doe',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDB000),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'GOLD',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF003A26),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            auth.user?.phone ?? '+91 98765 43210',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Metrics Strip
                Row(
                  children: [
                    _MetricPill(label: 'Total Repairs', value: '3'),
                    const SizedBox(width: 8),
                    _MetricPill(label: 'Active Order', value: '1 Live', highlight: true),
                    const SizedBox(width: 8),
                    _MetricPill(label: 'Saved Value', value: '₹2,400'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Menu items container
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE8ECEA)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: menuItems.asMap().entries.map((entry) {
                final item = entry.value;
                final isLast = entry.key == menuItems.length - 1;
                final badge = item['badge'] as String?;

                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFF003A26).withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item['icon'] as IconData, size: 20, color: const Color(0xFF003A26)),
                      ),
                      title: Text(
                        item['title'] as String,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF003A26),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (badge != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8ECEA),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                badge,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF5F6F67),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF5F6F67), size: 14),
                        ],
                      ),
                      onTap: () {
                        if (item['title'] == 'Dedicated Concierge Support') {
                          context.push('/support');
                        }
                      },
                    ),
                    if (!isLast) const Divider(indent: 64, height: 1, color: Color(0xFFE8ECEA)),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 14),

          // Sign out button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: QFPressable(
              onTap: () => ref.read(authProvider.notifier).logout(),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _MetricPill({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: highlight ? 0.16 : 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: highlight ? const Color(0xFFEDB000) : Colors.white.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: highlight ? const Color(0xFFEDB000) : Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10.5,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _GuestProfileView extends StatefulWidget {
  final WidgetRef ref;
  const _GuestProfileView({required this.ref});

  @override
  State<_GuestProfileView> createState() => _GuestProfileViewState();
}

class _GuestProfileViewState extends State<_GuestProfileView> {
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  bool _showOtp = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = widget.ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F4),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: const Color(0xFF003A26).withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_rounded, size: 40, color: Color(0xFF003A26)),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Guest Mode Active',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF003A26),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'You can explore all repair pricing, diagnostics & models without logging in.\nSign in anytime with OTP to view past invoices and active trackers.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: Color(0xFF5F6F67),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFD1D9D6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_showOtp) ...[
                        const Text(
                          'Mobile Number',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF003A26),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF003A26),
                          ),
                          decoration: InputDecoration(
                            hintText: '98765 43210',
                            prefixIcon: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              child: const Text('🇮🇳 +91', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, color: Color(0xFF003A26))),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF3F6F4),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Color(0xFFD1D9D6)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        QFPressable(
                          onTap: auth.isLoading
                              ? null
                              : () async {
                                  if (_phoneCtrl.text.trim().length >= 10) {
                                    await widget.ref.read(authProvider.notifier).sendOtp(_phoneCtrl.text);
                                    setState(() => _showOtp = true);
                                  }
                                },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF003A26),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: auth.isLoading
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text(
                                      'Send Verification OTP',
                                      style: TextStyle(fontFamily: 'Inter', fontSize: 14.5, fontWeight: FontWeight.w800, color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Code sent to +91 ${_phoneCtrl.text}',
                              style: const TextStyle(fontFamily: 'Inter', fontSize: 12.5, color: Color(0xFF5F6F67)),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _showOtp = false),
                              child: const Text('Edit', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, color: Color(0xFF003A26))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _otpCtrl,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 12, color: Color(0xFF003A26)),
                          decoration: InputDecoration(
                            hintText: '••••••',
                            counterText: '',
                            filled: true,
                            fillColor: const Color(0xFFF3F6F4),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFD1D9D6))),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _otpCtrl.text = '123456',
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDB000).withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '⚡ Tap to use Demo OTP: 123456',
                              style: TextStyle(fontFamily: 'Inter', fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF003A26)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        QFPressable(
                          onTap: auth.isLoading
                              ? null
                              : () async {
                                  await widget.ref.read(authProvider.notifier).verifyOtp(_otpCtrl.text);
                                },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDB000),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: auth.isLoading
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Color(0xFF003A26), strokeWidth: 2))
                                  : const Text(
                                      'Verify & Sign In',
                                      style: TextStyle(fontFamily: 'Inter', fontSize: 14.5, fontWeight: FontWeight.w800, color: Color(0xFF003A26)),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
