import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:croma_app/config/theme.dart';
import 'package:croma_app/features/products/providers/product_provider.dart';
import 'package:croma_app/features/products/widgets/product_card.dart';

class TrendingSection extends ConsumerWidget {
  const TrendingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(allProductsProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'TRENDING NOW',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 340,
            child: productsAsync.when(
              data: (products) {
                // Filter some products to simulate "trending"
                final trending = products.take(5).toList();
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  itemCount: trending.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 20),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 220,
                      child: ProductCard(product: trending[index]),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppTheme.black),
              ),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
