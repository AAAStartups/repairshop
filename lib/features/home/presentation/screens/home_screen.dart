import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/qf_pressable.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // The carousel is user-controlled; it never advances while someone is reading.
  static const int _virtualPageBase = 300;
  late final PageController _heroController;
  int _currentHeroIndex = 0;

  // Location State
  String _selectedLocation = 'Indiranagar, Bangalore';

  // Favorite items state for service cards
  final Set<String> _favoriteServices = {};

  // 3 Hero Carousel slides with user-requested copy & detailed artwork
  final List<Map<String, dynamic>> _heroSlides = [
    {
      'headline': 'Instant Display\nReplacement.',
      'sub': 'Fast, reliable doorstep screen replacement.',
      'step2': 'Tested Glass',
      'cta': 'Claim Offer',
      'type': 'display',
      'gradient': [Color(0xFF07271B), Color(0xFF033F27), Color(0xFF075739)],
    },
    {
      'headline': 'Battery Running\nLow?',
      'sub': 'Get your battery replaced by certified experts.',
      'step2': 'Genuine Cells',
      'cta': 'Swap Battery',
      'type': 'battery',
      'gradient': [Color(0xFF092218), Color(0xFF063A25), Color(0xFF0B4E33)],
    },
    {
      'headline': 'Your Device Deserves\nExpert Care.',
      'sub': 'Professional repairs. Trusted technicians.',
      'step2': 'Data Safe',
      'cta': 'Book Repair',
      'type': 'expert',
      'gradient': [Color(0xFF052014), Color(0xFF043722), Color(0xFF0C5035)],
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
    // viewportFraction 1.0 ensures clean, full-width presentation without awkward side slivers
    _heroController = PageController(initialPage: _virtualPageBase, viewportFraction: 1.0);
  }

  @override
  void dispose() {
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
    // Exactly ONE bottom navigation bar is managed by MainShell.
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
  // 1. HEADER (Quiet dark canvas, clear brand and booking path)
  // ==========================================
  Widget _buildCircleHeaderSection() {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        // Jet-Black / Dark Charcoal canvas creating high contrast like Circle reference
        color: Color(0xFF080C0A),
      ),
      child: Column(
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
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -0.9,
                                ),
                              ),
                              TextSpan(
                                text: 'fix',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 28,
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
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDB000).withValues(alpha: 0.15),
                            border: Border.all(color: const Color(0xFFEDB000), width: 1.2),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFEDB000).withValues(alpha: 0.25),
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
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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

              // --- Location Selector Row ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: QFPressable(
                  onTap: _showLocationModal,
                  pressedScale: 0.98,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13),
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
              ),

              const SizedBox(height: 18),

              // --- Large White Stadium Search Bar (Clean & Uncluttered like Circle) ---
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
                          color: Colors.black.withValues(alpha: 0.16),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: Color(0xFF003A26), size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                              'Search a device or repair',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- 2. HERO PROMOTIONAL CAROUSEL ---
              _buildHeroCarousel(),

              const SizedBox(height: 24),
            ],
      ),
    );
  }

  // ==========================================
  // 2. HERO CAROUSEL (Full-Width Card, No Peeking Slivers)
  // ==========================================
  Widget _buildHeroCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 195,
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
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Container(
                    decoration: BoxDecoration(
                      color: (slide['gradient'] as List<Color>).first,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                        width: 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
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
                                        fontSize: 21,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        height: 1.15,
                                        letterSpacing: -0.35,
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    // Subtitle
                                    Text(
                                      slide['sub'] as String,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        color: Colors.white.withValues(alpha: 0.8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 10),

                                    // One concise service assurance keeps the hero easy to scan.
                                    Row(
                                      children: [
                                        const Icon(Icons.verified_rounded, size: 14, color: Color(0xFFEDB000)),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            slide['step2'] as String,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 11,
                                              color: Colors.white.withValues(alpha: 0.86),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 12),

                                    // CTA Pill Button
                                    QFPressable(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        context.push('/select-brand');
                                      },
                                      pressedScale: 0.95,
                                      child: Container(
                                        height: 44,
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEDB000),
                                          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              slide['cta'] as String,
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF003A26),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(Icons.arrow_forward_rounded, size: 15, color: Color(0xFF003A26)),
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

  // ==========================================
  // 4. POPULAR REPAIR SERVICES (Horizontal browsing)
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
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2D27),
                        letterSpacing: -0.35,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF003A26),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Horizontal List of Large Image Cards (Circle Store layout)
          SizedBox(
            height: 278,
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
      pressedScale: 0.985,
      child: Container(
        width: 184,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(color: const Color(0xFFE8ECEA), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Illustrated service artwork with a separately actionable favorite control.
            Stack(
              children: [
                Container(
                  height: 138,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: (svc['gradient'] as List<Color>).first,
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
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      svc['badge'] as String,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.5,
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
                  child: IconButton(
                    tooltip: isFavorite
                        ? 'Remove ${svc['title']} from favorites'
                        : 'Add ${svc['title']} to favorites',
                    constraints: const BoxConstraints.tightFor(width: 44, height: 44),
                    padding: EdgeInsets.zero,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.28),
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        if (isFavorite) {
                          _favoriteServices.remove(svcId);
                        } else {
                          _favoriteServices.add(svcId);
                        }
                      });
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isFavorite ? const Color(0xFFEDB000) : Colors.white,
                      size: 18,
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
                            fontSize: 14,
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
                      fontSize: 12,
                      color: Color(0xFF5F6F67),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Starting from pricing label
                  const Text(
                    'Starting from',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5F6F67),
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Price Row
                  Row(
                    children: [
                      Text(
                        svc['price'] as String,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
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
          Container(
            width: 38,
            height: 38,
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
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
