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

final popularRepairsProvider = FutureProvider<List<RepairServiceModel>>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.fetchPopularRepairs();
});

class CatalogRepository {
  final ApiClient _client;

  CatalogRepository(this._client);

  /// Fetch Brands dynamically from live REST API
  Future<List<BrandModel>> fetchBrands() async {
    try {
      final res = await _client.get(ApiEndpoints.brands);
      if (res.statusCode == 200 && res.data['success'] == true) {
        final List<dynamic> list = res.data['brands'] ?? [];
        return list.map((b) {
          final slug = (b['slug'] ?? '').toString().toLowerCase();
          final name = b['name'] ?? '';
          final isXiaomi = slug == 'xiaomi' || name.toLowerCase().contains('xiaomi');
          return BrandModel(
            id: slug.isNotEmpty ? slug : b['id'].toString(),
            name: name,
            subtitle: isXiaomi ? 'Redmi / Mi' : null,
            logoAsset: 'assets/brands/$slug.png',
            isPopular: (b['popularity'] ?? 0) >= 80,
          );
        }).toList();
      }
    } catch (e) {
      // Return empty list on network error
    }
    return [];
  }

  /// Fetch Models dynamically for a given brand from live REST API
  Future<List<DeviceModel>> fetchModels(String brandId, {String? series}) async {
    try {
      final res = await _client.get(
        ApiEndpoints.brandModels(brandId),
        queryParameters: series != null && series != 'All' ? {'series': series} : null,
      );
      if (res.statusCode == 200 && res.data['success'] == true) {
        final List<dynamic> list = res.data['models'] ?? [];
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
    } catch (e) {
      // Return empty list on network error
    }
    return [];
  }

  /// Fetch Repair Services dynamically for a specific device model from live REST API
  Future<List<RepairServiceModel>> fetchRepairs(String modelId) async {
    try {
      final res = await _client.get(ApiEndpoints.modelRepairs(modelId));
      if (res.statusCode == 200 && res.data['success'] == true) {
        final List<dynamic> list = res.data['repairs'] ?? [];
        return list.map((r) {
          return RepairServiceModel(
            id: r['id'].toString(),
            name: r['title'] ?? '',
            description: r['description'] ?? '',
            category: r['category'],
            estimatedPrice: (r['price'] as num?)?.toDouble(),
            estimatedTime: '${(r['turnaroundMinutes'] ?? 120) ~/ 60} hrs',
            warrantyPeriod: '${(r['warrantyDays'] ?? 180) ~/ 30} months',
          );
        }).toList();
      }
    } catch (e) {
      // Return empty list on network error
    }
    return [];
  }

  /// Fetch Popular Repair Services dynamically from live REST API
  Future<List<RepairServiceModel>> fetchPopularRepairs() async {
    try {
      final res = await _client.get(ApiEndpoints.popularRepairs);
      if (res.statusCode == 200 && res.data['success'] == true) {
        final List<dynamic> list = res.data['repairs'] ?? [];
        return list.map((r) {
          return RepairServiceModel(
            id: r['id'].toString(),
            name: r['title'] ?? '',
            description: r['description'] ?? '',
            estimatedPrice: (r['price'] as num?)?.toDouble(),
            estimatedTime: '${(r['turnaroundMinutes'] ?? 120) ~/ 60} hrs',
            warrantyPeriod: '${(r['warrantyDays'] ?? 180) ~/ 30} months',
            category: r['category'],
            badge: r['badge'],
            mrp: (r['mrp'] as num?)?.toDouble(),
            discount: r['discount'],
            deviceName: r['device'],
          );
        }).toList();
      }
    } catch (e) {
      // Return empty list on network error
    }
    return [];
  }
}
