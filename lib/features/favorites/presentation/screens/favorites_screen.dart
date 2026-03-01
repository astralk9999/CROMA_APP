import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/croma_app_bar.dart';
import '../../../../shared/widgets/croma_bottom_nav.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../data/favorites_provider.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
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

          final categories = products
              .map((p) => p.category?.toUpperCase())
              .where((c) => c != null && c.isNotEmpty)
              .cast<String>()
              .toSet()
              .toList();
          categories.sort();

          final filteredProducts = _selectedCategory == null
              ? products
              : products.where((p) => p.category?.toUpperCase() == _selectedCategory).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── TUS FAVORITOS Header & Filter ───
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Text(
                  'TUS FAVORITOS',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                ),
              ),
              if (categories.isNotEmpty)
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final isAll = index == 0;
                      final cat = isAll ? 'TODOS' : categories[index - 1];
                      final isSelected = isAll 
                          ? _selectedCategory == null 
                          : _selectedCategory == cat;

                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            _selectedCategory = isAll ? null : cat;
                          });
                        },
                        selectedColor: const Color(0xFF202020),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF202020),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                          side: BorderSide(color: Color(0xFF202020), width: 1),
                        ),
                        backgroundColor: Colors.white,
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),

              // ─── Products Grid ───
              if (filteredProducts.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text('No hay productos en esta categoría', style: TextStyle(color: Colors.grey)),
                  ),
                )
              else
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.55,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 24,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: filteredProducts[index],
                        onTap: () => context.push(
                            '/product/${filteredProducts[index].slug}'),
                      );
                    },
                  ),
                ),
            ],
          );
        },
        loading: () => GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
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
