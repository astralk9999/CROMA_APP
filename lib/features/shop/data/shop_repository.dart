import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/models/category.dart';

part 'shop_repository.g.dart';

class ShopRepository {
  final _client = SupabaseService.client;

  Future<List<Product>> getProducts({
    String? categoryId,
    bool? featured,
  }) async {
    Map<String, Object> filters = {'is_hidden': false};
    
    if (categoryId != null && categoryId.isNotEmpty) {
      filters['category_id'] = categoryId;
    }
    if (featured != null) {
      filters['featured'] = featured;
    }

    final data = await _client.from('products').select().match(filters).order('created_at', ascending: false);
    return (data as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<Product> getProductBySlug(String slug) async {
    final data = await _client
        .from('products')
        .select()
        .eq('slug', slug)
        .eq('is_hidden', false)
        .single();
    return Product.fromJson(data);
  }

  Future<List<Category>> getCategories() async {
    final data = await _client.from('categories').select().order('name');
    return (data as List).map((e) => Category.fromJson(e)).toList();
  }
}

@riverpod
ShopRepository shopRepository(ShopRepositoryRef ref) {
  return ShopRepository();
}

@riverpod
Future<List<Product>> products(ProductsRef ref, {String? categoryId}) {
  return ref.read(shopRepositoryProvider).getProducts(categoryId: categoryId);
}

@riverpod
Future<Product> productDetail(ProductDetailRef ref, String slug) {
  return ref.read(shopRepositoryProvider).getProductBySlug(slug);
}

@riverpod
Future<List<Category>> categories(CategoriesRef ref) {
  return ref.read(shopRepositoryProvider).getCategories();
}
