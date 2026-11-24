import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_endpoints.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

class ApiClient {
  late final Dio _dio;

  ApiClient({String? customBaseUrl}) {
    String baseUrl = customBaseUrl ?? ApiEndpoints.defaultBaseUrl;

    if (kIsWeb) {
      // On Web, default to production cloud backend or relative /api
      baseUrl = customBaseUrl ?? 'https://backend-five-eta-72.vercel.app/api';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // In Android emulator, 10.0.2.2 accesses host machine localhost
      // When adb reverse is active, 127.0.0.1 also works on physical phone
      baseUrl = customBaseUrl ?? ApiEndpoints.defaultBaseUrl;
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('quickfix_jwt_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          debugPrint('[QuickFix API Error] ${e.requestOptions.method} ${e.requestOptions.uri}: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get<T>(path, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options);
  }
}
