import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static Future<void> loadConfig() async {
    await dotenv.load(fileName: ".env");
  }

  static String get supabaseUrl => _getEnv('SUPABASE_URL');
  static String get supabaseAnonKey => _getEnv('SUPABASE_ANON_KEY');

  static String get cloudinaryCloudName => _getEnv('CLOUDINARY_CLOUD_NAME');

  static String get stripePublishableKey => _getEnv('STRIPE_PUBLISHABLE_KEY');

  static String get apiBaseUrl => _getEnv('API_BASE_URL');

  static String get guestUserId => _getEnv('GUEST_USER_ID');

  static String _getEnv(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw Exception('AppConfig: Missing environment variable -> $key');
    }
    return value;
  }
}
