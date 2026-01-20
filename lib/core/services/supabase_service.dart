import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._internal();
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;

  static final SupabaseClient client = Supabase.instance.client;

  // Auth wrappers
  static User? get currentUser => client.auth.currentUser;

  static Stream<AuthState> get authStateChanges =>
      client.auth.onAuthStateChange;

  static Future<AuthResponse> signInWithEmail(
    String email,
    String password,
  ) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<AuthResponse> signUpWithEmail(
    String email,
    String password,
    Map<String, dynamic> data,
  ) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }

  Future<bool> cancelOrder(String orderId) async {
    try {
      await client.rpc('cancel_order', params: {'p_order_id': orderId});
      // Web logic: if call succeeds, it's cancelled
      return true;
    } catch (e) {
      // debugPrint('Error cancelling order: $e');
      return false;
    }
  }
}
