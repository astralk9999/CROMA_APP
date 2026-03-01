import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../shared/models/profile.dart';

part 'profile_provider.g.dart';

@riverpod
Future<Profile?> userProfile(Ref ref) async {
  final user = SupabaseService.client.auth.currentUser;
  if (user == null) return null;

  final data = await SupabaseService.client
      .from('profiles')
      .select()
      .eq('id', user.id)
      .single();

  return Profile.fromJson(data);
}
