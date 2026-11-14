import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/booking_flow_controller.dart';
import '../../../../core/widgets/qf_step_indicator.dart';

class ProblemDescriptionScreen extends ConsumerStatefulWidget {
  const ProblemDescriptionScreen({super.key});

  @override
  ConsumerState<ProblemDescriptionScreen> createState() => _ProblemDescriptionScreenState();
}

class _ProblemDescriptionScreenState extends ConsumerState<ProblemDescriptionScreen> {
  final _controller = TextEditingController();
  final List<String> _photos = [];

  final List<Map<String, String>> _quickTips = [
    {'emoji': '📱', 'text': 'Screen cracked after drop'},
    {'emoji': '🔋', 'text': 'Battery draining abnormally fast'},
    {'emoji': '🌊', 'text': 'Accidental liquid spill / water'},
    {'emoji': '🔌', 'text': 'Loose cable or slow charge'},
    {'emoji': '🔇', 'text': 'Earpiece volume is extremely low'},
    {'emoji': '📷', 'text': 'Back camera focus shaking / blurry'},
  ];

  @override
  void initState() {
    super.initState();
    final draft = ref.read(bookingFlowProvider);
    if (draft.problemDescription != null) {
      _controller.text = draft.problemDescription!;
    }
    if (draft.issuePhotoPaths.isNotEmpty) {
      _photos.addAll(draft.issuePhotoPaths);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            decoration: BoxDecoration(color: const Color(0xFFE8ECEA), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF003A26)),
          ),
        ),
        title: const Text(
          'Describe Problem',
          style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF003A26)),
        ),
      ),
      body: Column(
        children: [
          QFStepIndicator(
            currentStep: 3,
            totalSteps: 5,
            title: 'Issue Description',
            subtitle: 'Diagnostic Notes',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(18),
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFD1D9D6).withValues(alpha: 0.8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.bolt_rounded, size: 16, color: Color(0xFFEDB000)),
                          SizedBox(width: 6),
                          Text(
                            'One-Tap Quick Select',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF003A26), letterSpacing: 0.3),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _quickTips.map((tip) {
                          return GestureDetector(
                            onTap: () {
                              if (_controller.text.isEmpty) {
                                _controller.text = tip['text']!;
                              } else {
                                _controller.text = '${_controller.text}, ${tip['text']}';
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F6F4),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFD1D9D6)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(tip['emoji']!, style: const TextStyle(fontSize: 14)),
                                  const SizedBox(width: 6),
                                  Text(
                                    tip['text']!,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF003A26),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 18),
                      const Divider(color: Color(0xFFE8ECEA)),
                      const SizedBox(height: 14),
                      const Text(
                        'Detailed Symptoms (Optional)',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF003A26)),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _controller,
                        maxLines: 4,
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF003A26)),
                        decoration: InputDecoration(
                          hintText: 'e.g. Phone touched water yesterday, now speaker is cracking and heating up near top...',
                          hintStyle: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: Color(0xFF5F6F67)),
                          filled: true,
                          fillColor: const Color(0xFFF3F6F4),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.all(14),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFD1D9D6).withValues(alpha: 0.8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Attach Device Photos',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF003A26)),
                          ),
                          Text(
                            'Up to 4 images',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF5F6F67)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Helps technician prepare spare parts beforehand',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Color(0xFF5F6F67)),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Camera & gallery attachment preview attached'),
                                  backgroundColor: Color(0xFF003A26),
                                ),
                              );
                            },
                            child: Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F6F4),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF003A26).withValues(alpha: 0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.add_photo_alternate_outlined, color: Color(0xFF003A26), size: 26),
                                  SizedBox(height: 4),
                                  Text('Add Photo', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF003A26))),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
            color: Colors.white,
            child: GestureDetector(
              onTap: () {
                ref.read(bookingFlowProvider.notifier).updateProblemDetails(
                  description: _controller.text,
                  photos: _photos,
                );
                context.push('/pickup-address');
              },
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF003A26),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF003A26).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Continue to Address',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
