import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/croma_app_bar.dart';
import '../../../../shared/widgets/croma_bottom_nav.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../data/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favProductsAsync = ref.watch(favoriteProductsProvider);

    return Scaffold(
      extendBody: true,
      appBar: const CromaAppBar(),
      body: favProductsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'NO TIENES FAVORITOS',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            letterSpacing: 2,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Pulsa el corazón en cualquier producto para guardarlo aquí',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => context.go('/shop'),
                      child: const Text('EXPLORAR TIENDA'),
                    ),
                  ],
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.55,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: products[index],
                onTap: () => context.push('/product/${products[index].slug}'),
              );
            },
          );
        },
        loading: () => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.55,
            crossAxisSpacing: 16,
            mainAxisSpacing: 24,
          ),
          itemCount: 4,
          itemBuilder: (_, __) => const ProductCardShimmer(),
        ),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      bottomNavigationBar: const CromaBottomNav(currentIndex: 3),
    );
  }
}
