import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:croma_app/shared/models/product.dart';
import 'package:croma_app/features/products/providers/product_provider.dart';

part 'favorites_provider.g.dart';

@riverpod
class Favorites extends _$Favorites {
  @override
  Future<List<String>> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites') ?? [];
  }

  Future<void> toggleFavorite(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final current = state.value ?? [];

    List<String> updated;
    if (current.contains(productId)) {
      updated = [...current]..remove(productId);
    } else {
      updated = [...current, productId];
    }

    await prefs.setStringList('favorites', updated);
    state = AsyncData(updated);
  }

  bool isFavorite(String productId) {
    return state.value?.contains(productId) ?? false;
  }
}

@riverpod
List<Product> favoriteProducts(Ref ref) {
  final favoritesIds = ref.watch(favoritesProvider).valueOrNull ?? [];
  final allProducts = ref.watch(allProductsProvider).valueOrNull ?? [];

  if (favoritesIds.isEmpty || allProducts.isEmpty) return [];

  return allProducts.where((p) => favoritesIds.contains(p.id)).toList();
}
