import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:croma_app/config/theme.dart';
import 'package:croma_app/features/products/providers/favorites_provider.dart';
import 'package:croma_app/features/products/widgets/product_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MIS FAVORITOS'),
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: favorites.isEmpty
          // Empty State
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: AppTheme.gray100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 48,
                        color: AppTheme.gray400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'No tienes favoritos aún',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Explora nuestros productos y añade tus favoritos haciendo clic en el corazón.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.gray600),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => context.go('/catalog'),
                      child: const Text('EXPLORAR COLECCIÓN'),
                    ),
                  ],
                ),
              ),
            )
          // Grid
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.60, // Adjusted aspect ratio for card height
                crossAxisSpacing: 16,
                mainAxisSpacing: 24,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return ProductCard(product: favorites[index]);
              },
            ),
    );
  }
}
