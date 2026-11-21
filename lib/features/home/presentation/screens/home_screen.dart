import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/qf_pressable.dart';
import '../../../../core/widgets/qf_animated_pulse.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  // Infinite Hero Carousel Controller & Timer
  static const int _virtualPageBase = 300;
  late final PageController _heroController;
  int _currentHeroIndex = 0;
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

  // Favorite items state for service cards
  final Set<String> _favoriteServices = {};

  // 3 Hero Carousel slides with user-requested copy & detailed 2.5D artwork
  final List<Map<String, dynamic>> _heroSlides = [
    {
      'headline': 'Instant Display\nReplacement.',
      'sub': 'Fast, reliable doorstep screen replacement.',
      'step1': '45-Min Fix',
      'step2': 'Tested Glass',
      'step3': 'Free Pickup',
      'cta': 'Claim Offer',
      'type': 'display',
      'gradient': [Color(0xFF012014), Color(0xFF003824), Color(0xFF075438)],
    },
    {
      'headline': 'Battery Running\nLow?',
      'sub': 'Get your battery replaced by certified experts.',
      'step1': '100% Health',
      'step2': 'Genuine Cells',
      'step3': '30-Min Swap',
      'cta': 'Swap Battery',
      'type': 'battery',
      'gradient': [Color(0xFF041F14), Color(0xFF093926), Color(0xFF0B4E34)],
    },
    {
      'headline': 'Your Device Deserves\nExpert Care.',
      'sub': 'Professional repairs. Trusted technicians.',
      'step1': 'Doorstep Tech',
      'step2': 'Data Safe',
      'step3': '6-Mo Warranty',
      'cta': 'Book Repair',
      'type': 'expert',
      'gradient': [Color(0xFF021B11), Color(0xFF003422), Color(0xFF0D5036)],
    },
  ];

  // Popular Services Cards (Matching Circle Store horizontal card architecture)
  final List<Map<String, dynamic>> _popularServices = [
    {
      'id': 'screen_replace',
      'title': 'Screen Replacement',
      'sub': 'Original OEM grade glass',
      'badge': 'OEM Grade',
      'price': '₹1,499',
      'mrp': '₹2,999',
      'discount': '50% OFF',
      'rating': '4.9 ★ (1.4k)',
      'type': 'screen',
      'gradient': [Color(0xFF003020), Color(0xFF08563A)],
    },
    {
      'id': 'battery_replace',
      'title': 'Battery Replacement',
      'sub': 'Restore 100% health & backup',
      'badge': 'Original Part',
      'price': '₹999',
      'mrp': '₹1,999',
      'discount': '50% OFF',
      'rating': '4.8 ★ (980)',
      'type': 'battery',
      'gradient': [Color(0xFF0A3322), Color(0xFF0F5A3B)],
    },
    {
      'id': 'water_damage',
      'title': 'Water Damage Repair',
      'sub': 'Deep ultrasonic diagnostics',
      'badge': 'Express 60m',
      'price': '₹799',
      'mrp': '₹1,499',
      'discount': '46% OFF',
      'rating': '4.9 ★ (720)',
      'type': 'water',
      'gradient': [Color(0xFF042D1E), Color(0xFF095035)],
    },
    {
      'id': 'charging_port',
      'title': 'Charging Port Fix',
      'sub': 'Type-C & Lightning pin fix',
      'badge': 'OEM Grade',
      'price': '₹699',
      'mrp': '₹1,299',
      'discount': '46% OFF',
      'rating': '4.7 ★ (610)',
      'type': 'port',
      'gradient': [Color(0xFF0E3826), Color(0xFF054C30)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _heroController = PageController(initialPage: _virtualPageBase);
    _startHeroAutoSlide();
    _startSearchPlaceholderCycle();
  }

  void _startHeroAutoSlide() {
    _heroTimer?.cancel();
    _heroTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_isUserInteracting && _heroController.hasClients) {
        _heroController.nextPage(
          duration: const Duration(milliseconds: 650),
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
    HapticFeedback.lightImpact();
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
                    HapticFeedback.lightImpact();
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
    // Exactly ONE bottom navigation bar is handled by MainShell.
    // HomeScreen contains the scrollable feed and the sticky location banner.
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main Scrollable Screen
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 86), // Clearance for sticky location banner
              physics: const BouncingScrollPhysics(),
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
  // 1. HEADER REFINEMENT (Atmospheric lighting & balance)
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
            Color(0xFF00150D),
            Color(0xFF003A26),
            Color(0xFF002719),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Ambient luxury lighting radial glow in the top-right corner
          Positioned(
            right: -30,
            top: -20,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF0F6443).withValues(alpha: 0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: topPadding + 10),

              // --- Top Row: QuickFix Logo & PRO Badge (Left) & Sign In Pill (Right) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Brand Logo + PRO badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'quick',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 27,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -0.9,
                                ),
                              ),
                              TextSpan(
                                text: 'fix',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 27,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFEDB000),
                                  letterSpacing: -0.9,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6.5, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDB000).withValues(alpha: 0.15),
                            border: Border.all(color: const Color(0xFFEDB000), width: 1.2),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFEDB000).withValues(alpha: 0.2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Text(
                            'PRO',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFEDB000),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Sign In Outline Pill Button (Exact Circle match)
                    QFPressable(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        context.push('/auth/login');
                      },
                      pressedScale: 0.95,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7.5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.85), width: 1.2),
                          borderRadius: BorderRadius.circular(22),
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

              // --- Location Selector Row with Active Tech Count ---
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

              // --- Large White Stadium Search Bar ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: QFPressable(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.push('/select-brand');
                  },
                  pressedScale: 0.99,
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.22),
                          blurRadius: 16,
                          offset: const Offset(0, 5),
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
                                fontSize: 13.5,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF003A26).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
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
                              Icon(Icons.chevron_right_rounded, size: 14, color: Color(0xFF003A26)),
                            ],
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
              HapticFeedback.lightImpact();
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
                    size: 25,
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
  // 3. HERO CAROUSEL (Infinite Looping & 2.5D Studio Artwork)
  // ==========================================
  Widget _buildHeroCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 195,
          child: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              _isUserInteracting = notification.direction.name != 'idle';
              return false;
            },
            child: PageView.builder(
              controller: _heroController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (virtualIndex) {
                setState(() {
                  _currentHeroIndex = virtualIndex % _heroSlides.length;
                });
              },
              itemBuilder: (context, virtualIndex) {
                final slideIndex = virtualIndex % _heroSlides.length;
                final slide = _heroSlides[slideIndex];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: slide['gradient'] as List<Color>,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Layered ambient radial illumination
                        Positioned(
                          right: -25,
                          top: -25,
                          child: Container(
                            width: 190,
                            height: 190,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFFEDB000).withValues(alpha: 0.18),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Content Row: Text & Process on Left, Studio Artwork on Right
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
                                    // Headline
                                    Text(
                                      slide['headline'] as String,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        height: 1.15,
                                        letterSpacing: -0.4,
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    // Subtitle
                                    Text(
                                      slide['sub'] as String,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 10.5,
                                        color: Colors.white.withValues(alpha: 0.8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),

                                    // 3-Stage Process Flow
                                    Row(
                                      children: [
                                        _buildMiniFlowStep(Icons.check_circle_outline_rounded, slide['step1'] as String),
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

                                    const SizedBox(height: 10),

                                    // CTA Pill Button
                                    QFPressable(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        context.push('/select-brand');
                                      },
                                      pressedScale: 0.95,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7.5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEDB000),
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFFEDB000).withValues(alpha: 0.35),
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
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w900,
                                                color: Color(0xFF003A26),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(Icons.arrow_forward_rounded, size: 12, color: Color(0xFF003A26)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Right Studio Artwork (Layered 2.5D graphics)
                              Expanded(
                                flex: 4,
                                child: Center(
                                  child: _buildHeroArtwork(slide['type'] as String),
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
            final isSelected = index == _currentHeroIndex;
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

  // Multi-layered studio illustrations replacing basic flat icons
  Widget _buildHeroArtwork(String type) {
    if (type == 'display') {
      return SizedBox(
        width: 100,
        height: 115,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Smartphone frame with glowing OLED gradient
            Container(
              width: 58,
              height: 98,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white70, width: 2),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0C4D34), Color(0xFF136A49)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEDB000).withValues(alpha: 0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Icon(Icons.bolt_rounded, color: Color(0xFFEDB000), size: 28),
                  const SizedBox(height: 16),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white54, width: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            // Tilted precision screwdriver tool
            Positioned(
              right: 2,
              top: 6,
              child: Transform.rotate(
                angle: 0.5,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDB000),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.build_rounded, size: 16, color: Color(0xFF003A26)),
                ),
              ),
            ),
            // OEM badge pill
            Positioned(
              left: 0,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Text(
                  'OEM GRADE',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF003A26),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (type == 'battery') {
      return SizedBox(
        width: 100,
        height: 115,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Lithium battery cell representation
            Container(
              width: 54,
              height: 92,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFEDB000), width: 1.8),
                color: const Color(0xFF0A2B1D),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEDB000).withValues(alpha: 0.2),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top battery positive contact tab
                  Container(
                    width: 22,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEDB000),
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(3)),
                    ),
                  ),
                  const Column(
                    children: [
                      Icon(Icons.battery_charging_full_rounded, color: Color(0xFFEDB000), size: 36),
                      Text(
                        '100%',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  // Bottom ground tab
                  Container(
                    width: 32,
                    height: 3,
                    color: Colors.white30,
                  ),
                ],
              ),
            ),
            // Certified verification check chip
            Positioned(
              right: 0,
              bottom: 14,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color(0xFF8CE338),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Color(0xFF003A26), size: 14),
              ),
            ),
          ],
        ),
      );
    } else {
      // Expert care composite
      return SizedBox(
        width: 100,
        height: 115,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Laptop & Phone backplate
            Container(
              width: 76,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white60, width: 1.5),
                color: const Color(0xFF093120),
              ),
              child: const Center(
                child: Icon(Icons.laptop_mac_rounded, color: Colors.white70, size: 28),
              ),
            ),
            // Shield of authenticity
            Positioned(
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDB000),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shield_rounded, size: 14, color: Color(0xFF003A26)),
                    SizedBox(width: 4),
                    Text(
                      'CERTIFIED',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF003A26),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
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
                      'Expert care for your devices',
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
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.push('/select-brand');
                  },
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
            height: 260,
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
    final svcId = svc['id'] as String;
    final isFavorite = _favoriteServices.contains(svcId);

    return QFPressable(
      onTap: () {
        HapticFeedback.lightImpact();
        context.push('/select-brand');
      },
      pressedScale: 0.96,
      child: Container(
        width: 175,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8ECEA), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Area with Realistic Graphic & Heart
            Stack(
              children: [
                Container(
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: svc['gradient'] as List<Color>,
                    ),
                  ),
                  child: Center(
                    child: _buildServiceCardArtwork(svc['type'] as String),
                  ),
                ),

                // Top-Left Badge (OEM Grade)
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

                // Top-Right Favorite Heart Icon with interactive state
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        if (isFavorite) {
                          _favoriteServices.remove(svcId);
                        } else {
                          _favoriteServices.add(svcId);
                        }
                      });
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.28),
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFavorite ? const Color(0xFFEDB000) : Colors.white,
                        size: 16,
                      ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          svc['title'] as String,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1F2D27),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    svc['sub'] as String,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: Color(0xFF5F6F67),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Rating pill
                  Row(
                    children: [
                      Text(
                        svc['rating'] as String,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFEDB000),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

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

  Widget _buildServiceCardArtwork(String type) {
    if (type == 'screen') {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 50,
            height: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white60, width: 1.5),
              color: const Color(0xFF063321),
            ),
            child: const Center(
              child: Icon(Icons.smartphone_rounded, color: Color(0xFFEDB000), size: 30),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Icon(Icons.handyman_rounded, color: Colors.white.withValues(alpha: 0.7), size: 20),
          ),
        ],
      );
    } else if (type == 'battery') {
      return Container(
        width: 44,
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFEDB000), width: 1.5),
          color: const Color(0xFF0A2B1D),
        ),
        child: const Center(
          child: Icon(Icons.battery_charging_full_rounded, color: Color(0xFFEDB000), size: 32),
        ),
      );
    } else if (type == 'water') {
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFEDB000).withValues(alpha: 0.15),
        ),
        child: const Center(
          child: Icon(Icons.water_drop_rounded, color: Color(0xFFEDB000), size: 36),
        ),
      );
    } else {
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFEDB000).withValues(alpha: 0.15),
        ),
        child: const Center(
          child: Icon(Icons.electrical_services_rounded, color: Color(0xFFEDB000), size: 34),
        ),
      );
    }
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
  // 5. STICKY LOCATION BANNER (With live radar beacon & frosted blur)
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
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Location Icon with Pulse Beacon
          Stack(
            alignment: Alignment.center,
            children: [
              const QFAnimatedPulse(
                size: 38,
                color: Color(0xFF8CE338),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Color(0xFFBCEB77), // Soft lime accent
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFF003A26),
                    size: 19,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Title & Subtitle with active technician status
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
                  '14 Technicians ready • Check availability',
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
