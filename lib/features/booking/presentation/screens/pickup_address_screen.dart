import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/booking_flow_controller.dart';
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

  InputDecoration _inputDec(String label, String hint, IconData icon) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF5F6F67)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hint,
        hintStyle: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: Color(0xFF94A3B8)),
        prefixIcon: Icon(icon, color: const Color(0xFF003A26), size: 20),
        filled: true,
        fillColor: const Color(0xFFF3F6F4),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF003A26), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      );

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
          'Pickup Address',
          style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF003A26)),
        ),
      ),
      body: Column(
        children: [
          QFStepIndicator(
            currentStep: 4,
            totalSteps: 5,
            title: 'Doorstep Address',
            subtitle: 'Technician Route',
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(18),
                physics: const BouncingScrollPhysics(),
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _cityCtrl.text = 'Bangalore';
                        _pincodeCtrl.text = '560038';
                        _streetCtrl.text = '100ft Road, Indiranagar';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('📍 Location updated: Indiranagar, Bangalore 560038'),
                          backgroundColor: Color(0xFF003A26),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF003A26).withValues(alpha: 0.08),
                            const Color(0xFFEDB000).withValues(alpha: 0.12),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF003A26).withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFF003A26),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.my_location_rounded, color: Color(0xFFEDB000), size: 22),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Use Current Location', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF003A26))),
                                Text('Detect current GPS coordinates accurately', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Color(0xFF5F6F67))),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: Color(0xFF003A26)),
                        ],
                      ),
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
                        const Text('Address Tag', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF003A26))),
                        const SizedBox(height: 10),
                        Row(
                          children: _addressTypes.map((type) {
                            final isActive = _addressType == type;
                            return GestureDetector(
                              onTap: () => setState(() => _addressType = type),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isActive ? const Color(0xFF003A26) : const Color(0xFFF3F6F4),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isActive ? const Color(0xFF003A26) : const Color(0xFFD1D9D6),
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
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF003A26)),
                          decoration: _inputDec('House / Flat / Building No. *', 'e.g. Flat 304, Emerald Heights', Icons.home_work_outlined),
                          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _streetCtrl,
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF003A26)),
                          decoration: _inputDec('Street & Area *', 'e.g. 12th Main, 4th Cross, Indiranagar', Icons.location_on_outlined),
                          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _landmarkCtrl,
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF003A26)),
                          decoration: _inputDec('Nearby Landmark (Optional)', 'e.g. Opposite Metro Pillar 42', Icons.place_outlined),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _cityCtrl,
                                style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF003A26)),
                                decoration: _inputDec('City *', 'e.g. Bangalore', Icons.location_city_outlined),
                                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _pincodeCtrl,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF003A26)),
                                decoration: _inputDec('Pincode *', '560038', Icons.pin_drop_outlined),
                                validator: (v) => (v == null || v.length != 6) ? '6 digits required' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF003A26)),
                          decoration: _inputDec('Pickup Contact Number *', '9876543210', Icons.phone_android_rounded),
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
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
            color: Colors.white,
            child: GestureDetector(
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
                        'Continue to Slot Selection',
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
