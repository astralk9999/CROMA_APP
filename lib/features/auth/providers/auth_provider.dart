import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:croma_app/core/services/supabase_service.dart';

part 'auth_provider.g.dart';

@riverpod
Stream<User?> authSafe(Ref ref) {
  return SupabaseService.authStateChanges.map((event) => event.session?.user);
}

@riverpod
User? currentUser(Ref ref) {
  return ref.watch(authSafeProvider).valueOrNull;
}

@riverpod
bool isAuthenticated(Ref ref) {
  return ref.watch(currentUserProvider) != null;
}
