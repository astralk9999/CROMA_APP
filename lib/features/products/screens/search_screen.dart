import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:croma_app/config/theme.dart';
import 'package:croma_app/features/products/providers/product_provider.dart';
import 'package:croma_app/features/products/widgets/product_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchProductsProvider(_query));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search products, colors...',
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            fillColor: Colors.transparent,
          ),
          onChanged: (value) {
            setState(() {
              _query = value;
            });
          },
        ),
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close, color: AppTheme.black),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _query = '';
                });
              },
            ),
        ],
      ),
      body: _query.isEmpty
          ? _buildSuggestions()
          : searchResults.when(
              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Text('No products found'));
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
    );
  }

  Widget _buildSuggestions() {
    final suggestions = ['Jackets', 'T-Shirts', 'Black', 'Hoodie'];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SUGGESTIONS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.gray400,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: suggestions.map((tag) {
              return ActionChip(
                label: Text(tag),
                backgroundColor: AppTheme.gray100,
                onPressed: () {
                  _searchController.text = tag;
                  setState(() {
                    _query = tag;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
