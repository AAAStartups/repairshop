import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/qf_pressable.dart';

class WarrantyCertificateScreen extends StatelessWidget {
  final String orderId;
  final String? deviceName;
  final double? amount;

  const WarrantyCertificateScreen({
    super.key,
    required this.orderId,
    this.deviceName,
    this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final issueDate = DateFormat('dd MMM yyyy').format(now);
    final expiryDate = DateFormat('dd MMM yyyy').format(now.add(const Duration(days: 180)));
    final device = deviceName ?? 'Apple iPhone 15 Pro';
    final total = amount != null ? '₹${amount!.toInt()}' : '₹3,899';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: QFPressable(
          onTap: () => context.pop(),
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
          'Warranty & Tax Invoice',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF003A26),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('📄 Generating official tax invoice PDF with GST compliance...'),
                  backgroundColor: Color(0xFF003A26),
                ),
              );
            },
            icon: const Icon(Icons.download_rounded, color: Color(0xFF003A26)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          // CERTIFICATE CONTAINER
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFEDB000), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF003A26).withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Gold Foil Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF003A26), Color(0xFF080C0A)],
                    ),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDB000).withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFEDB000)),
                                ),
                                child: const Icon(Icons.verified_user_rounded, color: Color(0xFFEDB000), size: 20),
                              ),
                              const SizedBox(width: 10),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'QuickFix Care',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  Text(
                                    'CLASS-100 CLEANROOM LAB CERTIFIED',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFEDB000),
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDB000),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '180 DAYS',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10.5,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF003A26),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'DIAMOND SERVICE WARRANTY CERTIFICATE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFEDB000),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Certificate ID: QF-WAR-${orderId.replaceAll("QF-", "")}',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.7),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Certificate Body Details
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('SERVICED DEVICE', device),
                      const SizedBox(height: 14),
                      _buildInfoRow('SERVICE ORDER ID', orderId),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(child: _buildInfoRow('ISSUED DATE', issueDate)),
                          Expanded(child: _buildInfoRow('VALID UNTIL', expiryDate, isHighlight: true)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFFE8ECEA)),
                      const SizedBox(height: 12),

                      // Covered Components
                      const Text(
                        'COVERED COMPONENTS & WORKMANSHIP',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF5F6F67),
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildCoverageItem('OEM Grade Display & Touch Digitizer Panel'),
                      _buildCoverageItem('Waterproofing Acoustic Gasket & Frame Adhesive'),
                      _buildCoverageItem('Zero Touch Sensitivity Loss Guarantee'),
                      _buildCoverageItem('Free Doorstep Re-Inspection if defects occur'),

                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFFE8ECEA)),
                      const SizedBox(height: 12),

                      // Tax Invoice Summary
                      const Text(
                        'TAX INVOICE BREAKDOWN (ZERO-ADVANCE FULFILLED)',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF5F6F67),
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildInvoiceRow('OEM Component & Replacement Fee', total),
                      _buildInvoiceRow('Class-100 Cleanroom Diagnostics', '₹0 (Free)'),
                      _buildInvoiceRow('Doorstep Pickup & Return Dispatch', '₹0 (Free)'),
                      _buildInvoiceRow('GST (18% inclusive)', 'Included'),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F6F4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Paid Post-Verification',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF003A26),
                              ),
                            ),
                            Text(
                              total,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF003A26),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Seal & Signature
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  '✓ DIGITALLY SIGNED',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF10B981),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'QuickFix Lab QA Manager',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF003A26),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF003A26), width: 1.5),
                            ),
                            child: const Center(
                              child: Text(
                                'QUICKFIX\nSEAL\n★',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF003A26),
                                  height: 1.1,
                                ),
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

          const SizedBox(height: 18),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: QFPressable(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('📲 Certificate link copied to clipboard for sharing!'),
                        backgroundColor: Color(0xFF003A26),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF003A26)),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.share_outlined, size: 18, color: Color(0xFF003A26)),
                          SizedBox(width: 8),
                          Text(
                            'Share Certificate',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.5,
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
              const SizedBox(width: 12),
              Expanded(
                child: QFPressable(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🛡️ Need warranty service? A technician will be assigned immediately.'),
                        backgroundColor: Color(0xFF003A26),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDB000),
                      borderRadius: BorderRadius.circular(14),
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
                          Icon(Icons.verified_rounded, size: 18, color: Color(0xFF003A26)),
                          SizedBox(width: 8),
                          Text(
                            'Claim Guarantee',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.5,
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
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  static Widget _buildInfoRow(String label, String value, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Color(0xFF5F6F67),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            color: isHighlight ? const Color(0xFF10B981) : const Color(0xFF003A26),
          ),
        ),
      ],
    );
  }

  static Widget _buildCoverageItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Color(0xFF1F2D27),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildInvoiceRow(String item, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: Color(0xFF5F6F67),
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF003A26),
            ),
          ),
        ],
      ),
    );
  }
}
