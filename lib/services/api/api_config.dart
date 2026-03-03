class ApiConfig {
  ApiConfig._();

  // Replace with your real API base URL.
  static const String baseUrl = 'https://karateschool-api.damwebserver.com/api';

  static const Duration connectTimeout = Duration(seconds: 30);

  static String url(String endpoint) => '$baseUrl$endpoint';

  static const String login = '/users/login';
  static const String signup = '/users/register';
  static const String forgotPassword = '/users/forgot-password';
  static const String verifyOtp = '/users/verify-otp';
  static const String resendOtp = '/users/resend-otp';
  static const String resetPassword = '/users/change-password';
}
