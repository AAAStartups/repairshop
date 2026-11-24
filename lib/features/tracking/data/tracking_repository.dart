import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';

final trackingRepositoryProvider = Provider<TrackingRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return TrackingRepository(client);
});

final orderTrackingProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, orderId) async {
  final repo = ref.watch(trackingRepositoryProvider);
  return repo.fetchOrderTracking(orderId);
});

class TrackingRepository {
  final ApiClient _client;

  TrackingRepository(this._client);

  Future<Map<String, dynamic>?> fetchOrderTracking(String orderId) async {
    try {
      final res = await _client.get(ApiEndpoints.trackOrder(orderId));
      if (res.statusCode == 200 && res.data['success'] == true) {
        return res.data['order'] as Map<String, dynamic>?;
      }
    } catch (_) {}
    return null;
  }

  Future<bool> advanceStage(String orderId) async {
    try {
      final res = await _client.post(ApiEndpoints.advanceOrderStage(orderId));
      return res.statusCode == 200 && res.data['success'] == true;
    } catch (_) {
      return false;
    }
  }
}
