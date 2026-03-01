import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/models/category.dart';

part 'shop_repository.g.dart';

class ShopRepository {
  final _client = SupabaseService.client;

  Future<List<Product>> getProducts({
    String? categoryId,
    String? brand,
    String? color,
    bool? isLimitedDrop,
    bool? hasDiscount,
    bool? isViralTrend,
    bool? isBestseller,
    bool? featured,
    String sortBy = 'created_at',
    bool sortAsc = false,
    int page = 0,
    int pageSize = 20,
  }) async {
    var request = _client.from('products').select().eq('is_hidden', false);

    if (categoryId != null && categoryId.isNotEmpty) {
      request = request.eq('category_id', categoryId);
    }
    if (featured != null) {
      request = request.eq('featured', featured);
    }
    if (brand != null && brand.isNotEmpty) {
      request = request.ilike('brand', '%$brand%');
    }
    if (isLimitedDrop == true) {
      request = request.eq('is_limited_drop', true);
    }
    if (hasDiscount == true) {
      request = request.eq('discount_active', true);
    }
    if (isViralTrend == true) {
      request = request.eq('is_viral_trend', true);
    }
    if (isBestseller == true) {
      request = request.eq('is_bestseller', true);
    }

    final from = page * pageSize;
    final to = from + pageSize - 1;

    final data = await request
        .order(sortBy, ascending: sortAsc)
        .range(from, to);

    List<Product> products = (data as List).map((e) => Product.fromJson(e)).toList();

    // Client-side color filter (colors is an array column)
    if (color != null && color.isNotEmpty) {
      products = products.where((p) =>
          p.colors.any((c) => c.toLowerCase().contains(color.toLowerCase()))).toList();
    }

    return products;
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
