import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/models/product.dart';
import '../../../core/services/supabase_service.dart';

const _kFavoritesKey = 'favorite_product_ids';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({}) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_kFavoritesKey) ?? [];
    state = ids.toSet();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kFavoritesKey, state.toList());
  }

  bool isFavorite(String productId) => state.contains(productId);

  Future<void> toggle(String productId) async {
    if (state.contains(productId)) {
      state = {...state}..remove(productId);
    } else {
      state = {...state, productId};
    }
    await _save();
  }

  Future<void> remove(String productId) async {
    state = {...state}..remove(productId);
    await _save();
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
