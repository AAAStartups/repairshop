import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/qf_pressable.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F6F4),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: const Text(
            'My Service Orders',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF003A26),
            ),
          ),
          bottom: const TabBar(
            labelColor: Color(0xFF003A26),
            unselectedLabelColor: Color(0xFF5F6F67),
            indicatorColor: Color(0xFFEDB000),
            indicatorWeight: 3.5,
            labelStyle: TextStyle(fontFamily: 'Inter', fontSize: 13.5, fontWeight: FontWeight.w800),
            unselectedLabelStyle: TextStyle(fontFamily: 'Inter', fontSize: 13.5, fontWeight: FontWeight.w500),
            tabs: [
              Tab(text: 'Active (1)'),
              Tab(text: 'Completed (2)'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ActiveOrdersTab(),
            _CompletedOrdersTab(),
            _EmptyTab(title: 'No cancelled orders', subtitle: 'Any cancelled requests will show here'),
          ],
        ),
      ),
    );
  }
}

class _ActiveOrdersTab extends StatelessWidget {
  const _ActiveOrdersTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _OrderCard(
          orderId: 'QF-89421',
          device: 'iPhone 16 Pro Max',
          brand: 'Apple',
          service: 'Display Assembly + Screen Calibration',
          status: 'Stage 3: Device Picked Up',
          isLive: true,
          date: 'Today, 10:30 AM',
          eta: 'Return: Tomorrow 6 PM',
          price: '₹4,999 (Pay on delivery)',
          onTap: () => context.push('/track-repair/QF-89421'),
        ),
      ],
    );
  }
}

class _CompletedOrdersTab extends StatelessWidget {
  const _CompletedOrdersTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _OrderCard(
          orderId: 'QF-77210',
          device: 'MacBook Pro M2 (14-inch)',
          brand: 'Apple',
          service: 'Battery Replacement (OEM 70Wh)',
          status: 'Delivered & Verified ✓',
          isLive: false,
          date: '28 Oct 2026',
          price: '₹5,499 (Paid via UPI)',
          warrantyRemaining: '142 Days Warranty Left',
          onTap: () => context.push('/track-repair/QF-77210'),
        ),
        const SizedBox(height: 12),
        _OrderCard(
          orderId: 'QF-65104',
          device: 'OnePlus 12',
          brand: 'OnePlus',
          service: 'Type-C Sub-Board Charging Port',
          status: 'Delivered & Verified ✓',
          isLive: false,
          date: '14 Sep 2026',
          price: '₹1,299 (Paid via Cash)',
          warrantyRemaining: '98 Days Warranty Left',
          onTap: () => context.push('/track-repair/QF-65104'),
        ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String orderId;
  final String device;
  final String brand;
  final String service;
  final String status;
  final bool isLive;
  final String date;
  final String price;
  final String? eta;
  final String? warrantyRemaining;
  final VoidCallback onTap;

  const _OrderCard({
    required this.orderId,
    required this.device,
    required this.brand,
    required this.service,
    required this.status,
    required this.isLive,
    required this.date,
    required this.price,
    this.eta,
    this.warrantyRemaining,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLive ? const Color(0xFF003A26).withValues(alpha: 0.3) : const Color(0xFFD1D9D6),
          width: isLive ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isLive ? 0.06 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header Strip
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF003A26).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '#$orderId',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF003A26),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      date,
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: Color(0xFF5F6F67)),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isLive
                        ? const Color(0xFF10B981).withValues(alpha: 0.12)
                        : const Color(0xFF003A26).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLive) ...[
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 5),
                      ],
                      Text(
                        status,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isLive ? const Color(0xFF10B981) : const Color(0xFF003A26),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE8ECEA)),

          // Device Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6F4),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.devices_other_rounded, color: Color(0xFF003A26), size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF003A26),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        service,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Color(0xFF5F6F67),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        price,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF003A26),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (warrantyRemaining != null) ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEDB000).withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_rounded, color: Color(0xFF003A26), size: 16),
                  const SizedBox(width: 8),
                  Text(
                    warrantyRemaining!,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF003A26),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Footer Action
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isLive ? const Color(0xFF003A26).withValues(alpha: 0.04) : const Color(0xFFF3F6F4),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (eta != null)
                  Text(
                    eta!,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF003A26),
                    ),
                  )
                else
                  const Text(
                    'Invoice & Certificate Available',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 11.5, color: Color(0xFF5F6F67)),
                  ),
                QFPressable(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: isLive ? const Color(0xFFEDB000) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: isLive ? null : Border.all(color: const Color(0xFFD1D9D6)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isLive ? 'Track Live' : 'View Details',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF003A26),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFF003A26)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTab extends StatelessWidget {
  final String title;
  final String subtitle;
  const _EmptyTab({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFE8ECEA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.inbox_rounded, size: 36, color: Color(0xFF5F6F67)),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF003A26),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: Color(0xFF5F6F67)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
