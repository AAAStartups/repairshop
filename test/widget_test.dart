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

    test('BrandModel constructs correctly with properties', () {
      const brand = BrandModel(
        id: 'apple',
        name: 'Apple',
        logoAsset: 'assets/brands/apple.png',
        isPopular: true,
      );
      expect(brand.id, 'apple');
      expect(brand.name, 'Apple');
      expect(brand.assetPath, 'assets/brands/apple.png');
    });

    test('RepairServiceModel formats price display correctly', () {
      const repair = RepairServiceModel(
        id: 'screen_replacement',
        name: 'Screen Replacement',
        description: 'Cracked display',
        iconEmoji: '📱',
        estimatedPrice: 2499,
      );
      expect(repair.priceDisplay, '₹2499');
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
