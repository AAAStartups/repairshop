import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/booking_draft.dart';

class BookingFlowController extends StateNotifier<BookingDraft> {
  BookingFlowController() : super(const BookingDraft());

  void selectBrand(String id, String name) {
    // Reset downstream selections when brand changes
    state = BookingDraft(brandId: id, brandName: name);
  }

  void selectModel(String id, String name) {
    // Reset services when model changes
    state = state.copyWith(
      modelId: id,
      modelName: name,
      selectedServiceIds: [],
      selectedServiceNames: [],
      estimatedCost: 0,
    );
  }

  void toggleService(String serviceId, String serviceName, double cost) {
    final ids = List<String>.from(state.selectedServiceIds);
    final names = List<String>.from(state.selectedServiceNames);
    double newCost = state.estimatedCost;

    if (ids.contains(serviceId)) {
      ids.remove(serviceId);
      names.remove(serviceName);
      newCost = (newCost - cost).clamp(0, double.infinity);
    } else {
      ids.add(serviceId);
      names.add(serviceName);
      newCost += cost;
    }

    state = state.copyWith(
      selectedServiceIds: ids,
      selectedServiceNames: names,
      estimatedCost: newCost,
    );
  }

  void updateProblemDetails({
    required String description,
    required List<String> photos,
  }) {
    state = state.copyWith(
      problemDescription: description,
      issuePhotoPaths: photos,
    );
  }

  void updateAddress({
    String? flatNo,
    String? streetAddress,
    String? landmark,
    String? city,
    String? pincode,
    String? contactPhone,
    String? addressType,
  }) {
    state = state.copyWith(
      flatNo: flatNo,
      streetAddress: streetAddress,
      landmark: landmark,
      city: city,
      pincode: pincode,
      contactPhone: contactPhone,
      addressType: addressType,
    );
  }

  void updateSchedule({required DateTime date, required String slot}) {
    state = state.copyWith(pickupDate: date, pickupTimeSlot: slot);
  }

  void resetDraft() {
    state = const BookingDraft();
  }
}

final bookingFlowProvider =
    StateNotifierProvider<BookingFlowController, BookingDraft>((ref) {
  return BookingFlowController();
});
