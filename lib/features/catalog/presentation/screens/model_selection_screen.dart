import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../booking/presentation/controllers/booking_flow_controller.dart';
import '../../../../core/widgets/qf_step_indicator.dart';
import '../../domain/models/device_model.dart';

class ModelSelectionScreen extends ConsumerStatefulWidget {
  const ModelSelectionScreen({super.key});

  @override
  ConsumerState<ModelSelectionScreen> createState() => _ModelSelectionScreenState();
}

class _ModelSelectionScreenState extends ConsumerState<ModelSelectionScreen> {
  String _search = '';
  String? _selectedModelId;

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(bookingFlowProvider);
    final brandId = draft.brandId ?? 'apple';
    final brandName = draft.brandName ?? 'Apple';
    final models = mockDevicesByBrand[brandId] ?? [];

    final filtered = models
        .where((m) => m.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    final Map<String, List<DeviceModel>> grouped = {};
    for (final m in filtered) {
      final series = m.series ?? 'All Models';
      grouped.putIfAbsent(series, () => []).add(m);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFE8ECEA), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF003A26)),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Device Model',
              style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF003A26)),
            ),
            Text(
              brandName,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF5F6F67)),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          QFStepIndicator(
            currentStep: 2,
            totalSteps: 5,
            title: 'Choose Model',
            subtitle: 'Device Specifications',
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF003A26)),
              decoration: InputDecoration(
                hintText: 'Search $brandName model (e.g. Pro, Plus, Ultra)...',
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
            child: models.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('📱', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text(
                          'No models found for $brandName',
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF003A26)),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Try picking a different brand from the previous step',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Color(0xFF5F6F67)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: grouped.keys.length,
                    itemBuilder: (context, groupIndex) {
                      final series = grouped.keys.elementAt(groupIndex);
                      final seriesModels = grouped[series]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10, top: groupIndex == 0 ? 0 : 16),
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
                                    fontSize: 12,
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

                            return GestureDetector(
                              onTap: () {
                                setState(() => _selectedModelId = model.id);
                                ref.read(bookingFlowProvider.notifier).selectModel(model.id, model.name);
                                Future.delayed(const Duration(milliseconds: 150), () {
                                  if (context.mounted) context.push('/select-repairs');
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF003A26) : const Color(0xFFD1D9D6).withValues(alpha: 0.7),
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
                                        child: Text('📱', style: TextStyle(fontSize: isSelected ? 20 : 18)),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            model.name,
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF003A26),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              if (model.releaseYear != null) ...[
                                                Text(
                                                  '${model.releaseYear} Edition',
                                                  style: const TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF5F6F67),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                const Text('•', style: TextStyle(color: Color(0xFF5F6F67))),
                                                const SizedBox(width: 8),
                                              ],
                                              const Text(
                                                'All parts in stock',
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
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: isSelected ? const Color(0xFF003A26) : const Color(0xFFF3F6F4),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 12,
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
    );
  }
}
