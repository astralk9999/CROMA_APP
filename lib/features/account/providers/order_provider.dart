import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:croma_app/core/services/supabase_service.dart';
import 'package:croma_app/shared/models/order.dart';

part 'order_provider.g.dart';

@riverpod
Future<List<Order>> userOrders(Ref ref) async {
  final user = SupabaseService.currentUser;
  if (user == null) return [];

  final response = await SupabaseService.client
      .from('orders')
      .select('*, order_items(*, product:products(*))')
      .eq('user_id', user.id)
      .order('created_at', ascending: false);

  return (response as List).map((json) => Order.fromJson(json)).toList();
}
