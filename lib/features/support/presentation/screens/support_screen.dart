import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/qf_pressable.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  final List<Map<String, String>> _faqs = const [
    {
      'q': 'How long does a smartphone/laptop repair typically take?',
      'a': 'Most minor repairs (like display, battery, charging ports) are completed within 2 to 4 hours. Logic board chip-level diagnostics generally take 24 to 48 hours with live status updates at every stage.',
    },
    {
      'q': 'What is covered under the 180-Day QuickFix Guarantee?',
      'a': 'All replacement parts installed by QuickFix carry a 180-day guarantee against manufacturing defects, touch responsiveness issues, or premature degradation. If any defect appears, we repair or replace it at zero cost.',
    },
    {
      'q': 'Is doorstep pickup and return delivery really 100% free?',
      'a': 'Yes, completely free! There are zero hidden convenience or logistics charges. Even if you choose not to proceed with the repair post-diagnosis, return delivery is free.',
    },
    {
      'q': 'When do I have to make the payment?',
      'a': 'Zero advance payment is required. You only pay after your device is repaired, delivered back to your doorstep, and verified by you in front of our delivery specialist.',
    },
    {
      'q': 'How is my device protected during transit and in the lab?',
      'a': 'Every device is barcoded, sealed in an ESD tamper-proof pouch with security seals, and transit-insured up to ₹50,000. All unboxing and bench procedures are recorded under HD CCTV surveillance.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: QFPressable(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8ECEA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF003A26)),
          ),
        ),
        title: const Text(
          'Customer Concierge',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF003A26),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 24/7 Availability Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF003A26),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.headset_mic_rounded, color: Color(0xFFEDB000), size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Direct Support Available',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      Text(
                        'Average callback response time under 3 minutes',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 11.5, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Action Grid
          Row(
            children: [
              Expanded(
                child: QFPressable(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Dialing QuickFix toll-free hotline: 1800-419-FIX')),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE8ECEA)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF003A26).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.phone_in_talk_rounded, color: Color(0xFF003A26), size: 22),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Call Support',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF003A26)),
                        ),
                        const Text(
                          '9 AM - 9 PM daily',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 11.5, color: Color(0xFF5F6F67)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QFPressable(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Initiating WhatsApp chat thread...')),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE8ECEA)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.chat_bubble_rounded, color: Color(0xFF10B981), size: 22),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'WhatsApp Chat',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF003A26)),
                        ),
                        const Text(
                          'Instant AI + Agent reply',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 11.5, color: Color(0xFF5F6F67)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF003A26),
            ),
          ),
          const SizedBox(height: 12),

          ..._faqs.map(
            (faq) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8ECEA)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Theme(
                data: ThemeData(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  iconColor: const Color(0xFF003A26),
                  collapsedIconColor: const Color(0xFF5F6F67),
                  title: Text(
                    faq['q']!,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF003A26),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        faq['a']!,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.5,
                          color: Color(0xFF5F6F67),
                          height: 1.4,
                        ),
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
