import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  User? build() {
    // Escuchar cambios de autenticación
    SupabaseService.client.auth.onAuthStateChange.listen((data) {
      if (state?.id != data.session?.user.id) {
        state = data.session?.user;
      }
    });

    return SupabaseService.currentUser;
  }

  Future<void> signIn(String email, String password) async {
    await SupabaseService.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp(String email, String password, String fullName) async {
    await SupabaseService.client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  Future<void> signOut() async {
    await SupabaseService.client.auth.signOut();
  }
}
