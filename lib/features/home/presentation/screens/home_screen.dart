import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/qf_pressable.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  final PageController _bannerController = PageController();
  int _currentBanner = 0;
  Timer? _bannerTimer;

  // Radar animation controller for live ticker
  late final AnimationController _radarController;

  // Ambient shimmer / glowing accent motion controller for Hero card
  late final AnimationController _heroShimmerController;

  // Gentle float motion controller for hero 3D icon
  late final AnimationController _floatController;

  // Live activity ticker items and timer
  int _currentTickerIndex = 0;
  Timer? _tickerTimer;

  // Search placeholder cycling timer
  int _searchPlaceholderIndex = 0;
  Timer? _searchTimer;
  final List<String> _searchPlaceholders = [
    'Search iPhone 16 Pro, screen replacement...',
    'Search MacBook M2, battery overhaul...',
    'Search Samsung S24 Ultra, camera sensor...',
    'Search OnePlus 12, fast-charging port...',
    'Search Apple Watch Series 9, touch glass...',
  ];

  // Selected Device Category Filter (Circle Store-style top navigation rail)
  int _selectedDeviceCategoryIndex = 0;
  final List<Map<String, dynamic>> _deviceCategories = [
    {'name': 'Smartphones', 'icon': Icons.phone_iphone_rounded, 'count': '420+ Models'},
    {'name': 'Laptops', 'icon': Icons.laptop_mac_rounded, 'count': '180+ Models'},
    {'name': 'Tablets', 'icon': Icons.tablet_mac_rounded, 'count': '65+ Models'},
    {'name': 'Smartwatches', 'icon': Icons.watch_rounded, 'count': '50+ Models'},
    {'name': 'Audio & Pods', 'icon': Icons.headphones_rounded, 'count': '40+ Models'},
    {'name': 'Consoles', 'icon': Icons.sports_esports_rounded, 'count': '25+ Models'},
  ];

  // Location state
  String _selectedLocation = 'Indiranagar, Bangalore';

  final List<Map<String, dynamic>> _tickerActivities = [
    {
      'tag': 'ACTIVE NOW',
      'text': '14 Technicians ready • 30-min doorstep slot available',
    },
    {
      'tag': 'JUST BOOKED',
      'text': 'Rohan P. booked iPhone 15 Screen Replacement 2m ago',
    },
    {
      'tag': 'EN ROUTE',
      'text': 'Expert technician assigned for Samsung S24 Ultra in Indiranagar',
    },
    {
      'tag': 'VERIFIED',
      'text': 'Priya M. verified OnePlus 12 Battery Swap • 5.0 ★ (4m ago)',
    },
    {
      'tag': 'GUARANTEE',
      'text': '45,200+ Repairs completed with 6-Month QuickFix Warranty',
    },
  ];

  final List<Map<String, dynamic>> _banners = [
    {
      'tag': 'LIMITED TIME',
      'title': 'Instant Display\nReplacement',
      'subtitle': 'Original OEM Grade Screens • 6 Mo. Warranty',
      'gradient': const [Color(0xFF003A26), Color(0xFF075439)],
      'accent': const Color(0xFFEDB000),
      'emoji': '⚡',
      'discount': '50% OFF',
    },
    {
      'tag': 'FREE PICKUP',
      'title': 'Doorstep Express\nPickup & Delivery',
      'subtitle': 'Zero diagnostic fee if not satisfied',
      'gradient': const [Color(0xFF132E23), Color(0xFF1F4837)],
      'accent': const Color(0xFFEDB000),
      'emoji': '🚚',
      'discount': '₹0 FEE',
    },
    {
      'tag': 'BATTERY BOOST',
      'title': 'High-Health\nBattery Swap',
      'subtitle': 'Installed in 60 mins by certified technicians',
      'gradient': const [Color(0xFF00291B), Color(0xFF00442D)],
      'accent': const Color(0xFFEDB000),
      'emoji': '🔋',
      'discount': 'FROM ₹999',
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Screen',
      'emoji': '📱',
      'sub': 'Same-day',
      'tag': 'Popular',
      'tagColor': const Color(0xFFEDB000),
      'tagTextColor': const Color(0xFF003A26),
    },
    {
      'name': 'Battery',
      'emoji': '🔋',
      'sub': '6 Mo. War.',
      'tag': 'Top Fix',
      'tagColor': const Color(0xFF10B981),
      'tagTextColor': Colors.white,
    },
    {
      'name': 'Charging',
      'emoji': '🔌',
      'sub': '45 mins',
      'tag': null,
    },
    {
      'name': 'Camera',
      'emoji': '📷',
      'sub': 'Inspection',
      'tag': null,
    },
    {
      'name': 'Speaker',
      'emoji': '🔊',
      'sub': 'Express fix',
      'tag': null,
    },
    {
      'name': 'Water',
      'emoji': '💧',
      'sub': 'Deep clean',
      'tag': 'Urgent',
      'tagColor': const Color(0xFFEF4444),
      'tagTextColor': Colors.white,
    },
    {
      'name': 'Housing',
      'emoji': '🪟',
      'sub': 'OEM Finish',
      'tag': null,
    },
    {
      'name': 'Board',
      'emoji': '⚙️',
      'sub': 'L3 tech',
      'tag': 'Lab',
      'tagColor': const Color(0xFF6366F1),
      'tagTextColor': Colors.white,
    },
  ];

  // Circle Store-style curated popular listing repair cards
  final List<Map<String, dynamic>> _popularRepairs = [
    {
      'device': 'iPhone 15 Pro',
      'service': 'OLED Screen Replacement',
      'part': 'OEM Grade Super Retina XDR',
      'price': '₹4,999',
      'mrp': '₹8,999',
      'discount': '44% OFF',
      'rating': '4.9',
      'reviews': '840',
      'turnaround': '2 Hours',
      'badge': 'OEM Genuine',
      'icon': '📱',
    },
    {
      'device': 'MacBook Pro M2',
      'service': '70Wh Battery Overhaul',
      'part': 'Zero Cycle OEM Lithium Cell',
      'price': '₹5,499',
      'mrp': '₹9,999',
      'discount': '45% OFF',
      'rating': '4.95',
      'reviews': '520',
      'turnaround': '4 Hours',
      'badge': '180D Guarantee',
      'icon': '💻',
    },
    {
      'device': 'OnePlus 12',
      'service': 'Type-C Sub-Board Charging',
      'part': '100W SuperVOOC PCB Assembly',
      'price': '₹1,299',
      'mrp': '₹2,499',
      'discount': '48% OFF',
      'rating': '4.85',
      'reviews': '390',
      'turnaround': '45 Mins',
      'badge': 'Fast Fix',
      'icon': '⚡',
    },
    {
      'device': 'Samsung S24 Ultra',
      'service': 'Triple Lens & Sensor Calib',
      'part': '200MP ISOCELL Sensor Clean',
      'price': '₹2,199',
      'mrp': '₹3,999',
      'discount': '45% OFF',
      'rating': '4.9',
      'reviews': '280',
      'turnaround': '2 Hours',
      'badge': 'Cleanroom',
      'icon': '📷',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Radar controller for live active ticker
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    // Ambient shimmer sweep & gradient glow for hero card
    _heroShimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();

    // Floating bobbing motion for hero 3D icon
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _startAutoScroll();
    _startTickerCycle();
    _startSearchCycle();
  }

  void _startAutoScroll() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && _bannerController.hasClients) {
        final next = (_currentBanner + 1) % _banners.length;
        _bannerController.animateToPage(
          next,
          duration: const Duration(milliseconds: 550),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  void _startTickerCycle() {
    _tickerTimer?.cancel();
    _tickerTimer = Timer.periodic(const Duration(milliseconds: 3500), (timer) {
      if (mounted) {
        setState(() {
          _currentTickerIndex = (_currentTickerIndex + 1) % _tickerActivities.length;
        });
      }
    });
  }

  void _startSearchCycle() {
    _searchTimer?.cancel();
    _searchTimer = Timer.periodic(const Duration(milliseconds: 4000), (timer) {
      if (mounted) {
        setState(() {
          _searchPlaceholderIndex = (_searchPlaceholderIndex + 1) % _searchPlaceholders.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _tickerTimer?.cancel();
    _searchTimer?.cancel();
    _bannerController.dispose();
    _radarController.dispose();
    _heroShimmerController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _showLocationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D9D6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF003A26).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.location_on_rounded, color: Color(0xFF003A26), size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Choose Your Pickup Location',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF003A26),
                          ),
                        ),
                        Text(
                          'Doorstep pickup available in 30 mins in Bengaluru',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Color(0xFF5F6F67)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Popular Hubs
              const Text(
                'ACTIVE SERVICE HUBS (30-MIN SLOTS)',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: Color(0xFF5F6F67),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Indiranagar',
                  'Koramangala',
                  'HSR Layout',
                  'Whitefield',
                  'Jayanagar',
                  'Electronic City',
                  'MG Road',
                  'Hebbal',
                ].map((hub) {
                  final isSelected = _selectedLocation.startsWith(hub);
                  return QFPressable(
                    onTap: () {
                      setState(() => _selectedLocation = '$hub, Bangalore');
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Pickup location set to $hub, Bangalore')),
                      );
                    },
                    pressedScale: 0.95,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF003A26) : const Color(0xFFF3F6F4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF003A26) : const Color(0xFFD1D9D6),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 14,
                            color: isSelected ? const Color(0xFFEDB000) : Colors.transparent,
                          ),
                          if (isSelected) const SizedBox(width: 4),
                          Text(
                            hub,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.5,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected ? Colors.white : const Color(0xFF003A26),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // Pincode verify container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDB000).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFEDB000).withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.bolt_rounded, color: Color(0xFF003A26), size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Doorstep pickup and return delivery is 100% free across all Bengaluru pincodes.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF003A26),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F4),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildPremiumHeader(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLiveStatusTicker(),
                _buildDeviceNavigationRail(), // Circle Store-style category rail
                _buildDynamicBanners(),
                _buildHeroBookingCard(),
                _buildQuickFixPills(),
                _buildCategoriesGrid(),
                _buildPopularRepairsShowcase(), // Circle Store-style listing cards
                _buildMobileAppTrackerShowcase(), // QuickFix Customer App Feature
                _buildLiveRepairFeed(),
                _buildTrustShowcase(),
                _buildStepByStepInteractive(),
                const SizedBox(height: 110),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return SliverAppBar(
      expandedHeight: 125,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: const Color(0xFF003A26),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEDB000).withValues(alpha: 0.08),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Row(
                  children: [
                    QFPressable(
                      onTap: () => context.push('/home'),
                      pressedScale: 0.92,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEDB000), Color(0xFFF6C844)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFEDB000).withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'QF',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF003A26),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'QuickFix',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDB000).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFFEDB000).withValues(alpha: 0.5)),
                                ),
                                child: const Text(
                                  'PRO',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFEDB000),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          QFPressable(
                            onTap: _showLocationModal,
                            pressedScale: 0.98,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.location_on_rounded, size: 12, color: Color(0xFFEDB000)),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    _selectedLocation,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withValues(alpha: 0.8),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: Colors.white70),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    QFPressable(
                      onTap: () => context.push('/support'),
                      pressedScale: 0.9,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(Icons.headset_mic_rounded, color: Colors.white, size: 20),
                            Positioned(
                              top: 9,
                              right: 9,
                              child: Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDB000),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF003A26), width: 1.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          color: const Color(0xFF003A26),
          child: QFPressable(
            onTap: () => context.push('/select-brand'),
            pressedScale: 0.98,
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  const Icon(Icons.search_rounded, color: Color(0xFF003A26), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: Text(
                        _searchPlaceholders[_searchPlaceholderIndex],
                        key: ValueKey<int>(_searchPlaceholderIndex),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.5,
                          color: Color(0xFF5F6F67),
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8ECEA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Explore',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF003A26),
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(Icons.arrow_forward_ios_rounded, size: 9, color: Color(0xFF003A26)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Pulsing radar indicator with double expanding ripple waves
  Widget _buildRadarIndicator() {
    return AnimatedBuilder(
      animation: _radarController,
      builder: (context, child) {
        final progress1 = _radarController.value;
        final progress2 = (progress1 + 0.5) % 1.0;

        return SizedBox(
          width: 22,
          height: 22,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ripple 1
              Transform.scale(
                scale: 1.0 + (1.4 * progress1),
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: (0.7 * (1.0 - progress1)).clamp(0.0, 0.7)),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              // Outer ripple 2 (phase-shifted)
              Transform.scale(
                scale: 1.0 + (1.4 * progress2),
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: (0.7 * (1.0 - progress2)).clamp(0.0, 0.7)),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              // Center solid radar beacon dot
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF10B981),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.6),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Live activity ticker with smooth animated transitions and continuous radar
  Widget _buildLiveStatusTicker() {
    final currentItem = _tickerActivities[_currentTickerIndex];

    return QFPressable(
      onTap: () => context.push('/select-brand'),
      pressedScale: 0.98,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF003A26).withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF003A26).withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildRadarIndicator(),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
              decoration: BoxDecoration(
                color: const Color(0xFF003A26).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                currentItem['tag'] as String,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF003A26),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  final inAnimation = Tween<Offset>(
                    begin: const Offset(0.0, 0.5),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
                  return SlideTransition(
                    position: inAnimation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Text(
                  currentItem['text'] as String,
                  key: ValueKey<int>(_currentTickerIndex),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF003A26),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: Color(0xFF5F6F67)),
          ],
        ),
      ),
    );
  }

  /// Circle Store-style top device category navigation rail
  Widget _buildDeviceNavigationRail() {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(top: 10),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _deviceCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = _deviceCategories[i];
          final isSelected = _selectedDeviceCategoryIndex == i;

          return QFPressable(
            onTap: () {
              setState(() => _selectedDeviceCategoryIndex = i);
              context.push('/select-brand');
            },
            pressedScale: 0.94,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF003A26) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? const Color(0xFF003A26) : const Color(0xFFD1D9D6),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected ? const Color(0xFF003A26).withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    cat['icon'] as IconData,
                    size: 16,
                    color: isSelected ? const Color(0xFFEDB000) : const Color(0xFF003A26),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat['name'] as String,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF003A26),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDynamicBanners() {
    return Column(
      children: [
        SizedBox(
          height: 195,
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (i) => setState(() => _currentBanner = i),
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final b = _banners[index];
              return Container(
                margin: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: b['gradient'] as List<Color>,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: (b['gradient'][0] as Color).withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 14,
                      bottom: 8,
                      child: Text(b['emoji'] as String, style: const TextStyle(fontSize: 70)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDB000),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  b['tag'] as String,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF003A26),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  b['discount'] as String,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFEDB000),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            b['title'] as String,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            b['subtitle'] as String,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(height: 10),
                          QFPressable(
                            onTap: () => context.push('/select-brand'),
                            pressedScale: 0.94,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Claim Offer',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF003A26),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF003A26)),
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
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentBanner == i ? 24 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: _currentBanner == i ? const Color(0xFF003A26) : const Color(0xFFD1D9D6),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Modern Hero booking card with continuous ambient shimmer & glowing accent motion
  Widget _buildHeroBookingCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: QFPressable(
        onTap: () => context.push('/select-brand'),
        pressedScale: 0.98,
        child: AnimatedBuilder(
          animation: Listenable.merge([_heroShimmerController, _floatController]),
          builder: (context, child) {
            final shimmerVal = _heroShimmerController.value;
            final floatVal = math.sin(_floatController.value * math.pi);
            final pulseFactor = (math.sin(shimmerVal * 2 * math.pi) + 1.0) / 2.0;

            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: const [
                    Color(0xFFEDB000),
                    Color(0xFFF9C32B),
                    Color(0xFFEAA600),
                  ],
                  stops: [0.0, 0.5 + (0.2 * pulseFactor), 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Color.lerp(
                    const Color(0xFFEDB000),
                    const Color(0xFFFFF9E0),
                    pulseFactor,
                  )!.withValues(alpha: 0.75 + (0.25 * pulseFactor)),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEDB000).withValues(alpha: 0.28 + (0.16 * pulseFactor)),
                    blurRadius: 20 + (8 * pulseFactor),
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Continuous ambient shimmer light beam sweep
                    Positioned.fill(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final sweepProgress = (shimmerVal * 3.0) - 1.0;
                          final sweepOffset = constraints.maxWidth * sweepProgress;

                          return Transform.translate(
                            offset: Offset(sweepOffset, 0),
                            child: Transform.rotate(
                              angle: 0.35,
                              child: Container(
                                width: 75,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withValues(alpha: 0.0),
                                      Colors.white.withValues(alpha: 0.28),
                                      Colors.white.withValues(alpha: 0.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Background watermark graphic
                    const Positioned(
                      right: -10,
                      bottom: -15,
                      child: Opacity(
                        opacity: 0.15,
                        child: Text('⚙️', style: TextStyle(fontSize: 130)),
                      ),
                    ),

                    // Main card content
                    Padding(
                      padding: const EdgeInsets.all(22),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF003A26),
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.15),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 5,
                                        height: 5,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF10B981),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'DOORSTEP TECH',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 9,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Book a Repair',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF003A26),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Pick your device model & choose issue in 60s',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF003A26),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                QFPressable(
                                  onTap: () => context.push('/select-brand'),
                                  pressedScale: 0.94,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF003A26), Color(0xFF005035)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF003A26).withValues(alpha: 0.4),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Get Started',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Transform.translate(
                                          offset: Offset(2.0 * floatVal, 0),
                                          child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Transform.translate(
                            offset: Offset(0, -6.0 * floatVal),
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.35),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF003A26).withValues(alpha: 0.1),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text('🔧', style: TextStyle(fontSize: 32)),
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
          },
        ),
      ),
    );
  }

  Widget _buildQuickFixPills() {
    final pills = [
      {'icon': Icons.bolt_rounded, 'label': 'Express 2-Hr Fix'},
      {'icon': Icons.shield_outlined, 'label': '6 Mo. Warranty'},
      {'icon': Icons.home_repair_service_outlined, 'label': 'Free Pickup'},
      {'icon': Icons.price_check_rounded, 'label': 'Zero Advance'},
    ];

    return Container(
      height: 40,
      margin: const EdgeInsets.only(top: 18),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: pills.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final p = pills[i];
          return QFPressable(
            onTap: () => context.push('/select-brand'),
            pressedScale: 0.95,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD1D9D6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(p['icon'] as IconData, size: 14, color: const Color(0xFF003A26)),
                  const SizedBox(width: 6),
                  Text(
                    p['label'] as String,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF003A26),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Upgraded 8 category cards with smooth tap/hover feedback, elevated modern shadows,
  /// and guaranteed zero RenderFlex overflows (safe childAspectRatio: 0.76).
  Widget _buildCategoriesGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Explore Repairs',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF003A26),
                ),
              ),
              QFPressable(
                onTap: () => context.push('/select-brand'),
                pressedScale: 0.92,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFEDB000),
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFFEDB000)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 12,
              childAspectRatio: 0.76,
            ),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              return QFPressable(
                onTap: () => context.push('/select-brand'),
                pressedScale: 0.93,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2EBE7), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF003A26).withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      if (cat['tag'] != null)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: (cat['tagColor'] as Color?) ?? const Color(0xFFEDB000),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Text(
                              cat['tag'] as String,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                                color: (cat['tagTextColor'] as Color?) ?? const Color(0xFF003A26),
                              ),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFF1F5F3), Color(0xFFE5ECE8)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(cat['emoji'] as String, style: const TextStyle(fontSize: 18)),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              cat['name'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF003A26),
                                height: 1.1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              cat['sub'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF5F6F67),
                                height: 1.1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
        ],
      ),
    );
  }

  /// Circle Store-style curated popular repair listing cards
  Widget _buildPopularRepairsShowcase() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Popular Verified Repairs',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF003A26),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Top booked fixes with genuine OEM parts in Bengaluru',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 11.5, color: Color(0xFF5F6F67)),
                  ),
                ],
              ),
              QFPressable(
                onTap: () => context.push('/select-brand'),
                pressedScale: 0.92,
                child: const Text(
                  'Explore All',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFEDB000),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Horizontal scrolling cards replicating Circle Store product cards
          SizedBox(
            height: 250,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _popularRepairs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, i) {
                final item = _popularRepairs[i];
                return Container(
                  width: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFD1D9D6)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card Top Header
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF003A26).withValues(alpha: 0.04),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF003A26),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item['badge'] as String,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFEDB000),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Color(0xFFEDB000), size: 14),
                                const SizedBox(width: 2),
                                Text(
                                  '${item['rating']} (${item['reviews']})',
                                  style: const TextStyle(fontFamily: 'Inter', fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF003A26)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Device Image / Icon Area
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F6F4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(item['icon'] as String, style: const TextStyle(fontSize: 22)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['device'] as String,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF003A26),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    item['service'] as String,
                                    style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: Color(0xFF5F6F67)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          item['part'] as String,
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 10.5, fontStyle: FontStyle.italic, color: Color(0xFF5F6F67)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      const Divider(height: 1, color: Color(0xFFE8ECEA)),
                      // Pricing & Action Row
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      item['price'] as String,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF003A26),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item['mrp'] as String,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 10.5,
                                        color: Color(0xFF5F6F67),
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  item['discount'] as String,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF10B981),
                                  ),
                                ),
                              ],
                            ),
                            QFPressable(
                              onTap: () => context.push('/select-brand'),
                              pressedScale: 0.94,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF003A26),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Book Fix',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Showcase the QuickFix Customer Mobile App & 12-Stage Visual Live Tracker
  Widget _buildMobileAppTrackerShowcase() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 26, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF003A26), Color(0xFF1F2D27)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003A26).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDB000),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'LIVE APP TRACKER',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF003A26),
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.shield_outlined, color: Color(0xFFEDB000), size: 14),
                  SizedBox(width: 4),
                  Text(
                    '₹50,000 Transit Insurance',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFFEDB000)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Track Every Second of Your Repair',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Follow all 12 stages live—from doorstep collection to cleanroom diagnostics, OEM installation, and return delivery.',
            style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.white70, height: 1.35),
          ),
          const SizedBox(height: 16),
          // Interactive mock tracker pill
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                AnimatedBuilder(
                  animation: _radarController,
                  builder: (_, __) {
                    return Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withValues(alpha: 0.8),
                            blurRadius: 6 * _radarController.value,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stage 3 of 12 • In Transit to Main Lab',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      Text(
                        'Assigned executive: Ramesh Verma (4.9 ★) in Indiranagar',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 10.5, color: Colors.white60),
                      ),
                    ],
                  ),
                ),
                QFPressable(
                  onTap: () => context.push('/track-repair/QF-89421'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDB000),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'View Live',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF003A26),
                      ),
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

  Widget _buildLiveRepairFeed() {
    final recent = [
      {'device': 'iPhone 15 Pro', 'issue': 'Screen Replaced', 'time': '6m ago', 'locality': 'Koramangala'},
      {'device': 'Samsung S24 Ultra', 'issue': 'Battery Overhaul', 'time': '14m ago', 'locality': 'HSR Layout'},
      {'device': 'OnePlus 12', 'issue': 'Charging Port', 'time': '28m ago', 'locality': 'Indiranagar'},
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 26, 20, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF003A26),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003A26).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: _radarController,
                builder: (context, child) {
                  return Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFEDB000),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEDB000).withValues(alpha: 0.4 + (0.4 * _radarController.value)),
                          blurRadius: 6 + (4 * _radarController.value),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              const Text(
                'LIVE REPAIR ACTIVITY',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFEDB000),
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              const Text(
                'Updated Just Now',
                style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...recent.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: QFPressable(
              onTap: () => context.push('/select-brand'),
              pressedScale: 0.98,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(child: Text('📱', style: TextStyle(fontSize: 16))),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r['device']!,
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                          Text(
                            '${r['issue']} • ${r['locality']}',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: Colors.white.withValues(alpha: 0.7)),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      r['time']!,
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFEDB000)),
                    ),
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTrustShowcase() {
    final metrics = [
      {'val': '98.8%', 'label': 'Success Rate'},
      {'val': '45k+', 'label': 'Devices Saved'},
      {'val': '6 Mo.', 'label': 'Real Warranty'},
      {'val': '4.9★', 'label': 'Play Rating'},
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD1D9D6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003A26).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'The QuickFix Guarantee',
            style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF003A26)),
          ),
          const SizedBox(height: 4),
          const Text(
            'Transparent quotes • Zero hidden diagnostic fees',
            style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Color(0xFF5F6F67)),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: metrics.map((m) => Expanded(
              child: Column(
                children: [
                  Text(
                    m['val']!,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF003A26),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    m['label']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5F6F67),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepByStepInteractive() {
    final steps = [
      {'n': '1', 't': 'Pick Device & Problem', 'd': 'Explore models & instant estimate'},
      {'n': '2', 't': 'Schedule Doorstep Pickup', 'd': 'Executive collects device at your hour'},
      {'n': '3', 't': 'Real-Time 12-Stage Fix', 'd': 'Track diagnosis, part fitting & tests'},
      {'n': '4', 't': 'Delivered & Verified', 'd': 'Inspect first, pay afterwards'},
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD1D9D6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003A26).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'How Doorstep Repair Works',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF003A26)),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF003A26).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '4 STEPS',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF003A26),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...steps.asMap().entries.map((e) {
            final idx = e.key;
            final s = e.value;
            final isLast = idx == steps.length - 1;
            return QFPressable(
              onTap: () => context.push('/select-brand'),
              pressedScale: 0.98,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFF003A26),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF003A26).withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              s['n']!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFEDB000),
                              ),
                            ),
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 28,
                            color: const Color(0xFFE8ECEA),
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: isLast ? 0 : 16, top: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s['t']!,
                              style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF003A26)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              s['d']!,
                              style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: Color(0xFF5F6F67)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 14),
          QFPressable(
            onTap: () => context.push('/select-brand'),
            pressedScale: 0.96,
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF003A26), Color(0xFF005A3C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF003A26).withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_month_rounded, color: Color(0xFFEDB000), size: 18),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Book Doorstep Repair',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
