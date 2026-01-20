import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:croma_app/features/products/providers/product_provider.dart';
import 'package:croma_app/features/products/widgets/product_card.dart';

class FeaturedProducts extends ConsumerWidget {
  const FeaturedProducts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredProductsAsync = ref.watch(featuredProductsProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'DROPS / 2026',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.push('/catalog');
                  },
                  child: const Text('SEE ALL'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 320, // Height for the horizontal list
            child: featuredProductsAsync.when(
              data: (products) => ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 200,
                    child: ProductCard(
                      product: products[index],
                      onTap: () {
                        context.push('/product/${products[index].slug}');
                      },
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
