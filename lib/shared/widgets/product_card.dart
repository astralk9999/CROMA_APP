import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import 'cached_image.dart';
import '../../features/favorites/data/favorites_provider.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  final VoidCallback onTap;
  final String? heroTag;

  const ProductCard({
    super.key, 
    required this.product, 
    required this.onTap,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favIds = ref.watch(favoritesProvider);
    final isFav = favIds.contains(product.id);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Container
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedImage(
                  imageUrl: product.images.isNotEmpty
                      ? product.images.first
                      : '',
                  fit: BoxFit.cover,
                ),

                // Badges overlay (top-left)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.hasDiscount)
                        _buildBadge(
                          context,
                          'SALE',
                          Theme.of(context).colorScheme.error,
                        ),
                      if (product.isLimitedDrop == true)
                        _buildBadge(
                          context,
                          'LIMITED',
                          Theme.of(context).colorScheme.primary,
                        ),
                      if (product.isViralTrend == true)
                        _buildBadge(context, 'VIRAL', Colors.orange),
                    ],
                  ),
                ),

                // Favorite heart (top-right)
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () {
                      ref.read(favoritesProvider.notifier).toggle(product.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF202020).withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: isFav ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                ),

                // Sold out overlay
                if (product.effectiveStock <= 0)
                  Container(
                    color: Colors.white.withValues(alpha: 0.7),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        color: const Color(0xFF202020),
                        child: Text(
                          'SOLD OUT',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Product Info
          const SizedBox(height: 12),
          Text(
            product.name,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (product.brand != null && product.brand!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              product.brand!.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey[600],
                    letterSpacing: 1,
                    fontSize: 10,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 4),
          Row(
            children: [
              if (product.hasDiscount) ...[
                Text(
                  '${product.finalPrice.toStringAsFixed(2)} €',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${product.price.toStringAsFixed(2)} €',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
              ] else ...[
                Text(
                  '${product.price.toStringAsFixed(2)} €',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: color,
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
