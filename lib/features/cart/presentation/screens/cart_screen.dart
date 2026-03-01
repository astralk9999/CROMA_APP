import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/croma_app_bar.dart';
import '../../../../shared/widgets/croma_bottom_nav.dart';
import '../../../../shared/widgets/cached_image.dart';
import '../../../../shared/widgets/croma_loading.dart';
import '../../providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartNotifierProvider);

    return Scaffold(
      extendBody: true,
      appBar: const CromaAppBar(),
      body: cartState.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: const Color(0xFF202020).withAlpha(10),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 80,
                      color: Color(0xFF202020),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'TU CARRITO ESTÁ VACÍO',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Añade algunas prendas para empezar tu pedido.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () => context.go('/shop'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF202020),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      child: const Text('IR A LA TIENDA', style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold)),
                    ),
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
                    child: Divider(color: Color(0xFF202020), thickness: 2),
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFF202020), width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            offset: const Offset(4, 4),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagen con borde industrial
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFF202020), width: 1),
                            ),
                            child: CachedImage(
                              imageUrl: item.image,
                              width: 90,
                              height: 110,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
  
                          // Detalles
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.name.toUpperCase(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14,
                                          letterSpacing: 1,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 20),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () => ref
                                          .read(cartNotifierProvider.notifier)
                                          .removeItem(item.id),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'SIZE: ${item.size}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 16),
  
                                // Controles de Cantidad y Precio
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
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
                                          width: 40,
                                          height: 32,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            border: Border.symmetric(
                                              horizontal: BorderSide(color: Color(0xFF202020), width: 1),
                                            ),
                                          ),
                                          child: Text(
                                            '${item.quantity}',
                                            style: const TextStyle(fontWeight: FontWeight.w900),
                                          ),
                                        ),
                                        _QuantityButton(
                                          icon: Icons.add,
                                          onPressed: item.quantity >= item.maxStock
                                              ? null
                                              : () {
                                                  ref
                                                      .read(cartNotifierProvider.notifier)
                                                      .updateQuantity(
                                                        item.id,
                                                        item.quantity + 1,
                                                      );
                                                },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${(item.price * item.quantity).toStringAsFixed(2)} €',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                  bottom: MediaQuery.of(context).padding.bottom + 110,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: const Border(top: BorderSide(color: Color(0xFF202020), width: 2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
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
                        const Text(
                          'TOTAL',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          '${total.toStringAsFixed(2)} €',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Impuestos incluidos. Gastos de envío calculados al finalizar.',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () => context.push('/checkout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF202020),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('FINALIZAR COMPRA', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
                            SizedBox(width: 12),
                            Icon(Icons.arrow_forward_ios, size: 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () =>
            const Center(child: CromaLoading()),
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
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF202020), width: 1),
          color: onPressed == null ? Colors.grey.shade100 : Colors.white,
        ),
        child: Icon(
          icon,
          size: 14,
          color: onPressed == null ? Colors.grey : const Color(0xFF202020),
        ),
      ),
    );
  }
}
