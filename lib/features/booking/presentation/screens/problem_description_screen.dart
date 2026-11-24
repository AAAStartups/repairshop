import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../controllers/booking_flow_controller.dart';
import '../../../../core/widgets/qf_pressable.dart';
import '../../../../core/widgets/qf_step_indicator.dart';

class ProblemDescriptionScreen extends ConsumerStatefulWidget {
  const ProblemDescriptionScreen({super.key});

  @override
  ConsumerState<ProblemDescriptionScreen> createState() => _ProblemDescriptionScreenState();
}

class _ProblemDescriptionScreenState extends ConsumerState<ProblemDescriptionScreen> {
  final _controller = TextEditingController();
  final List<String> _photos = [];
  bool _isUploadingPhoto = false;

  final List<Map<String, dynamic>> _quickTips = [
    {'icon': Icons.smartphone_rounded, 'text': 'Screen cracked after drop'},
    {'icon': Icons.battery_alert_rounded, 'text': 'Battery draining abnormally fast'},
    {'icon': Icons.water_drop_rounded, 'text': 'Accidental liquid spill / water'},
    {'icon': Icons.power_rounded, 'text': 'Loose cable or slow charge'},
    {'icon': Icons.volume_off_rounded, 'text': 'Earpiece volume is extremely low'},
    {'icon': Icons.photo_camera_rounded, 'text': 'Back camera focus shaking / blurry'},
  ];

  Future<void> _pickAndUploadPhoto() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );

      if (image == null) return;

      setState(() => _isUploadingPhoto = true);

      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      final fileName = image.name.isNotEmpty ? image.name : 'diagnostic_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final client = ref.read(apiClientProvider);
      final res = await client.post(
        ApiEndpoints.storageUpload,
        data: {
          'fileName': fileName,
          'fileData': base64Image,
          'contentType': image.mimeType ?? 'image/jpeg',
        },
      );

      if (res.statusCode == 200 && res.data['success'] == true) {
        final publicUrl = res.data['url'] as String;
        setState(() {
          _photos.add(publicUrl);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: Color(0xFFEDB000), size: 18),
                  SizedBox(width: 8),
                  Text('Diagnostic photo uploaded to cloud storage!'),
                ],
              ),
              backgroundColor: Color(0xFF003A26),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        setState(() {
          _photos.add(image.path);
        });
      }
    } catch (e) {
      debugPrint('Photo upload error: $e');
    } finally {
      if (mounted) setState(() => _isUploadingPhoto = false);
    }
  }

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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Describe Symptoms',
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
                          'Help the assigned technician prepare exact parts',
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
              currentStep: 4,
              totalSteps: 5,
              title: 'Diagnostic Notes',
              subtitle: 'Symptoms & Photos',
            ),

            // --- CONTENT LIST ---
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                children: [
                  // One-Tap Quick Select Symptoms Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE8ECEA)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDB000).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.bolt_rounded, size: 16, color: Color(0xFF003A26)),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Common Symptoms (Tap to add)',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF003A26),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _quickTips.map((tip) {
                            return QFPressable(
                              onTap: () {
                                setState(() {
                                  final tipText = tip['text'] as String;
                                  if (_controller.text.isEmpty) {
                                    _controller.text = tipText;
                                  } else {
                                    _controller.text = '${_controller.text}, $tipText';
                                  }
                                });
                              },
                              pressedScale: 0.95,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F6F5),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE8ECEA)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      tip['icon'] as IconData,
                                      size: 15,
                                      color: const Color(0xFF003A26),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      tip['text'] as String,
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
                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFFE8ECEA)),
                        const SizedBox(height: 12),
                        const Text(
                          'Additional Technician Notes (Optional)',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF003A26),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _controller,
                          maxLines: 4,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF003A26),
                          ),
                          decoration: InputDecoration(
                            hintText: 'e.g. Phone touched water yesterday, now speaker is cracking and heating up near top...',
                            hintStyle: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.5,
                              color: Color(0xFF5F6F67),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF4F6F5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Color(0xFFE8ECEA)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Color(0xFFE8ECEA)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Color(0xFF003A26), width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.all(14),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Photos / Video Upload Container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE8ECEA)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Device Diagnostic Photos',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF003A26),
                              ),
                            ),
                            Text(
                              'Optional',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF5F6F67),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Upload photo of broken glass, dent, or charging port',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.5,
                            color: Color(0xFF5F6F67),
                          ),
                        ),
                        const SizedBox(height: 14),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ..._photos.asMap().entries.map((entry) {
                                final index = entry.key;
                                final url = entry.value;
                                return Stack(
                                  children: [
                                    Container(
                                      width: 76,
                                      height: 76,
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF4F6F5),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: const Color(0xFF003A26), width: 1.5),
                                        image: url.startsWith('http')
                                            ? DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)
                                            : null,
                                      ),
                                      child: !url.startsWith('http')
                                          ? const Center(child: Icon(Icons.photo_rounded, color: Color(0xFF003A26)))
                                          : null,
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 16,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() => _photos.removeAt(index));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              QFPressable(
                                onTap: _isUploadingPhoto ? null : _pickAndUploadPhoto,
                                pressedScale: 0.94,
                                child: Container(
                                  width: 76,
                                  height: 76,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF4F6F5),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFF003A26).withValues(alpha: 0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: _isUploadingPhoto
                                      ? const Center(
                                          child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF003A26)),
                                          ),
                                        )
                                      : const Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add_a_photo_outlined, color: Color(0xFF003A26), size: 24),
                                            SizedBox(height: 4),
                                            Text(
                                              'Add Photo',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF003A26),
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // --- BOTTOM CONTINUE ACTION BAR ---
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: QFPressable(
                onTap: () {
                  ref.read(bookingFlowProvider.notifier).updateProblemDetails(
                        description: _controller.text,
                        photos: _photos,
                      );
                  context.push('/pickup-address');
                },
                pressedScale: 0.96,
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF003A26),
                    borderRadius: BorderRadius.circular(16),
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
                        Text(
                          'Continue to Pickup Address',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
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
      ),
    );
  }
}
