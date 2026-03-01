import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../shared/models/order.dart';
import '../../../../core/services/supabase_service.dart';

part 'checkout_repository.g.dart';

class CheckoutRepository {
  final _client = SupabaseService.client;

  Future<Order> getOrderById(String orderId) async {
    final data = await _client
        .from('orders')
        .select('*, order_items(*)')
        .eq('id', orderId)
        .single();
    return Order.fromJson(data);
  }
}

@riverpod
CheckoutRepository checkoutRepository(Ref ref) {
  return CheckoutRepository();
}

@riverpod
Future<Order> orderDetail(Ref ref, String orderId) {
  return ref.read(checkoutRepositoryProvider).getOrderById(orderId);
}
