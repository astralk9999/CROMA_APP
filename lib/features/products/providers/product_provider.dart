import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:croma_app/core/services/supabase_service.dart';
import 'package:croma_app/shared/models/product.dart';
import 'package:croma_app/features/products/providers/filter_provider.dart';

part 'product_provider.g.dart';

@riverpod
Future<List<Product>> featuredProducts(Ref ref) async {
  final response = await SupabaseService.client
      .from('products')
      .select()
      .eq('featured', true)
      .limit(4);

  return (response as List).map((json) => Product.fromJson(json)).toList();
}

@riverpod
Future<List<Product>> productsByCategory(Ref ref, String categorySlug) async {
  final filters = ref.watch(productFiltersProvider);

  // Base Query
  var query = SupabaseService.client.from('products').select();

  // 1. Handle Special Slugs (Specials Section from Web)
  if (categorySlug == 'viral-trends') {
    query = query.eq('featured', true);
  } else if (categorySlug == 'sale') {
    query = query.lt('price', 50);
  } else if (categorySlug == 'bestsellers') {
    // Combine featured or low stock logic from web
    query = query.or('featured.eq.true,stock.lt.20');
  } else if (categorySlug != 'all') {
    // 2. Standard Category Filter
    final categoryResponse = await SupabaseService.client
        .from('categories')
        .select('id')
        .eq('slug', categorySlug)
        .maybeSingle();

    if (categoryResponse != null) {
      query = query.eq('category_id', categoryResponse['id']);
    }
  }

  // 3. Apply Active Filters (Taxonomy)
  // Note: These filters in web are often handled by navigating to /brand/[slug] etc.
  // In the mobile app, we apply them to the current grid.
  if (filters.brand != null) {
    query = query.ilike('brand', '%${filters.brand}%');
  }

  if (filters.maxPrice != null) {
    query = query.lte('price', filters.maxPrice!);
  }

  // Execute
  final response = await query.order('created_at', ascending: false);

  return (response as List).map((json) => Product.fromJson(json)).toList();
}

@riverpod
Future<Product?> productBySlug(Ref ref, String slug) async {
  final response = await SupabaseService.client
      .from('products')
      .select()
      .eq('slug', slug)
      .maybeSingle();

  if (response == null) return null;
  return Product.fromJson(response);
}

@riverpod
Future<List<Product>> allProducts(Ref ref) async {
  final response = await SupabaseService.client.from('products').select();

  return (response as List).map((json) => Product.fromJson(json)).toList();
}

@riverpod
Future<List<Product>> searchProducts(Ref ref, String query) async {
  if (query.trim().length < 2) return [];

  try {
    final response = await SupabaseService.client
        .from('products')
        .select()
        .or('name.ilike.%$query%,description.ilike.%$query%')
        .order('created_at', ascending: false);

    return (response as List).map((json) => Product.fromJson(json)).toList();
  } catch (e) {
    // debugPrint('Search error: $e');
    return [];
  }
}
