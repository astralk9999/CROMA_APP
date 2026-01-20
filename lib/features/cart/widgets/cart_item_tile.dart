import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:croma_app/config/theme.dart';
import 'package:croma_app/features/cart/providers/cart_provider.dart';
import 'package:croma_app/core/utils/formatters.dart';

class CartItemTile extends ConsumerWidget {
  final CartItem item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = item.product;
    final image = product.images.isNotEmpty ? product.images[0] : '';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.gray200)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            width: 80,
            height: 100,
            color: AppTheme.gray100,
            child: image.isNotEmpty
                ? CachedNetworkImage(imageUrl: image, fit: BoxFit.cover)
                : const Icon(Icons.shopping_bag_outlined),
          ),
          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Size: ${item.size}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppTheme.gray600),
                ),
                const SizedBox(height: 8),
                Text(
                  Formatters.formatPrice(product.price),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),

          // Quantity & Remove
          Column(
            children: [
              IconButton(
                onPressed: () {
                  ref
                      .read(cartProvider.notifier)
                      .removeItem(product.id, item.size);
                },
                icon: const Icon(
                  Icons.close,
                  size: 20,
                  color: AppTheme.gray600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.gray300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: item.quantity > 1
                          ? () => ref
                                .read(cartProvider.notifier)
                                .updateQuantity(
                                  product.id,
                                  item.size,
                                  item.quantity - 1,
                                )
                          : null,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Text('-'),
                      ),
                    ),
                    Text(
                      '${item.quantity}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    InkWell(
                      onTap: () => ref
                          .read(cartProvider.notifier)
                          .updateQuantity(
                            product.id,
                            item.size,
                            item.quantity + 1,
                          ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Text('+'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
