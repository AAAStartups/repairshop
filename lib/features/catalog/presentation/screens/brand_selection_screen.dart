import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../booking/presentation/controllers/booking_flow_controller.dart';
import '../../../../core/widgets/qf_pressable.dart';
import '../../../../core/widgets/qf_step_indicator.dart';
import '../../domain/models/brand_model.dart';

class BrandSelectionScreen extends ConsumerStatefulWidget {
  const BrandSelectionScreen({super.key});

  @override
  ConsumerState<BrandSelectionScreen> createState() => _BrandSelectionScreenState();
}

class _BrandSelectionScreenState extends ConsumerState<BrandSelectionScreen> {
  String _search = '';
  String? _selectedId;

  List<BrandModel> get _filtered => mockBrands
      .where((b) => b.name.toLowerCase().contains(_search.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    final popularBrands = mockBrands.where((b) => b.isPopular).toList();

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
                    hintText: 'Search brand (Apple, Samsung, OnePlus, Xiaomi)...',
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

            // --- BRANDS FEED ---
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                physics: const BouncingScrollPhysics(),
                children: [
                  // Popular Brands Quick Section (when not searching)
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
                      height: 92,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: popularBrands.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final brand = popularBrands[index];
                          final isSelected = _selectedId == brand.id;

                          return QFPressable(
                            onTap: () => _handleSelectBrand(brand),
                            pressedScale: 0.94,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 86,
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF003A26) : Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFEDB000)
                                      : const Color(0xFFE8ECEA),
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isSelected
                                        ? const Color(0xFF003A26).withValues(alpha: 0.2)
                                        : Colors.black.withValues(alpha: 0.02),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(brand.logoEmoji, style: const TextStyle(fontSize: 26)),
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
                            _search.isEmpty ? 'ALL SUPPORTED BRANDS' : 'SEARCH RESULTS (${_filtered.length})',
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

                  // Brand Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final brand = _filtered[index];
                      final isSelected = _selectedId == brand.id;

                      return QFPressable(
                        onTap: () => _handleSelectBrand(brand),
                        pressedScale: 0.94,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF003A26) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFEDB000)
                                  : const Color(0xFFE8ECEA),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? const Color(0xFF003A26).withValues(alpha: 0.25)
                                    : Colors.black.withValues(alpha: 0.02),
                                blurRadius: isSelected ? 12 : 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              if (brand.isPopular)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDB000),
                                      borderRadius: BorderRadius.circular(6),
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
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.white.withValues(alpha: 0.12)
                                            : const Color(0xFFF3F6F4),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(brand.logoEmoji, style: const TextStyle(fontSize: 24)),
                                      ),
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
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
