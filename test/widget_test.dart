import 'package:flutter_test/flutter_test.dart';
import 'package:quickfix/core/constants/app_colors.dart';
import 'package:quickfix/features/catalog/domain/models/brand_model.dart';
import 'package:quickfix/features/catalog/domain/models/repair_service_model.dart';
import 'package:quickfix/features/booking/domain/models/booking_draft.dart';

void main() {
  group('QuickFix Domain & Architecture Unit Tests', () {
    test('Verifies primary brand color palette tokens match specifications', () {
      expect(AppColors.primary.value, 0xFF003A26);
      expect(AppColors.accent.value, 0xFFEDB000);
      expect(AppColors.darkSurface.value, 0xFF1F2D27);
      expect(AppColors.muted.value, 0xFF5F6F67);
      expect(AppColors.background.value, 0xFFE8ECEA);
    });

    test('Catalog brands data is loaded correctly', () {
      expect(mockBrands.length, greaterThanOrEqualTo(10));
      expect(mockBrands.any((b) => b.id == 'apple'), isTrue);
      expect(mockBrands.any((b) => b.id == 'samsung'), isTrue);
    });

    test('Repair service catalogue contains all key categories', () {
      expect(mockRepairServices.any((s) => s.id == 'screen_replacement'), isTrue);
      expect(mockRepairServices.any((s) => s.id == 'battery_replacement'), isTrue);
      expect(mockRepairServices.any((s) => s.id == 'charging_port'), isTrue);
    });

    test('Booking draft preserves state accurately', () {
      const draft = BookingDraft(
        brandId: 'apple',
        brandName: 'Apple',
        modelId: 'iphone17pro',
        modelName: 'iPhone 17 Pro',
        selectedServiceIds: ['screen_replacement'],
        estimatedCost: 2499.0,
      );

      final updatedDraft = draft.copyWith(
        contactPhone: '9876543210',
        flatNo: 'A-204',
        streetAddress: 'MG Road, Indiranagar',
      );

      expect(updatedDraft.brandName, 'Apple');
      expect(updatedDraft.modelName, 'iPhone 17 Pro');
      expect(updatedDraft.contactPhone, '9876543210');
      expect(updatedDraft.estimatedCost, 2499.0);
    });
  });
}
