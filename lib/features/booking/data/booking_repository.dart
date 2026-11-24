import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../domain/models/booking_draft.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return BookingRepository(client);
});

class BookingResult {
  final bool isSuccess;
  final String bookingNumber;
  final String? message;
  final double totalAmount;

  const BookingResult({
    required this.isSuccess,
    required this.bookingNumber,
    this.message,
    required this.totalAmount,
  });
}

class BookingRepository {
  final ApiClient _client;

  BookingRepository(this._client);

  Future<BookingResult> submitBooking(BookingDraft draft) async {
    try {
      final payload = {
        'deviceModelId': draft.modelId ?? 'model-default',
        'repairServiceIds': draft.selectedServiceIds.isNotEmpty
            ? draft.selectedServiceIds
            : ['screen_replacement'],
        'problemNotes': draft.problemDescription,
        'scheduledDate': (draft.pickupDate ?? DateTime.now().add(const Duration(days: 1)))
            .toIso8601String(),
        'timeSlot': draft.pickupTimeSlot ?? '10:00 AM - 12:00 PM',
        'address': {
          'label': draft.addressType ?? 'Home',
          'addressLine1': '${draft.flatNo ?? ''} ${draft.streetAddress ?? ''}'.trim(),
          'addressLine2': draft.landmark,
          'city': draft.city ?? 'Bengaluru',
          'state': 'Karnataka',
          'postalCode': draft.pincode ?? '560103',
        },
      };

      final res = await _client.post(ApiEndpoints.bookings, data: payload);
      if (res.statusCode == 201 && res.data['success'] == true) {
        final bookingData = res.data['booking'];
        return BookingResult(
          isSuccess: true,
          bookingNumber: bookingData['bookingNumber'] ?? 'QF-2026-9021',
          totalAmount: (bookingData['totalAmount'] as num?)?.toDouble() ?? draft.estimatedCost,
          message: res.data['message'],
        );
      }
    } catch (e) {
      return BookingResult(
        isSuccess: false,
        bookingNumber: '',
        totalAmount: draft.estimatedCost,
        message: 'Network error: Unable to connect to QuickFix server.',
      );
    }

    return BookingResult(
      isSuccess: false,
      bookingNumber: '',
      totalAmount: draft.estimatedCost,
      message: 'Failed to confirm booking.',
    );
  }

  Future<List<Map<String, dynamic>>> fetchUserBookings() async {
    try {
      final res = await _client.get(ApiEndpoints.bookings);
      if (res.statusCode == 200 && res.data['success'] == true) {
        final List<dynamic> list = res.data['bookings'] ?? [];
        return list.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }
}
