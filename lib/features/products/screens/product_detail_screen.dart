import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:croma_app/config/theme.dart';
import 'package:croma_app/core/utils/formatters.dart';
import 'package:croma_app/features/cart/providers/cart_provider.dart';
import 'package:croma_app/features/products/providers/product_provider.dart';
import 'package:croma_app/features/products/widgets/size_selector.dart';
import 'package:croma_app/shared/widgets/croma_app_bar.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String slug;

  const ProductDetailScreen({super.key, required this.slug});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productBySlugProvider(widget.slug));

    return Scaffold(
      appBar: const CromaAppBar(),
      body: productAsync.when(
        data: (product) {
          if (product == null) {
            return const Center(child: Text('Product not found'));
          }

          final images = product.images.isNotEmpty ? product.images : [''];

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Image Gallery (Simple PageView for now)
                      SizedBox(
                        height: 500,
                        child: PageView.builder(
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            final imageWidget = CachedNetworkImage(
                              imageUrl: images[index],
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  const Center(child: Icon(Icons.broken_image)),
                            );

                            // Only hero the first image to match the card and avoid tag conflicts
                            if (index == 0) {
                              return Hero(
                                tag: 'product_${product.id}',
                                child: imageWidget,
                              );
                            }

                            return imageWidget;
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              Formatters.formatPrice(product.price),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 24),

                            if (product.description != null) ...[
                              Text(
                                product.description!,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(color: AppTheme.gray600),
                              ),
                              const SizedBox(height: 32),
                            ],

                            if (product.sizes.isNotEmpty)
                              SizeSelector(
                                sizes: product.sizes,
                                selectedSize: selectedSize,
                                onSelected: (size) {
                                  setState(() {
                                    selectedSize = size;
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Action Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppTheme.gray200)),
                  color: AppTheme.white,
                ),
                child: SafeArea(
                  child: ElevatedButton(
                    onPressed: selectedSize != null && product.stock > 0
                        ? () {
                            ref
                                .read(cartProvider.notifier)
                                .addItem(product, selectedSize!, 1);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added to cart')),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: Text(
                      product.stock > 0
                          ? (selectedSize == null
                                ? 'SELECT SIZE'
                                : 'ADD TO CART')
                          : 'OUT OF STOCK',
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
