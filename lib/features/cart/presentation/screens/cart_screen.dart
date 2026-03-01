import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/croma_app_bar.dart';
import '../../../../shared/widgets/croma_bottom_nav.dart';
import '../../../../shared/widgets/cached_image.dart';
import '../../providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartNotifierProvider);

    return Scaffold(
      appBar: const CromaAppBar(),
      body: cartState.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'TU CARRITO ESTÁ VACÍO',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => context.go('/shop'),
                    child: const Text('IR A LA TIENDA'),
                  ),
                ],
              ),
            );
          }

          final total = ref.read(cartNotifierProvider.notifier).cartTotal;

          return Column(
            children: [
              // Lista de Items
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: Colors.black, thickness: 2),
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Imagen
                        CachedImage(
                          imageUrl: item.image,
                          width: 80,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 16),

                        // Detalles
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'TALLA: ${item.size}',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const SizedBox(height: 12),

                              // Controles de Cantidad
                              Row(
                                children: [
                                  _QuantityButton(
                                    icon: Icons.remove,
                                    onPressed: () {
                                      ref
                                          .read(cartNotifierProvider.notifier)
                                          .updateQuantity(
                                            item.id,
                                            item.quantity - 1,
                                          );
                                    },
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 4,
                                    ),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                        bottom: BorderSide(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      '${item.quantity}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  _QuantityButton(
                                    icon: Icons.add,
                                    onPressed: item.quantity >= item.maxStock
                                        ? null
                                        : () {
                                            ref
                                                .read(
                                                  cartNotifierProvider.notifier,
                                                )
                                                .updateQuantity(
                                                  item.id,
                                                  item.quantity + 1,
                                                );
                                          },
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${(item.price * item.quantity).toStringAsFixed(2)} €',
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Eliminar
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => ref
                              .read(cartNotifierProvider.notifier)
                              .removeItem(item.id),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Total y Checkout
              Container(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: MediaQuery.of(context).padding.bottom + 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      offset: const Offset(0, -4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SUBTOTAL',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          '${total.toStringAsFixed(2)} €',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Impuestos incluidos. Gastos de envío calculados en la pantalla de pago.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.push('/checkout'),
                        child: const Text('FINALIZAR COMPRA'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.black)),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      bottomNavigationBar: const CromaBottomNav(currentIndex: 2),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _QuantityButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          color: onPressed == null ? Colors.grey.shade200 : Colors.white,
        ),
        child: Icon(
          icon,
          size: 16,
          color: onPressed == null ? Colors.grey : Colors.black,
        ),
      ),
    );
  }
}
