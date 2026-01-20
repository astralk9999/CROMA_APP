import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:croma_app/config/theme.dart';
import 'package:croma_app/features/cart/providers/cart_provider.dart';
import 'package:croma_app/features/cart/widgets/cart_item_tile.dart';
import 'package:croma_app/core/utils/formatters.dart';
import 'package:croma_app/core/services/stripe_service.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _isLoading = false;

  Future<void> _handleCheckout() async {
    setState(() => _isLoading = true);
    final items = ref.read(cartProvider);
    final total = ref.read(cartTotalProvider);

    if (items.isEmpty) return;

    try {
      await StripeService.instance.makePayment(
        items: items,
        amount: total,
        context: context,
        onSuccess: (orderId) async {
          // Clear Cart
          ref.read(cartProvider.notifier).clearCart();

          if (!mounted) return;

          // Show Success Dialog
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('¡Pago Exitoso!'),
              content: Text(
                'Tu pedido #$orderId se ha procesado correctamente.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    context.pop(); // Close dialog
                    context.go('/account'); // Go to orders
                  },
                  child: const Text('VER PEDIDO'),
                ),
                TextButton(
                  onPressed: () {
                    context.pop(); // Close dialog
                    context.go('/'); // Go home
                  },
                  child: const Text('SEGUIR COMPRANDO'),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString().replaceAll("Exception:", "")}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'YOUR CART',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: AppTheme.gray400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.go('/'),
                    child: const Text('START SHOPPING'),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          return CartItemTile(item: cartItems[index]);
                        },
                      ),
                    ),

                    // Summary Section
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(color: AppTheme.gray100),
                      child: SafeArea(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('SUBTOTAL'),
                                Text(
                                  Formatters.formatPrice(total),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('SHIPPING'),
                                Text(
                                  'Calculated at checkout',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: AppTheme.gray600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'TOTAL',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  Formatters.formatPrice(total),
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _handleCheckout,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 56),
                                backgroundColor: AppTheme.black,
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text('CHECKOUT'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isLoading)
                  const ModalBarrier(dismissible: false, color: Colors.black12),
              ],
            ),
    );
  }
}
