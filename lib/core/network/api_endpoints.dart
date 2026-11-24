class ApiEndpoints {
  // Base API configuration
  // When running on physical device with 'adb reverse tcp:5000 tcp:5000', localhost:5000 connects to host PC.
  static const String defaultBaseUrl = 'http://127.0.0.1:5000/api';
  static const String emulatorBaseUrl = 'http://10.0.2.2:5000/api';

  // Endpoints
  static const String health = '/health';
  
  // Auth
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String me = '/auth/me';

  // Catalog
  static const String brands = '/catalog/brands';
  static const String popularRepairs = '/catalog/repairs/popular';
  static String brandModels(String brandId) => '/catalog/brands/$brandId/models';
  static String modelRepairs(String modelId) => '/catalog/models/$modelId/repairs';

  // Bookings & Orders
  static const String bookings = '/bookings';
  static String trackOrder(String orderId) => '/orders/$orderId/track';
  static String advanceOrderStage(String orderId) => '/orders/$orderId/advance-stage';
}
