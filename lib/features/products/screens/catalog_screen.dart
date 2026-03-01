import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:croma_app/config/theme.dart';
import 'package:croma_app/features/products/providers/product_provider.dart';
import 'package:croma_app/features/products/widgets/product_card.dart';
import 'package:croma_app/shared/widgets/croma_app_bar.dart';
import 'package:croma_app/features/products/widgets/filters_sheet.dart';

import 'package:croma_app/shared/widgets/croma_drawer.dart';

class CatalogScreen extends ConsumerWidget {
  final String categorySlug;
  const CatalogScreen({super.key, required this.categorySlug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsByCategoryProvider(categorySlug));
    final title = categorySlug.replaceAll('-', ' ').toUpperCase();

    return Scaffold(
      appBar: const CromaAppBar(),
      drawer: const CromaDrawer(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title == 'ALL' ? 'ALL PRODUCTS' : title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const FiltersSheet(),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: productsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return const Center(
                    child: Text('No products found in this category'),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: products[index]);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppTheme.black),
              ),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
