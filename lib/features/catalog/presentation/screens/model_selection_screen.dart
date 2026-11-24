import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../booking/presentation/controllers/booking_flow_controller.dart';
import '../../../../core/widgets/qf_pressable.dart';
import '../../../../core/widgets/qf_step_indicator.dart';
import '../../data/catalog_repository.dart';
import '../../domain/models/device_model.dart';

class ModelSelectionScreen extends ConsumerStatefulWidget {
  const ModelSelectionScreen({super.key});

  @override
  ConsumerState<ModelSelectionScreen> createState() => _ModelSelectionScreenState();
}

class _ModelSelectionScreenState extends ConsumerState<ModelSelectionScreen> {
  String _search = '';
  String? _selectedModelId;
  String _selectedSeries = 'All';

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(bookingFlowProvider);
    final brandId = draft.brandId ?? 'apple';
    final brandName = draft.brandName ?? 'Apple';
    final modelsAsync = ref.watch(deviceModelsListProvider(brandId));
    final models = modelsAsync.valueOrNull ?? [];

    // Extract all unique series for the filter rail
    final seriesSet = <String>{'All'};
    for (final m in models) {
      if (m.series != null && m.series!.isNotEmpty) {
        seriesSet.add(m.series!);
      }
    }
    final seriesList = seriesSet.toList();

    // Filter by search query and selected series
    final filtered = models.where((m) {
      final matchesSearch = m.name.toLowerCase().contains(_search.toLowerCase());
      final matchesSeries = _selectedSeries == 'All' || m.series == _selectedSeries;
      return matchesSearch && matchesSeries;
    }).toList();

    // Group filtered models by series for display
    final Map<String, List<DeviceModel>> grouped = {};
    for (final m in filtered) {
      final s = m.series ?? 'Other Models';
      grouped.putIfAbsent(s, () => []).add(m);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F5),
      body: SafeArea(
        child: Column(
          children: [
            // --- TOP APP BAR ---
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  QFPressable(
                    onTap: () => context.pop(),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Device Model',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF003A26),
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDB000).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                brandName.toUpperCase(),
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF003A26),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${models.length} Models Supported',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF5F6F67),
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

            // Step Indicator
            QFStepIndicator(
              currentStep: 2,
              totalSteps: 5,
              title: 'Choose Model',
              subtitle: '$brandName Hardware Profile',
            ),

            // --- SEARCH STADIUM BAR ---
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 10),
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
                    hintText: 'Search $brandName model (e.g. Pro Max, Ultra, Plus)...',
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

            // --- SERIES FILTER HORIZONTAL RAIL ---
            if (seriesList.length > 2)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: SizedBox(
                  height: 34,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: seriesList.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final s = seriesList[index];
                      final isSelected = _selectedSeries == s;

                      return QFPressable(
                        onTap: () => setState(() => _selectedSeries = s),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF003A26) : const Color(0xFFF3F6F4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF003A26) : const Color(0xFFE8ECEA),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              s,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.5,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                color: isSelected ? Colors.white : const Color(0xFF5F6F67),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            // --- MODEL CARDS LIST ---
            Expanded(
              child: models.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('📱', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 12),
                          Text(
                            'No models found for $brandName',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF003A26),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Try selecting another brand from the previous step',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: Color(0xFF5F6F67),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      physics: const BouncingScrollPhysics(),
                      itemCount: grouped.keys.length,
                      itemBuilder: (context, groupIndex) {
                        final series = grouped.keys.elementAt(groupIndex);
                        final seriesModels = grouped[series]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 8, top: groupIndex == 0 ? 0 : 14),
                              child: Row(
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
                                  Text(
                                    series.toUpperCase(),
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF003A26),
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ...seriesModels.map((model) {
                              final isSelected = _selectedModelId == model.id;

                              return QFPressable(
                                onTap: () => _handleSelectModel(model),
                                pressedScale: 0.98,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
                                            ? const Color(0xFF003A26).withValues(alpha: 0.12)
                                            : Colors.black.withValues(alpha: 0.02),
                                        blurRadius: isSelected ? 10 : 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Device Silhouette Icon
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color(0xFF003A26)
                                              : const Color(0xFFF3F6F4),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.phone_iphone_rounded,
                                            size: 22,
                                            color: isSelected ? const Color(0xFFEDB000) : const Color(0xFF003A26),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),

                                      // Model Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              model.name,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 14.5,
                                                fontWeight: FontWeight.w800,
                                                color: isSelected
                                                    ? const Color(0xFF003A26)
                                                    : const Color(0xFF1F2D27),
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Row(
                                              children: [
                                                if (model.releaseYear != null) ...[
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFFE8ECEA),
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Text(
                                                      '${model.releaseYear}',
                                                      style: const TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w700,
                                                        color: Color(0xFF5F6F67),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                ],
                                                const Icon(Icons.check_circle_rounded, size: 12, color: Color(0xFF10B981)),
                                                const SizedBox(width: 4),
                                                const Text(
                                                  'OEM Parts Available',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF10B981),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Arrow / Selection Indicator
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: isSelected ? const Color(0xFF003A26) : const Color(0xFFF3F6F4),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          isSelected ? Icons.check_rounded : Icons.arrow_forward_ios_rounded,
                                          size: 13,
                                          color: isSelected ? Colors.white : const Color(0xFF5F6F67),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSelectModel(DeviceModel model) {
    setState(() => _selectedModelId = model.id);
    ref.read(bookingFlowProvider.notifier).selectModel(model.id, model.name);
    Future.delayed(const Duration(milliseconds: 160), () {
      if (mounted) context.push('/select-repairs');
    });
  }
}
