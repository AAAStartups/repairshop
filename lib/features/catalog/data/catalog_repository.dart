import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../domain/models/brand_model.dart';
import '../domain/models/device_model.dart';
import '../domain/models/repair_service_model.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CatalogRepository(apiClient);
});

final brandsListProvider = FutureProvider<List<BrandModel>>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.fetchBrands();
});

final deviceModelsListProvider = FutureProvider.family<List<DeviceModel>, String>((ref, brandId) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.fetchModels(brandId);
});

final repairServicesListProvider = FutureProvider.family<List<RepairServiceModel>, String>((ref, modelId) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.fetchRepairs(modelId);
});

class CatalogRepository {
  final ApiClient _client;

  CatalogRepository(this._client);

  /// Fetch Brands from API, with graceful offline fallback to mockBrands
  Future<List<BrandModel>> fetchBrands() async {
    try {
      final res = await _client.get(ApiEndpoints.brands);
      if (res.statusCode == 200 && res.data['success'] == true) {
        final List<dynamic> list = res.data['brands'] ?? [];
        if (list.isNotEmpty) {
          return list.map((b) {
            final slug = (b['slug'] ?? '').toString().toLowerCase();
            return BrandModel(
              id: slug.isNotEmpty ? slug : b['id'].toString(),
              name: b['name'] ?? '',
              logoEmoji: _getEmojiForBrand(b['name'] ?? ''),
              isPopular: (b['popularity'] ?? 0) >= 80,
            );
          }).toList();
        }
      }
    } catch (_) {
      // Offline fallback
    }
    return mockBrands;
  }

  /// Fetch Models for a given brand, with offline fallback
  Future<List<DeviceModel>> fetchModels(String brandId, {String? series}) async {
    try {
      final res = await _client.get(
        ApiEndpoints.brandModels(brandId),
        queryParameters: series != null && series != 'All' ? {'series': series} : null,
      );
      if (res.statusCode == 200 && res.data['success'] == true) {
        final List<dynamic> list = res.data['models'] ?? [];
        if (list.isNotEmpty) {
          return list.map((m) {
            return DeviceModel(
              id: m['id'].toString(),
              brandId: brandId,
              name: m['name'] ?? '',
              series: m['series'],
              imageUrl: m['imageUrl'],
              releaseYear: m['releaseYear'],
            );
          }).toList();
        }
      }
    } catch (_) {
      // Offline fallback
    }
    return mockDevicesByBrand[brandId] ?? [];
  }

  /// Fetch Repair Services for a specific device model, with offline fallback
  Future<List<RepairServiceModel>> fetchRepairs(String modelId) async {
    try {
      final res = await _client.get(ApiEndpoints.modelRepairs(modelId));
      if (res.statusCode == 200 && res.data['success'] == true) {
        final List<dynamic> list = res.data['repairs'] ?? [];
        if (list.isNotEmpty) {
          return list.map((r) {
            return RepairServiceModel(
              id: r['id'].toString(),
              name: r['title'] ?? '',
              description: r['description'] ?? '',
              iconEmoji: _getEmojiForCategory(r['category'] ?? ''),
              estimatedPrice: (r['price'] as num?)?.toDouble(),
              estimatedTime: '${(r['turnaroundMinutes'] ?? 120) ~/ 60} hrs',
              warrantyPeriod: '${(r['warrantyDays'] ?? 180) ~/ 30} months',
            );
          }).toList();
        }
      }
    } catch (_) {
      // Offline fallback
    }
    return mockRepairServices;
  }

  String _getEmojiForBrand(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('apple')) return '🍎';
    if (lower.contains('samsung')) return '📱';
    if (lower.contains('oneplus')) return '🔴';
    if (lower.contains('xiaomi')) return '⬛';
    if (lower.contains('pixel')) return '🌈';
    if (lower.contains('vivo')) return '💙';
    if (lower.contains('realme')) return '⚡';
    if (lower.contains('nothing')) return '⚪';
    return '📲';
  }

  String _getEmojiForCategory(String cat) {
    switch (cat.toUpperCase()) {
      case 'SCREEN':
        return '📱';
      case 'BATTERY':
        return '🔋';
      case 'CHARGING':
        return '⚡';
      case 'CAMERA':
        return '📸';
      case 'BACK_GLASS':
        return '🪟';
      case 'WATER_DAMAGE':
        return '💧';
      default:
        return '🔧';
    }
  }
}
