import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/services/supabase_service.dart';

part 'admin_repository.g.dart';

class AdminRepository {
  final _client = SupabaseService.client;

  Future<Map<String, dynamic>> getDashboardMetrics() async {
    final productsRes = await _client.from('products').select('id');
    final ordersRes = await _client.from('orders').select('id, total_amount, status');
    final profilesRes = await _client.from('profiles').select('id');
    final newsletterRes = await _client.from('newsletter_subscribers').select('id');
    
    final ordersData = ordersRes as List;
    double totalRevenue = 0;
    int pendingOrders = 0;
    for (var o in ordersData) {
      if (o['status'] != 'cancelled') {
        totalRevenue += (o['total_amount'] as num).toDouble();
      }
      if (o['status'] == 'pending') {
        pendingOrders++;
      }
    }

    // Get stock alerts (simplified: sum of all sizes < 10)
    final allProducts = await _client.from('products').select('id, name, stock_by_sizes, images');
    int lowStockCount = 0;
    for (var p in allProducts) {
      final stockMap = p['stock_by_sizes'] as Map<String, dynamic>?;
      if (stockMap != null) {
        int totalStock = stockMap.values.fold(0, (sum, val) => sum + (val as int));
        if (totalStock < 10) lowStockCount++;
      }
    }

    return {
      'products': productsRes.length,
      'orders': ordersRes.length,
      'users': profilesRes.length,
      'revenue': totalRevenue,
      'pendingOrders': pendingOrders,
      'marketingReach': profilesRes.length + newsletterRes.length,
      'lowStockCount': lowStockCount,
    };
  }

  Future<List<Map<String, dynamic>>> getAdminProducts() async {
    final data = await _client
        .from('products')
        .select('*, categories(name)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<List<Map<String, dynamic>>> getAllAdminOrders() async {
    final data = await _client
        .from('orders')
        .select('*, profiles(full_name, email)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<List<Map<String, dynamic>>> getAllAdminUsers() async {
    final data = await _client
        .from('profiles')
        .select('*')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> updateOrderStatus(String id, String status) async {
    // 1. Update status
    await _client.from('orders').update({'status': status}).eq('id', id);

    // 2. If cancelled, restore stock atomically via RPC
    if (status == 'cancelled') {
      await _client.rpc('restore_stock', params: {'p_order_id': id});
    }
  }

  Future<void> toggleProductVisibility(String id, bool isHidden) async {
    await _client.from('products').update({'is_hidden': isHidden}).eq('id', id);
  }

  Future<void> deleteProduct(String id) async {
    await _client.from('products').delete().eq('id', id);
  }

  Future<List<Map<String, dynamic>>> getRecentOrders() async {
    final data = await _client
        .from('orders')
        .select('*, profiles(full_name, email)')
        .order('created_at', ascending: false)
        .limit(5);
    return List<Map<String, dynamic>>.from(data);
  }

  // --- CATEGORY CRUD ---
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final data = await _client.from('categories').select('*').order('name');
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> createCategory(Map<String, dynamic> data) async {
    await _client.from('categories').insert(data);
  }

  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
    await _client.from('categories').update(data).eq('id', id);
  }

  Future<void> deleteCategory(String id) async {
    await _client.from('categories').delete().eq('id', id);
  }

  // --- COLOR CRUD ---
  Future<List<Map<String, dynamic>>> fetchColors() async {
    final data = await _client.from('colors').select('*').order('name');
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> createColor(Map<String, dynamic> data) async {
    await _client.from('colors').insert(data);
  }

  Future<void> updateColor(String id, Map<String, dynamic> data) async {
    await _client.from('colors').update(data).eq('id', id);
  }

  Future<void> deleteColor(String id) async {
    await _client.from('colors').delete().eq('id', id);
  }

  // --- BRAND CRUD ---
  Future<List<Map<String, dynamic>>> fetchBrands() async {
    final data = await _client.from('brands').select('*').order('name');
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> createBrand(Map<String, dynamic> data) async {
    await _client.from('brands').insert(data);
  }

  Future<void> updateBrand(String id, Map<String, dynamic> data) async {
    await _client.from('brands').update(data).eq('id', id);
  }

  Future<void> deleteBrand(String id) async {
    await _client.from('brands').delete().eq('id', id);
  }

  // --- COUPON CRUD ---
  Future<List<Map<String, dynamic>>> fetchCoupons() async {
    final data = await _client.from('coupons').select('*').order('code');
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> createCoupon(Map<String, dynamic> data) async {
    await _client.from('coupons').insert(data);
  }

  Future<void> updateCoupon(String id, Map<String, dynamic> data) async {
    await _client.from('coupons').update(data).eq('id', id);
  }

  Future<void> deleteCoupon(String id) async {
    await _client.from('coupons').delete().eq('id', id);
  }

  // --- PRODUCT CRUD (Extending existing ones) ---
  Future<void> createProduct(Map<String, dynamic> data) async {
    await _client.from('products').insert(data);
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    await _client.from('products').update(data).eq('id', id);
  }

  // --- RETURN REQUESTS ---
  Future<List<Map<String, dynamic>>> fetchReturnRequests() async {
    final data = await _client
        .from('return_requests')
        .select('*, profiles(full_name, email)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> updateReturnRequestStatus(String id, String status) async {
    await _client.from('return_requests').update({'status': status}).eq('id', id);
  }
}

@riverpod
AdminRepository adminRepository(Ref ref) {
  return AdminRepository();
}

@riverpod
Future<Map<String, dynamic>> adminMetrics(Ref ref) {
  return ref.read(adminRepositoryProvider).getDashboardMetrics();
}

@riverpod
Future<List<Map<String, dynamic>>> recentOrders(Ref ref) {
  return ref.read(adminRepositoryProvider).getRecentOrders();
}

@riverpod
Future<List<Map<String, dynamic>>> adminProducts(Ref ref) {
  return ref.read(adminRepositoryProvider).getAdminProducts();
}

@riverpod
Future<List<Map<String, dynamic>>> allAdminOrders(Ref ref) {
  return ref.read(adminRepositoryProvider).getAllAdminOrders();
}

@riverpod
Future<List<Map<String, dynamic>>> allAdminUsers(Ref ref) {
  return ref.read(adminRepositoryProvider).getAllAdminUsers();
}

@riverpod
Future<List<Map<String, dynamic>>> adminCategories(Ref ref) {
  return ref.read(adminRepositoryProvider).fetchCategories();
}

@riverpod
Future<List<Map<String, dynamic>>> adminColors(Ref ref) {
  return ref.read(adminRepositoryProvider).fetchColors();
}

@riverpod
Future<List<Map<String, dynamic>>> adminBrands(Ref ref) {
  return ref.read(adminRepositoryProvider).fetchBrands();
}

@riverpod
Future<List<Map<String, dynamic>>> adminCoupons(Ref ref) {
  return ref.read(adminRepositoryProvider).fetchCoupons();
}

@riverpod
Future<List<Map<String, dynamic>>> adminReturns(Ref ref) {
  return ref.read(adminRepositoryProvider).fetchReturnRequests();
}
