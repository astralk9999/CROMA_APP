import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/models/product.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/services/auth_provider.dart';

const _kFavoritesKey = 'favorite_product_ids';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({}) {
    _load();
  }

  final _supabase = SupabaseService.client;

  Future<void> _load() async {
    // 1. Load from Local
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_kFavoritesKey) ?? [];
    state = ids.toSet();

    // 2. Sync with Remote if logged in
    await syncWithSupabase();
  }

  Future<void> syncWithSupabase() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      // Fetch remote
      final response = await _supabase
          .from('favorites')
          .select('product_id')
          .eq('user_id', user.id);
      
      final remoteIds = (response as List).map((e) => e['product_id'] as String).toSet();
      
      // Merge local and remote
      final merged = {...state, ...remoteIds};
      
      if (merged.length > state.length) {
        state = merged;
        await _save();
      }

      // If remote is missing some local ones, push them
      final missingRemotely = state.where((id) => !remoteIds.contains(id)).toList();
      if (missingRemotely.isNotEmpty) {
        await _supabase.from('favorites').upsert(
          missingRemotely.map((id) => {'user_id': user.id, 'product_id': id}).toList(),
        );
      }
    } catch (e) {
      print('Error syncing favorites: $e');
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kFavoritesKey, state.toList());
  }

  bool isFavorite(String productId) => state.contains(productId);

  Future<void> toggle(String productId) async {
    final isAdding = !state.contains(productId);
    
    if (isAdding) {
      state = {...state, productId};
    } else {
      state = {...state}..remove(productId);
    }
    await _save();

    // Remote sync
    final user = _supabase.auth.currentUser;
    if (user != null) {
      try {
        if (isAdding) {
          await _supabase.from('favorites').upsert({'user_id': user.id, 'product_id': productId});
        } else {
          await _supabase.from('favorites').delete().eq('user_id', user.id).eq('product_id', productId);
        }
      } catch (e) {
        print('Error toggling remote favorite: $e');
      }
    }
  }

  Future<void> remove(String productId) async {
    state = {...state}..remove(productId);
    await _save();

    final user = _supabase.auth.currentUser;
    if (user != null) {
      await _supabase.from('favorites').delete().eq('user_id', user.id).eq('product_id', productId);
    }
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});

final favoriteProductsProvider = FutureProvider<List<Product>>((ref) async {
  final ids = ref.watch(favoritesProvider);
  if (ids.isEmpty) return [];

  final client = SupabaseService.client;
  final data = await client
      .from('products')
      .select()
      .inFilter('id', ids.toList())
      .eq('is_hidden', false);
  return (data as List).map((e) => Product.fromJson(e)).toList();
});
