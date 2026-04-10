class ApiConfig {
  ApiConfig._();

  // Replace with your real API base URL.
  static const String baseUrl = 'https://karateschool-api.damwebserver.com/api';

  static const Duration connectTimeout = Duration(seconds: 30);

  static String url(String endpoint) => '$baseUrl$endpoint';

  /// Resolves a stored profile image path to an absolute URL (API may return a relative path).
  static String? absoluteMediaUrl(String? pathOrUrl) {
    final p = (pathOrUrl ?? '').trim();
    if (p.isEmpty) return null;
    if (p.startsWith('http://') || p.startsWith('https://')) return p;
    final base = Uri.parse(baseUrl);
    final origin =
        '${base.scheme}://${base.host}${base.hasPort ? ':${base.port}' : ''}';
    if (p.startsWith('/')) return '$origin$p';
    return '$origin/$p';
  }

  static const String login = '/users/login';
  static const String signup = '/users/register';
  static const String forgotPassword = '/users/forgot-password';
  static const String verifyOtp = '/users/verify-otp';
  static const String resendOtp = '/users/resend-otp';
  static const String resetPassword = '/users/change-password';
  static const String updateProfile = '/users/profile';

  static const String faq = '/faq';

  static const String contactsCreate = '/contacts/create';

  static const String videoOfTheWeek = '/lessons/video-of-the-week';

  /// Lessons for a belt, e.g. belt `1` → `/lessons/belt/1`.
  static String lessonsBelt(int beltId) => '/lessons/belt/$beltId';

  /// Plan lessons preview, e.g. plan `1` → `/plans/1/level`.
  static String planLevel(int planId) => '/plans/$planId/level';

  /// CMS page by slug, e.g. `term` → `/pages/term`.
  static String pageBySlug(String slug) => '/pages/$slug';
}
