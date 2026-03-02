import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  /// Admin client that bypasses RLS (use ONLY for testing/bypass)
  static final SupabaseClient _adminClient = SupabaseClient(
    AppConfig.supabaseUrl,
    AppConfig.supabaseServiceRoleKey,
  );

  static SupabaseClient get adminClient => _adminClient;

  // Helpers
  static bool get isAuthenticated => client.auth.currentSession != null;
  static User? get currentUser => client.auth.currentUser;
  static String? get currentToken => client.auth.currentSession?.accessToken;
}
