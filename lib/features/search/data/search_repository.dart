import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../shared/models/product.dart';

part 'search_repository.g.dart';

class SearchRepository {
  final _client = SupabaseService.client;

  Future<List<Product>> searchProducts({
    String? query,
    String? categoryId,
    String? color,
    String? brand,
    int page = 0,
    int pageSize = 20,
  }) async {
    var request = _client.from('products').select().eq('is_hidden', false);

    if (query != null && query.isNotEmpty) {
      request = request.or('name.ilike.%$query%,brand.ilike.%$query%,description.ilike.%$query%');
    }
    if (categoryId != null && categoryId.isNotEmpty) {
      request = request.eq('category_id', categoryId);
    }
    if (brand != null && brand.isNotEmpty) {
      request = request.ilike('brand', '%$brand%');
    }

    final from = page * pageSize;
    final to = from + pageSize - 1;

    final data = await request
        .order('created_at', ascending: false)
        .range(from, to);

    List<Product> products = (data as List).map((e) => Product.fromJson(e)).toList();

    // Client-side color filter (since colors is an array column)
    if (color != null && color.isNotEmpty) {
      products = products.where((p) =>
          p.colors.any((c) => c.toLowerCase().contains(color.toLowerCase()))).toList();
    }

    return products;
  }

  Future<List<String>> getAvailableBrands() async {
    final data = await _client
        .from('products')
        .select('brand')
        .eq('is_hidden', false)
        .not('brand', 'is', null);
    final brands = (data as List)
        .map((e) => e['brand'] as String?)
        .where((b) => b != null && b.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();
    brands.sort();
    return brands;
  }

  Future<List<String>> getAvailableColors() async {
    final data = await _client
        .from('products')
        .select('colors')
        .eq('is_hidden', false);
    final colors = <String>{};
    for (final row in (data as List)) {
      final c = row['colors'];
      if (c is List) {
        for (final color in c) {
          if (color is String && color.isNotEmpty) {
            colors.add(color);
          }
        }
      }
    }
    final sorted = colors.toList()..sort();
    return sorted;
  }
}

@riverpod
SearchRepository searchRepository(Ref ref) {
  return SearchRepository();
}

@riverpod
Future<List<String>> availableBrands(Ref ref) {
  return ref.read(searchRepositoryProvider).getAvailableBrands();
}

@riverpod
Future<List<String>> availableColors(Ref ref) {
  return ref.read(searchRepositoryProvider).getAvailableColors();
}
