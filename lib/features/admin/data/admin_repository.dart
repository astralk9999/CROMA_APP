import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'admin_repository.g.dart';

class AdminRepository {
  final _client = SupabaseService.client;

  Future<Map<String, dynamic>> getDashboardMetrics() async {
    final productsRes = await _client.from('products').select('id');
    final ordersRes = await _client.from('orders').select('id, total_amount, status');
    final profilesRes = await _client.from('profiles').select('id', count: CountOption.exact);
    final newsletterRes = await _client.from('newsletter_subscribers').select('id', count: CountOption.exact);
    
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
      'users': profilesRes.count,
      'revenue': totalRevenue,
      'pendingOrders': pendingOrders,
      'marketingReach': (profilesRes.count ?? 0) + (newsletterRes.count ?? 0),
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
    await _client.from('orders').update({'status': status}).eq('id', id);
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
