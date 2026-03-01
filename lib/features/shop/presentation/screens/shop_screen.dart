import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/croma_app_bar.dart';
import '../../../../shared/widgets/croma_bottom_nav.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/models/product.dart';
import '../../data/shop_repository.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  String? _selectedCategoryId;
  String _sortBy = 'created_at';
  bool _sortAsc = false;
  String _sortLabel = 'Más recientes';
  final List<Product> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final _scrollController = ScrollController();
  bool _initialLoad = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadProducts(reset: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_isLoading &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadProducts({bool reset = false}) async {
    if (reset) {
      _currentPage = 0;
      _products.clear();
      _hasMore = true;
      _initialLoad = true;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(shopRepositoryProvider);
      final newProducts = await repo.getProducts(
        categoryId: _selectedCategoryId,
        sortBy: _sortBy,
        sortAsc: _sortAsc,
        page: _currentPage,
      );

      setState(() {
        _products.addAll(newProducts);
        _hasMore = newProducts.length >= 20;
        _isLoading = false;
        _initialLoad = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _initialLoad = false;
      });
    }
  }

  Future<void> _loadMore() async {
    _currentPage++;
    await _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: const CromaAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Header ───
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SHOP', style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900, letterSpacing: 2,
                )),
                PopupMenuButton<String>(
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.sort, size: 18),
                      const SizedBox(width: 4),
                      Text(_sortLabel, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'newest', child: Text('Más recientes')),
                    const PopupMenuItem(value: 'price_asc', child: Text('Precio: menor a mayor')),
                    const PopupMenuItem(value: 'price_desc', child: Text('Precio: mayor a menor')),
                    const PopupMenuItem(value: 'name_asc', child: Text('Nombre A-Z')),
                  ],
                  onSelected: (value) {
                    setState(() {
                      switch (value) {
                        case 'newest':
                          _sortBy = 'created_at';
                          _sortAsc = false;
                          _sortLabel = 'Más recientes';
                          break;
                        case 'price_asc':
                          _sortBy = 'price';
                          _sortAsc = true;
                          _sortLabel = 'Precio ↑';
                          break;
                        case 'price_desc':
                          _sortBy = 'price';
                          _sortAsc = false;
                          _sortLabel = 'Precio ↓';
                          break;
                        case 'name_asc':
                          _sortBy = 'name';
                          _sortAsc = true;
                          _sortLabel = 'A-Z';
                          break;
                      }
                    });
                    _loadProducts(reset: true);
                  },
                ),
              ],
            ),
          ),

          // ─── Categories Filter ───
          categoriesAsync.when(
            data: (categories) => SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildFilterChip('ALL', null);
                  }
                  final category = categories[index - 1];
                  return _buildFilterChip(
                    category.name.toUpperCase(),
                    category.id,
                  );
                },
              ),
            ),
            loading: () => const SizedBox(
              height: 48,
              child: Center(child: CircularProgressIndicator(color: Colors.black)),
            ),
            error: (err, stack) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 16),

          // ─── Products Grid (Infinite Scroll) ───
          Expanded(
            child: _initialLoad
                ? _buildLoadingGrid()
                : _products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text('NO SE ENCONTRARON PRODUCTOS',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14)),
                          ],
                        ),
                      )
                    : GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.55,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 24,
                        ),
                        itemCount: _products.length + (_isLoading && _hasMore ? 2 : 0),
                        itemBuilder: (context, index) {
                          if (index >= _products.length) {
                            return const ProductCardShimmer();
                          }
                          final product = _products[index];
                          return ProductCard(
                            product: product,
                            onTap: () => context.push('/product/${product.slug}'),
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: const CromaBottomNav(currentIndex: 1),
    );
  }

  Widget _buildFilterChip(String label, String? categoryId) {
    final isSelected = _selectedCategoryId == categoryId;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedCategoryId = categoryId);
          _loadProducts(reset: true);
        }
      },
      selectedColor: Colors.black,
      labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: FontWeight.w900,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Colors.black, width: 2),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55,
        crossAxisSpacing: 16,
        mainAxisSpacing: 24,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const ProductCardShimmer(),
    );
  }
}
