import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../shared/models/product.dart';

part 'home_repository.g.dart';

class HomeRepository {
  final _client = SupabaseService.client;

  Future<List<Product>> getBestSellers() async {
    final data = await _client
        .from('products')
        .select()
        .eq('is_hidden', false)
        .eq('is_bestseller', true)
        .order('created_at', ascending: false)
        .limit(6);
    return (data as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<List<Product>> getViralTrends() async {
    final data = await _client
        .from('products')
        .select()
        .eq('is_hidden', false)
        .eq('is_viral_trend', true)
        .order('created_at', ascending: false)
        .limit(6);
    return (data as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<List<Product>> getLimitedDrops() async {
    final data = await _client
        .from('products')
        .select()
        .eq('is_hidden', false)
        .eq('is_limited_drop', true)
        .order('created_at', ascending: false)
        .limit(6);
    return (data as List).map((e) => Product.fromJson(e)).toList();
  }
}

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

@riverpod
Future<List<Product>> bestSellers(BestSellersRef ref) {
  return ref.read(homeRepositoryProvider).getBestSellers();
}

@riverpod
Future<List<Product>> viralTrends(ViralTrendsRef ref) {
  return ref.read(homeRepositoryProvider).getViralTrends();
}

@riverpod
Future<List<Product>> limitedDrops(LimitedDropsRef ref) {
  return ref.read(homeRepositoryProvider).getLimitedDrops();
}
