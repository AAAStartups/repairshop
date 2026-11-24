import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../booking/presentation/controllers/booking_flow_controller.dart';
import '../../../../core/widgets/qf_pressable.dart';
import '../../../../core/widgets/qf_step_indicator.dart';
import '../../data/catalog_repository.dart';
import '../../domain/models/brand_model.dart';

class BrandSelectionScreen extends ConsumerStatefulWidget {
  const BrandSelectionScreen({super.key});

  @override
  ConsumerState<BrandSelectionScreen> createState() => _BrandSelectionScreenState();
}

class _BrandSelectionScreenState extends ConsumerState<BrandSelectionScreen> {
  String _search = '';
  String? _selectedId;
  String? _hoveredId;

  List<BrandModel> _getFiltered(List<BrandModel> allBrands) {
    if (_search.trim().isEmpty) return allBrands;
    final query = _search.toLowerCase().trim();
    return allBrands.where((b) {
      final nameMatches = b.name.toLowerCase().contains(query);
      final subtitleMatches = b.subtitle?.toLowerCase().contains(query) ?? false;
      final idMatches = b.id.toLowerCase().contains(query);
      final isXiaomiQuery = (query.contains('redmi') || query.contains('mi')) && b.id == 'xiaomi';
      return nameMatches || subtitleMatches || idMatches || isXiaomiQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final brandsAsync = ref.watch(brandsListProvider);
    final allBrands = brandsAsync.valueOrNull ?? mockBrands;
    final popularBrands = allBrands.where((b) => b.isPopular).toList();
    final filtered = _getFiltered(allBrands);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F5),
      body: SafeArea(
        child: Column(
          children: [
            // --- TOP HEADER BAR ---
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  QFPressable(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/home');
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8ECEA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: Color(0xFF003A26),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Device Brand',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF003A26),
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Genuine OEM parts for all major manufacturers',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5F6F67),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Step Indicator
            const QFStepIndicator(
              currentStep: 1,
              totalSteps: 5,
              title: 'Choose Brand',
              subtitle: 'Select Device Manufacturer',
            ),

            // --- SEARCH STADIUM BAR ---
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F6F4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE8ECEA)),
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _search = v),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF003A26),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search brand (Apple, Samsung, OnePlus, Xiaomi, Pixel)...',
                    hintStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.5,
                      color: Color(0xFF5F6F67),
                    ),
                    prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF003A26), size: 20),
                    suffixIcon: _search.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18, color: Color(0xFF5F6F67)),
                            onPressed: () => setState(() => _search = ''),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  ),
                ),
              ),
            ),

            // --- BRANDS FEED (Responsive & Scalable) ---
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1040),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // Popular Brands Quick Strip (when not actively searching)
                      if (_search.isEmpty) ...[
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 14,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDB000),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'MOST POPULAR BRANDS',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF5F6F67),
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 104,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: popularBrands.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                            itemBuilder: (context, index) {
                              final brand = popularBrands[index];
                              final isSelected = _selectedId == brand.id;
                              final isHovered = _hoveredId == 'pop_${brand.id}';

                              return Tooltip(
                                message: 'Select ${brand.name}',
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  onEnter: (_) => setState(() => _hoveredId = 'pop_${brand.id}'),
                                  onExit: (_) => setState(() => _hoveredId = null),
                                  child: QFPressable(
                                    onTap: () => _handleSelectBrand(brand),
                                    pressedScale: 0.95,
                                    child: AnimatedScale(
                                      scale: isHovered ? 1.04 : 1.0,
                                      duration: const Duration(milliseconds: 180),
                                      curve: Curves.easeOutCubic,
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        width: 94,
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: isSelected ? const Color(0xFF003A26) : Colors.white,
                                          borderRadius: BorderRadius.circular(18),
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color(0xFFEDB000)
                                                : (isHovered ? const Color(0xFF003A26).withValues(alpha: 0.4) : const Color(0xFFE8ECEA)),
                                            width: isSelected ? 2 : (isHovered ? 1.5 : 1),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: isSelected
                                                  ? const Color(0xFF003A26).withValues(alpha: 0.25)
                                                  : (isHovered ? Colors.black.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.02)),
                                              blurRadius: isSelected ? 10 : (isHovered ? 8 : 4),
                                              offset: Offset(0, isHovered ? 3 : 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // Brand Logo Container (centered, fixed dimensions)
                                            _BrandLogoContainer(
                                              brand: brand,
                                              size: 42,
                                              imageSize: 28,
                                              isSelected: isSelected,
                                              isHovered: isHovered,
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              brand.name,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w700,
                                                color: isSelected ? Colors.white : const Color(0xFF003A26),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],

                      // All Brands Section Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF003A26),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _search.isEmpty ? 'ALL SUPPORTED BRANDS' : 'SEARCH RESULTS (${filtered.length})',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF5F6F67),
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                          const Row(
                            children: [
                              Icon(Icons.shield_outlined, size: 12, color: Color(0xFF10B981)),
                              SizedBox(width: 4),
                              Text(
                                '100% Genuine Tech',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Responsive Brand Grid (Adapts to Mobile, Tablet, and Desktop)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final int crossAxisCount = width > 850 ? 6 : (width > 550 ? 4 : 3);
                          final double childAspectRatio = width > 850 ? 0.94 : (width > 550 ? 0.90 : 0.86);

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: childAspectRatio,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final brand = filtered[index];
                              final isSelected = _selectedId == brand.id;
                              final isHovered = _hoveredId == 'grid_${brand.id}';

                              return Tooltip(
                                message: 'Select ${brand.name}${brand.subtitle != null ? " (${brand.subtitle})" : ""}',
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  onEnter: (_) => setState(() => _hoveredId = 'grid_${brand.id}'),
                                  onExit: (_) => setState(() => _hoveredId = null),
                                  child: QFPressable(
                                    onTap: () => _handleSelectBrand(brand),
                                    pressedScale: 0.95,
                                    child: AnimatedScale(
                                      scale: isHovered ? 1.03 : 1.0,
                                      duration: const Duration(milliseconds: 180),
                                      curve: Curves.easeOutCubic,
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        decoration: BoxDecoration(
                                          color: isSelected ? const Color(0xFF003A26) : Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color(0xFFEDB000)
                                                : (isHovered ? const Color(0xFF003A26).withValues(alpha: 0.45) : const Color(0xFFE8ECEA)),
                                            width: isSelected ? 2.2 : (isHovered ? 1.5 : 1.0),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: isSelected
                                                  ? const Color(0xFF003A26).withValues(alpha: 0.28)
                                                  : (isHovered ? Colors.black.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.02)),
                                              blurRadius: isSelected ? 12 : (isHovered ? 8 : 4),
                                              offset: Offset(0, isHovered ? 3 : 2),
                                            ),
                                          ],
                                        ),
                                        child: Stack(
                                          children: [
                                            // Popular Badge
                                            if (brand.isPopular && !isSelected)
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFEDB000),
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: const Text(
                                                    'POPULAR',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 7.5,
                                                      fontWeight: FontWeight.w900,
                                                      color: Color(0xFF003A26),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                            // Selected Indicator Pill
                                            if (isSelected)
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: Container(
                                                  width: 18,
                                                  height: 18,
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xFFEDB000),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.check_rounded,
                                                      size: 13,
                                                      color: Color(0xFF003A26),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                            // Card Center Content
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    // Brand Logo Container (equal dimensions, BoxFit.contain)
                                                    _BrandLogoContainer(
                                                      brand: brand,
                                                      size: 52,
                                                      imageSize: 36,
                                                      isSelected: isSelected,
                                                      isHovered: isHovered,
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      brand.name,
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize: 12.5,
                                                        fontWeight: FontWeight.w700,
                                                        color: isSelected ? Colors.white : const Color(0xFF003A26),
                                                      ),
                                                      textAlign: TextAlign.center,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    if (brand.subtitle != null) ...[
                                                      const SizedBox(height: 1),
                                                      Text(
                                                        brand.subtitle!,
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontSize: 9.5,
                                                          fontWeight: FontWeight.w600,
                                                          color: isSelected
                                                              ? const Color(0xFFEDB000)
                                                              : const Color(0xFF5F6F67),
                                                        ),
                                                        textAlign: TextAlign.center,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
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

  void _handleSelectBrand(BrandModel brand) {
    setState(() => _selectedId = brand.id);
    ref.read(bookingFlowProvider.notifier).selectBrand(brand.id, brand.name);
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) context.push('/select-model');
    });
  }
}

/// Reusable Brand Logo Container with equal dimensions, object-fit contain,
/// accessibility semantics, and resilient fallback handling.
class _BrandLogoContainer extends StatelessWidget {
  final BrandModel brand;
  final double size;
  final double imageSize;
  final bool isSelected;
  final bool isHovered;

  const _BrandLogoContainer({
    required this.brand,
    required this.size,
    required this.imageSize,
    required this.isSelected,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white
            : (isHovered ? Colors.white : const Color(0xFFF3F6F4)),
        borderRadius: BorderRadius.circular(size * 0.32),
        border: Border.all(
          color: isSelected
              ? const Color(0xFFEDB000)
              : (isHovered ? const Color(0xFF003A26).withValues(alpha: 0.15) : const Color(0xFFE8ECEA)),
          width: isSelected ? 1.5 : 1.0,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          else if (isHovered)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
        ],
      ),
      child: Center(
        child: Semantics(
          label: '${brand.name} official logo',
          image: true,
          child: Padding(
            padding: EdgeInsets.all(size * 0.16),
            child: Image.asset(
              brand.assetPath,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain, // Requirement 5: object-fit: contain to prevent logo distortion
              errorBuilder: (context, error, stackTrace) {
                // Graceful fallback to emoji icon if asset fails to load
                return Center(
                  child: Text(
                    brand.logoEmoji,
                    style: TextStyle(fontSize: imageSize * 0.65),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
