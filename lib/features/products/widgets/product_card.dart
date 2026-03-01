import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:croma_app/features/products/providers/favorites_provider.dart';
import 'package:croma_app/config/theme.dart';
import 'package:croma_app/core/utils/formatters.dart';
import 'package:croma_app/shared/models/product.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainImage = product.images.isNotEmpty ? product.images[0] : '';
    final isFavorite = ref.watch(
      favoritesProvider.select((s) => s.value?.contains(product.id) ?? false),
    );

    return GestureDetector(
      onTap: onTap ?? () => context.push('/product/${product.slug}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Container(
              color: AppTheme.gray100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (mainImage.isNotEmpty)
                    Hero(
                      tag: 'product_${product.id}',
                      child: CachedNetworkImage(
                        imageUrl: mainImage,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: AppTheme.gray200,
                          highlightColor: AppTheme.gray100,
                          child: Container(color: AppTheme.white),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    )
                  else
                    const Center(child: Icon(Icons.image_not_supported)),

                  // Favorite Button Overlay
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppTheme.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                        ),
                        color: isFavorite ? Colors.red : AppTheme.black,
                        onPressed: () {
                          ref
                              .read(favoritesProvider.notifier)
                              .toggleFavorite(product.id);
                        },
                        constraints: const BoxConstraints.tightFor(
                          width: 32,
                          height: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),

                  // "New In" Badge (Example logic)
                  if (product.stock > 0)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        color: AppTheme.black,
                        child: Text(
                          'NEW IN',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppTheme.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Details
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.gray600),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Formatters.formatPrice(product.price),
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              // Optional: Color count or other info
              if (product.stockBySizes != null)
                Text(
                  '+ Colors',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppTheme.gray400),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
