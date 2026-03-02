import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../shared/models/order.dart';
import '../../../../shared/models/order_item.dart';
import '../../../../shared/models/return_request.dart';

part 'account_repository.g.dart';

class AccountRepository {
  final _client = SupabaseService.client;

  Future<List<Order>> getUserOrders() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final data = await _client
        .from('orders')
        .select('*, shipping_address')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (data as List).map((e) => Order.fromJson(e)).toList();
  }

  Future<Order?> getOrderDetails(String orderId) async {
    final data = await _client
        .from('orders')
        .select('*, shipping_address, order_items(*, product:products(*))')
        .eq('id', orderId)
        .single();

    final order = Order.fromJson(data);
    
    // Manually map order items and ensure product_image is populated from the joined product if missing
    final itemsData = data['order_items'] as List;
    final items = itemsData.map((e) {
      final itemMap = Map<String, dynamic>.from(e);
      // If product_image is null or empty, try to get it from the joined product
      if ((itemMap['product_image'] == null || itemMap['product_image'] == '') && itemMap['product'] != null) {
        final productImages = itemMap['product']['images'] as List?;
        if (productImages != null && productImages.isNotEmpty) {
          itemMap['product_image'] = productImages.first;
        }
      }
      return OrderItem.fromJson(itemMap);
    }).toList();
    
    return order.copyWith(items: items);
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('No autorizado');

    await _client
        .from('orders')
        .update({'status': newStatus})
        .match({'id': orderId, 'user_id': user.id});
  }

  Future<List<ReturnRequest>> getUserReturns() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final data = await _client
        .from('return_requests')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (data as List).map((e) => ReturnRequest.fromJson(e)).toList();
  }

  Future<void> createReturnRequest({
    required String orderId,
    required String reason,
    String? details,
    List<String>? images,
    required List<String> orderItemIds,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('No autorizado');

    // 1. Create return request header
    final headerData = await _client.from('return_requests').insert({
      'order_id': orderId,
      'user_id': user.id,
      'reason': reason,
      'details': details,
      'images': images ?? [],
      'status': 'pending',
    }).select().single();

    final returnId = headerData['id'];

    // 2. Create return request items
    final itemsToInsert = orderItemIds.map((itemId) => {
      'return_request_id': returnId,
      'order_item_id': itemId,
      'quantity': 1,
    }).toList();

    await _client.from('return_request_items').insert(itemsToInsert);
  }
}

@riverpod
AccountRepository accountRepository(Ref ref) {
  return AccountRepository();
}

@riverpod
Future<List<Order>> userOrders(Ref ref) {
  return ref.read(accountRepositoryProvider).getUserOrders();
}

@riverpod
Future<Order?> orderDetails(Ref ref, String orderId) {
  return ref.read(accountRepositoryProvider).getOrderDetails(orderId);
}

@riverpod
Future<List<ReturnRequest>> userReturns(Ref ref) {
  return ref.read(accountRepositoryProvider).getUserReturns();
}
