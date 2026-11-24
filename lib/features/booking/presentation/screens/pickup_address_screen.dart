import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/booking_flow_controller.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/widgets/qf_pressable.dart';
import '../../../../core/widgets/qf_step_indicator.dart';

class PickupAddressScreen extends ConsumerStatefulWidget {
  const PickupAddressScreen({super.key});

  @override
  ConsumerState<PickupAddressScreen> createState() => _PickupAddressScreenState();
}

class _PickupAddressScreenState extends ConsumerState<PickupAddressScreen> {
  final _flatCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();
  final _landmarkCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _addressType = 'Home';
  bool _isLocating = false;
  final _formKey = GlobalKey<FormState>();

  final List<String> _addressTypes = ['Home', 'Work', 'Other'];

  @override
  void initState() {
    super.initState();
    final draft = ref.read(bookingFlowProvider);
    if (draft.flatNo != null) _flatCtrl.text = draft.flatNo!;
    if (draft.streetAddress != null) _streetCtrl.text = draft.streetAddress!;
    if (draft.landmark != null) _landmarkCtrl.text = draft.landmark!;
    if (draft.city != null) _cityCtrl.text = draft.city!;
    if (draft.pincode != null) _pincodeCtrl.text = draft.pincode!;
    if (draft.contactPhone != null) _phoneCtrl.text = draft.contactPhone!;
    if (draft.addressType != null) _addressType = draft.addressType!;
  }

  @override
  void dispose() {
    _flatCtrl.dispose();
    _streetCtrl.dispose();
    _landmarkCtrl.dispose();
    _cityCtrl.dispose();
    _pincodeCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _detectLiveLocation() async {
    setState(() => _isLocating = true);
    final result = await QuickFixLocationService.getCurrentAddress();
    if (!mounted) return;
    setState(() => _isLocating = false);

    if (result.isSuccess) {
      setState(() {
        if (result.flatOrPremises != null && _flatCtrl.text.isEmpty) {
          _flatCtrl.text = result.flatOrPremises!;
        }
        if (result.street != null) {
          _streetCtrl.text = result.street!;
        }
        if (result.subLocality != null && _landmarkCtrl.text.isEmpty) {
          _landmarkCtrl.text = result.subLocality!;
        }
        if (result.city != null) {
          _cityCtrl.text = result.city!;
        }
        if (result.postalCode != null) {
          _pincodeCtrl.text = result.postalCode!;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFFEDB000), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '📍 Detected: ${result.subLocality ?? result.city} (${result.postalCode}) • ${result.hubName ?? 'Active Hub'}',
                  style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF003A26),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? 'Could not detect location. Please enter manually.'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  InputDecoration _inputDec(String label, String hint, IconData icon) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFF5F6F67),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          color: Color(0xFF94A3B8),
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF003A26), size: 19),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );

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
                          'Doorstep Pickup Address',
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
                          'Free doorstep pickup & return across all pin codes',
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
              title: 'Doorstep Address',
              subtitle: 'Technician Route',
            ),

            // --- FORM CONTENT ---
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Auto-Detect Location Card
                    QFPressable(
                      onTap: _isLocating ? null : _detectLiveLocation,
                      pressedScale: 0.96,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF003A26).withValues(alpha: 0.08),
                              const Color(0xFFEDB000).withValues(alpha: 0.12),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFF003A26).withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFF003A26),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: _isLocating
                                  ? const Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Color(0xFFEDB000),
                                        ),
                                      ),
                                    )
                                  : const Icon(Icons.my_location_rounded, color: Color(0xFFEDB000), size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _isLocating ? 'Acquiring GPS Fix...' : 'Use Current GPS Location',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF003A26),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _isLocating
                                        ? 'Locking satellite coordinates and postal pincode'
                                        : 'Detect coordinates for precise technician dispatch',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11.5,
                                      color: Color(0xFF5F6F67),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!_isLocating)
                              const Icon(Icons.chevron_right_rounded, color: Color(0xFF003A26)),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Address Fields Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE8ECEA)),
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
                          const Text(
                            'Address Label',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF003A26),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: _addressTypes.map((type) {
                              final isActive = _addressType == type;
                              return QFPressable(
                                onTap: () => setState(() => _addressType = type),
                                pressedScale: 0.94,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isActive ? const Color(0xFF003A26) : const Color(0xFFF4F6F5),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isActive ? const Color(0xFF003A26) : const Color(0xFFE8ECEA),
                                    ),
                                  ),
                                  child: Text(
                                    type,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: isActive ? Colors.white : const Color(0xFF5F6F67),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _flatCtrl,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF003A26),
                            ),
                            decoration: _inputDec(
                              'Flat / Building / House No. *',
                              'e.g. Flat 304, Emerald Heights',
                              Icons.home_work_outlined,
                            ),
                            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _streetCtrl,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF003A26),
                            ),
                            decoration: _inputDec(
                              'Street & Area *',
                              'e.g. 12th Main, 4th Cross, Indiranagar',
                              Icons.location_on_outlined,
                            ),
                            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _landmarkCtrl,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF003A26),
                            ),
                            decoration: _inputDec(
                              'Nearby Landmark (Optional)',
                              'e.g. Opposite Metro Pillar 42',
                              Icons.place_outlined,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _cityCtrl,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF003A26),
                                  ),
                                  decoration: _inputDec(
                                    'City *',
                                    'Bangalore',
                                    Icons.location_city_outlined,
                                  ),
                                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _pincodeCtrl,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF003A26),
                                  ),
                                  decoration: _inputDec(
                                    'Pincode *',
                                    '560038',
                                    Icons.pin_drop_outlined,
                                  ),
                                  validator: (v) => (v == null || v.length != 6) ? '6 digits required' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _phoneCtrl,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF003A26),
                            ),
                            decoration: _inputDec(
                              'Pickup Contact Number *',
                              '9876543210',
                              Icons.phone_android_rounded,
                            ),
                            validator: (v) => (v == null || v.length < 10) ? 'Enter valid 10-digit number' : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
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
                  if (_formKey.currentState!.validate()) {
                    ref.read(bookingFlowProvider.notifier).updateAddress(
                          flatNo: _flatCtrl.text,
                          streetAddress: _streetCtrl.text,
                          landmark: _landmarkCtrl.text,
                          city: _cityCtrl.text,
                          pincode: _pincodeCtrl.text,
                          contactPhone: _phoneCtrl.text,
                          addressType: _addressType,
                        );
                    context.push('/pickup-slot');
                  }
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
                          'Continue to Slot Selection',
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
