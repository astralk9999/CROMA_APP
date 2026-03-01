import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get supabaseUrl => dotenv.env['PUBLIC_SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey =>
      dotenv.env['PUBLIC_SUPABASE_ANON_KEY'] ?? '';
  static String get cloudinaryCloudName =>
      dotenv.env['PUBLIC_CLOUDINARY_CLOUD_NAME'] ?? '';
  static String get cloudinaryPreset =>
      dotenv.env['PUBLIC_CLOUDINARY_PRESET'] ?? '';
  static String get stripePublishableKey =>
      dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  static String get apiUrl =>
      dotenv.env['API_URL'] ?? 'http://10.0.2.2:4321/api';

  static Future<void> init() async {
    await dotenv.load(fileName: "assets/.env");
  }
}
