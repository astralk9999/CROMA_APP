import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../shared/models/cart_item.dart';
import '../data/cart_repository.dart';

part 'cart_provider.g.dart';

@Riverpod(keepAlive: true)
class CartNotifier extends _$CartNotifier {
  final _repository = CartRepository();

  @override
  FutureOr<List<CartItem>> build() async {
    return _repository.getCartItems();
  }

  Future<void> addItem(CartItem item) async {
    final currentState = state;
    if (currentState is AsyncData) {
      var items = List<CartItem>.from(currentState.value!);

      // Check if item exists (same product AND same size)
      final existingIndex = items.indexWhere(
        (i) => i.productId == item.productId && i.size == item.size,
      );

      if (existingIndex >= 0) {
        // Update quantity
        final existingItem = items[existingIndex];
        final newQuantity = existingItem.quantity + item.quantity;

        // Prevent exceeding max stock
        if (newQuantity <= existingItem.maxStock) {
          items[existingIndex] = existingItem.copyWith(quantity: newQuantity);
        } else {
          items[existingIndex] = existingItem.copyWith(
            quantity: existingItem.maxStock,
          );
        }
      } else {
        // Add new
        items.add(item);
      }

      state = AsyncData(items);
      await _repository.saveCartItems(items);
    }
  }

  Future<void> removeItem(String cartItemId) async {
    final currentState = state;
    if (currentState is AsyncData) {
      var items = List<CartItem>.from(currentState.value!);
      items.removeWhere((item) => item.id == cartItemId);

      state = AsyncData(items);
      await _repository.saveCartItems(items);
    }
  }

  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    if (newQuantity <= 0) {
      return removeItem(cartItemId);
    }

    final currentState = state;
    if (currentState is AsyncData) {
      var items = List<CartItem>.from(currentState.value!);
      final index = items.indexWhere((item) => item.id == cartItemId);

      if (index >= 0) {
        final item = items[index];
        if (newQuantity <= item.maxStock) {
          items[index] = item.copyWith(quantity: newQuantity);
          state = AsyncData(items);
          await _repository.saveCartItems(items);
        }
      }
    }
  }

  Future<void> clearCart() async {
    state = const AsyncData([]);
    await _repository.clearCart();
  }

  double get cartTotal {
    final currentState = state;
    if (currentState is AsyncData) {
      return currentState.value!.fold(
        0,
        (sum, item) => sum + (item.price * item.quantity),
      );
    }
    return 0;
  }
}
