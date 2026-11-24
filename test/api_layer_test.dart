import 'package:flutter_test/flutter_test.dart';
import 'package:quickfix/core/network/api_client.dart';
import 'package:quickfix/core/services/location_service.dart';
import 'package:quickfix/features/catalog/data/catalog_repository.dart';
import 'package:quickfix/features/booking/data/booking_repository.dart';
import 'package:quickfix/features/booking/domain/models/booking_draft.dart';
import 'package:quickfix/features/tracking/data/tracking_repository.dart';

void main() {
  group('QuickFix API Layer & Repository Tests', () {
    test('CatalogRepository handles offline error and returns empty list', () async {
      final client = ApiClient(customBaseUrl: 'http://localhost:59999/api'); // unreachable
      final repo = CatalogRepository(client);

      final brands = await repo.fetchBrands();
      expect(brands, isEmpty);
    });

    test('BookingRepository handles offline network error safely', () async {
      final client = ApiClient(customBaseUrl: 'http://localhost:59999/api'); // unreachable
      final repo = BookingRepository(client);

      const draft = BookingDraft(
        brandId: 'apple',
        brandName: 'Apple',
        modelId: 'iphone15pro',
        modelName: 'iPhone 15 Pro',
        selectedServiceIds: ['screen_replacement'],
        estimatedCost: 3899.0,
        flatNo: '#402',
        streetAddress: 'Green Glen Layout',
        city: 'Bengaluru',
        pincode: '560103',
        pickupTimeSlot: '10:00 AM - 12:00 PM',
      );

      final result = await repo.submitBooking(draft);
      expect(result.isSuccess, isFalse);
    });

    test('QuickFixLocationResult constructs address text correctly', () {
      const loc = QuickFixLocationResult(
        isSuccess: true,
        street: '100 Feet Road',
        subLocality: 'Indiranagar',
        city: 'Bengaluru',
        postalCode: '560038',
      );
      expect(loc.fullAddressText, equals('100 Feet Road, Indiranagar, Bengaluru, 560038'));
      expect(loc.isServiceable, isTrue);
    });

    test('TrackingRepository handles offline track calls gracefully', () async {
      final client = ApiClient(customBaseUrl: 'http://localhost:59999/api'); // unreachable
      final repo = TrackingRepository(client);

      final tracking = await repo.fetchOrderTracking('QF-89421');
      expect(tracking, isNull);

      final advanced = await repo.advanceStage('QF-89421');
      expect(advanced, isFalse);
    });
  });
}
