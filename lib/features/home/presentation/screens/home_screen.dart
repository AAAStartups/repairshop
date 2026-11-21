import 'dart:async';
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
  // Hero Carousel Page Controller and Timer
  final PageController _heroController = PageController();
  int _currentHeroPage = 0;
  Timer? _heroTimer;
  bool _isUserInteracting = false;

  // Selected Category Index for the horizontal category bar
  int _selectedCategoryIndex = 0;
  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.grid_view_rounded},
    {'name': 'Smartphones', 'icon': Icons.phone_iphone_rounded},
    {'name': 'Laptops', 'icon': Icons.laptop_mac_rounded},
    {'name': 'Tablets', 'icon': Icons.tablet_mac_rounded},
    {'name': 'Accessories', 'icon': Icons.headphones_rounded},
  ];

  // Location State
  String _selectedLocation = 'Indiranagar, Bangalore';

  // Search Placeholder cycling
  int _searchPlaceholderIndex = 0;
  Timer? _searchTimer;
  final List<String> _searchPlaceholders = [
    "What's on your mind? Fix it!",
    "Search iPhone 16 Pro display...",
    "Search MacBook M2 battery swap...",
    "Search Samsung S24 charging port...",
    "Search Apple Watch touch glass...",
  ];

  // 3 Hero Carousel slides
  final List<Map<String, dynamic>> _heroSlides = [
    {
      'title': 'Trusted Repairs.\nZero Hassle.',
      'step1': 'Free Doorstep',
      'step2': 'OEM Grade',
      'step3': '6-Mo Warranty',
      'cta': 'Book Now',
      'bgGradient': [Color(0xFF022B1B), Color(0xFF003A26)],
      'icon': Icons.build_circle_rounded,
    },
    {
      'title': 'Instant Display\nReplacement.',
      'step1': '60-Min Fix',
      'step2': 'Tested Glass',
      'step3': 'Free Pickup',
      'cta': 'Claim Offer',
      'bgGradient': [Color(0xFF09281C), Color(0xFF05452D)],
      'icon': Icons.screenshot_monitor_rounded,
    },
    {
      'title': 'High-Health\nBattery Swap.',
      'step1': '100% Health',
      'step2': 'Genuine Cells',
      'step3': 'Express Fit',
      'cta': 'Get Battery',
      'bgGradient': [Color(0xFF0A2218), Color(0xFF0E4A32)],
      'icon': Icons.battery_charging_full_rounded,
    },
  ];

  // Popular Services Cards (Crazy Finds style from Circle reference)
  final List<Map<String, dynamic>> _popularServices = [
    {
      'title': 'Screen Replacement',
      'category': 'Smartphones',
      'badge': 'OEM Grade',
      'price': '₹1,499',
      'mrp': '₹2,999',
      'discount': '50% OFF',
      'icon': Icons.phone_iphone_rounded,
      'gradient': [Color(0xFF003A26), Color(0xFF075439)],
    },
    {
      'title': 'Battery Replacement',
      'category': 'Smartphones & Laptops',
      'badge': 'Original Part',
      'price': '₹999',
      'mrp': '₹1,999',
      'discount': '50% OFF',
      'icon': Icons.battery_charging_full_rounded,
      'gradient': [Color(0xFF1B3B2B), Color(0xFF0A4E31)],
    },
    {
      'title': 'Water Damage Clean',
      'category': 'All Devices',
      'badge': 'Express 60m',
      'price': '₹799',
      'mrp': '₹1,499',
      'discount': '46% OFF',
      'icon': Icons.water_drop_rounded,
      'gradient': [Color(0xFF083120), Color(0xFF0F5A39)],
    },
    {
      'title': 'Charging Port Fix',
      'category': 'Tablets & Phones',
      'badge': 'OEM Grade',
      'price': '₹699',
      'mrp': '₹1,299',
      'discount': '46% OFF',
      'icon': Icons.electrical_services_rounded,
      'gradient': [Color(0xFF153424), Color(0xFF04482B)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _startHeroAutoSlide();
    _startSearchPlaceholderCycle();
  }

  void _startHeroAutoSlide() {
    _heroTimer?.cancel();
    _heroTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_isUserInteracting && _heroController.hasClients) {
        final nextPage = (_currentHeroPage + 1) % _heroSlides.length;
        _heroController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _startSearchPlaceholderCycle() {
    _searchTimer?.cancel();
    _searchTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _searchPlaceholderIndex = (_searchPlaceholderIndex + 1) % _searchPlaceholders.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _heroTimer?.cancel();
    _searchTimer?.cancel();
    _heroController.dispose();
    super.dispose();
  }

  void _showLocationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final locations = [
          {'area': 'Indiranagar, Bangalore', 'sub': '14 Technicians active • 30-min doorstep', 'current': true},
          {'area': 'Koramangala, Bangalore', 'sub': '18 Technicians active • 25-min doorstep', 'current': false},
          {'area': 'HSR Layout, Bangalore', 'sub': '12 Technicians active • 30-min doorstep', 'current': false},
          {'area': 'Whitefield, Bangalore', 'sub': '9 Technicians active • 45-min doorstep', 'current': false},
          {'area': 'Jayanagar, Bangalore', 'sub': '15 Technicians active • 35-min doorstep', 'current': false},
          {'area': 'Marathahalli, Bangalore', 'sub': '11 Technicians active • 30-min doorstep', 'current': false},
        ];

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
                    color: const Color(0xFFE8ECEA),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF003A26).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.location_on_rounded, color: Color(0xFF003A26), size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Service Location',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1F2D27)),
                      ),
                      Text(
                        'Fast doorstep technicians in Bengaluru',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Color(0xFF5F6F67)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...locations.map((loc) {
                final isCur = loc['area'] == _selectedLocation;
                return QFPressable(
                  onTap: () {
                    setState(() {
                      _selectedLocation = loc['area'] as String;
                    });
                    Navigator.pop(ctx);
                  },
                  pressedScale: 0.98,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isCur ? const Color(0xFF003A26).withValues(alpha: 0.06) : const Color(0xFFF7F9F8),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isCur ? const Color(0xFF003A26) : const Color(0xFFE8ECEA),
                        width: isCur ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isCur ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                          color: isCur ? const Color(0xFF003A26) : const Color(0xFF5F6F67),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc['area'] as String,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: isCur ? FontWeight.w800 : FontWeight.w600,
                                  color: const Color(0xFF1F2D27),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                loc['sub'] as String,
                                style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: Color(0xFF5F6F67)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main Scrollable Screen
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 84), // Space so bottom cards scroll past sticky location banner
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCircleHeaderSection(),
                  _buildPopularServicesSection(),
                  _buildTrustValueProposition(),
                ],
              ),
            ),
          ),

          // Sticky Location Banner (Floating above bottom navigation)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildStickyLocationBanner(),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 1. CIRCLE HEADER + CATEGORIES + HERO
  // ==========================================
  Widget _buildCircleHeaderSection() {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF001B11),
            Color(0xFF003A26),
            Color(0xFF002A1C),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: topPadding + 8),

          // --- Top Row: Logo + PRO Badge (Left) & Sign In Pill (Right) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // QuickFix Logo & PRO badge
                Row(
                  children: [
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'quick',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.8,
                            ),
                          ),
                          TextSpan(
                            text: 'fix',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFEDB000),
                              letterSpacing: -0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDB000).withValues(alpha: 0.15),
                        border: Border.all(color: const Color(0xFFEDB000), width: 1.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'PRO',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFEDB000),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),

                // Sign In Outline Pill Button (Exact match to Circle reference)
                QFPressable(
                  onTap: () => context.push('/auth/login'),
                  pressedScale: 0.95,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.login_rounded, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Sign in',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // --- Location Selector Row (Below Logo) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: QFPressable(
              onTap: _showLocationModal,
              pressedScale: 0.98,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on_rounded, size: 14, color: Color(0xFFEDB000)),
                  const SizedBox(width: 4),
                  Text(
                    _selectedLocation,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.arrow_drop_down_rounded, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // --- Large White Rounded Search Bar (Exact Circle Stadium Pill) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: QFPressable(
              onTap: () => context.push('/select-brand'),
              pressedScale: 0.99,
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: Color(0xFF003A26), size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.3),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
                        child: Text(
                          _searchPlaceholders[_searchPlaceholderIndex],
                          key: ValueKey<int>(_searchPlaceholderIndex),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // --- 2. CATEGORY NAVIGATION (Icon Above Label, Animated Underline) ---
          _buildCategoryNavigationRail(),

          const SizedBox(height: 16),

          // --- 3. HERO PROMOTIONAL CAROUSEL ---
          _buildHeroCarousel(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ==========================================
  // 2. CATEGORY RAIL (Minimalist, Animated Underline)
  // ==========================================
  Widget _buildCategoryNavigationRail() {
    return SizedBox(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = index == _selectedCategoryIndex;

          return QFPressable(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
            pressedScale: 0.94,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    cat['icon'] as IconData,
                    color: isSelected ? Colors.white : Colors.white60,
                    size: 26,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat['name'] as String,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.white60,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Animated White Underline indicator (matching Circle screenshot)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    height: 3,
                    width: isSelected ? 28 : 0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
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

  // ==========================================
  // 3. HERO CAROUSEL (3 Pages, Auto-slide, Gesture Pause)
  // ==========================================
  Widget _buildHeroCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 195,
          child: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              // Pause auto-sliding while user is actively swiping
              _isUserInteracting = notification.direction.name != 'idle';
              return false;
            },
            child: PageView.builder(
              controller: _heroController,
              itemCount: _heroSlides.length,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentHeroPage = index;
                });
              },
              itemBuilder: (context, index) {
                final slide = _heroSlides[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: slide['bgGradient'] as List<Color>,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Soft ambient glowing background sphere
                        Positioned(
                          right: -30,
                          top: -30,
                          child: Container(
                            width: 170,
                            height: 170,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFEDB000).withValues(alpha: 0.12),
                            ),
                          ),
                        ),

                        // Content Row: Text & Process on Left, Illustration on Right
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
                          child: Row(
                            children: [
                              // Left Text Column
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Headline (exact Circle typography)
                                    Text(
                                      slide['title'] as String,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        height: 1.15,
                                        letterSpacing: -0.4,
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    // 3-Stage Process Flow (Picked Up -> Verified -> Delivered)
                                    Row(
                                      children: [
                                        _buildMiniFlowStep(Icons.person_pin_circle_rounded, slide['step1'] as String),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 4),
                                          child: Text('➔', style: TextStyle(color: Colors.white38, fontSize: 9)),
                                        ),
                                        _buildMiniFlowStep(Icons.verified_rounded, slide['step2'] as String),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 4),
                                          child: Text('➔', style: TextStyle(color: Colors.white38, fontSize: 9)),
                                        ),
                                        _buildMiniFlowStep(Icons.local_shipping_rounded, slide['step3'] as String),
                                      ],
                                    ),

                                    const SizedBox(height: 12),

                                    // CTA Pill Button
                                    QFPressable(
                                      onTap: () => context.push('/select-brand'),
                                      pressedScale: 0.95,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEDB000),
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFFEDB000).withValues(alpha: 0.4),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              slide['cta'] as String,
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w900,
                                                color: Color(0xFF003A26),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(Icons.arrow_forward_rounded, size: 13, color: Color(0xFF003A26)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Right Graphic Illustration
                              Expanded(
                                flex: 4,
                                child: Center(
                                  child: Container(
                                    width: 84,
                                    height: 84,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          const Color(0xFFEDB000).withValues(alpha: 0.25),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                    child: Icon(
                                      slide['icon'] as IconData,
                                      size: 54,
                                      color: const Color(0xFFEDB000),
                                    ),
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
        ),

        const SizedBox(height: 14),

        // Pagination Indicator (Animated rounded pills)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_heroSlides.length, (index) {
            final isSelected = index == _currentHeroPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 4,
              width: isSelected ? 24 : 8,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMiniFlowStep(IconData icon, String label) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFEDB000), size: 11),
          const SizedBox(width: 2),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 9.5,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 4. POPULAR SERVICES (Crazy Finds Style)
  // ==========================================
  Widget _buildPopularServicesSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title & See All Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Popular Services',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1F2D27),
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Blink and you\'ll miss it • 6-Month Warranty',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Color(0xFF5F6F67),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                QFPressable(
                  onTap: () => context.push('/select-brand'),
                  pressedScale: 0.95,
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF003A26),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Horizontal List of Large Image Cards (Circle Store layout)
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _popularServices.length,
              itemBuilder: (context, index) {
                final svc = _popularServices[index];
                return _buildServiceCard(svc);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> svc) {
    return QFPressable(
      onTap: () => context.push('/select-brand'),
      pressedScale: 0.96,
      child: Container(
        width: 170,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8ECEA), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Area with Badge & Favorite Heart
            Stack(
              children: [
                Container(
                  height: 125,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: svc['gradient'] as List<Color>,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      svc['icon'] as IconData,
                      size: 52,
                      color: const Color(0xFFEDB000),
                    ),
                  ),
                ),

                // Top-Left Badge (Lightly Used style -> OEM Grade)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      svc['badge'] as String,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF003A26),
                      ),
                    ),
                  ),
                ),

                // Top-Right Favorite Heart Icon
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.25),
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),

            // Card Bottom Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    svc['title'] as String,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F2D27),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    svc['category'] as String,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: Color(0xFF5F6F67),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Price Row
                  Row(
                    children: [
                      Text(
                        svc['price'] as String,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF003A26),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        svc['mrp'] as String,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: Color(0xFF5F6F67),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDB000).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          svc['discount'] as String,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF003A26),
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
    );
  }

  // ==========================================
  // TRUST & VALUE PROPOSITIONS
  // ==========================================
  Widget _buildTrustValueProposition() {
    final guarantees = [
      {'icon': Icons.bolt_rounded, 'title': '30-Min Arrival', 'sub': 'Rapid doorstep tech'},
      {'icon': Icons.verified_user_rounded, 'title': '6-Mo Warranty', 'sub': 'Genuine OEM parts'},
      {'icon': Icons.lock_outline_rounded, 'title': 'Safe & Tested', 'sub': 'Data zero-wipe policy'},
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9F8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8ECEA)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: guarantees.map((g) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF003A26).withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(g['icon'] as IconData, color: const Color(0xFF003A26), size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                g['title'] as String,
                style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF1F2D27)),
              ),
              const SizedBox(height: 2),
              Text(
                g['sub'] as String,
                style: const TextStyle(fontFamily: 'Inter', fontSize: 10, color: Color(0xFF5F6F67)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ==========================================
  // 5. STICKY LOCATION BANNER (Exact Circle design)
  // ==========================================
  Widget _buildStickyLocationBanner() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF8EA), // Pale lime/green tint from Circle reference
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Location Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFBCEB77), // Soft lime accent
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: Color(0xFF003A26),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add your location',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F2D27),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'To check serviceability in your area',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Green / Lime 'Add' Button (exact Circle button)
          QFPressable(
            onTap: _showLocationModal,
            pressedScale: 0.94,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF8CE338), // Circle-style vibrant action button
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8CE338).withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF003A26),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
