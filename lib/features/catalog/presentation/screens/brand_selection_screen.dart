import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../booking/presentation/controllers/booking_flow_controller.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
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
          'Select Device Brand',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF003A26),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF003A26)),
              decoration: InputDecoration(
                hintText: 'Search brand (Apple, Samsung, OnePlus...)',
                hintStyle: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: Color(0xFF5F6F67)),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF003A26)),
                filled: true,
                fillColor: const Color(0xFFF3F6F4),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.88,
              ),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final brand = _filtered[index];
                final isSelected = _selectedId == brand.id;

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedId = brand.id);
                    ref.read(bookingFlowProvider.notifier).selectBrand(brand.id, brand.name);
                    Future.delayed(const Duration(milliseconds: 180), () {
                      if (context.mounted) context.push('/select-model');
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF003A26) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFEDB000) : const Color(0xFFD1D9D6).withValues(alpha: 0.7),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? const Color(0xFF003A26).withValues(alpha: 0.25)
                              : Colors.black.withValues(alpha: 0.03),
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
                                'HOT',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 8,
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
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.12)
                                      : const Color(0xFFF3F6F4),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(brand.logoEmoji, style: const TextStyle(fontSize: 26)),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                brand.name,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? Colors.white : const Color(0xFF003A26),
                                ),
                                textAlign: TextAlign.center,
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
        ],
      ),
    );
  }
}
