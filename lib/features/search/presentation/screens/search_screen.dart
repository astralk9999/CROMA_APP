import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/widgets/croma_loading.dart';
import '../../data/search_repository.dart';
import '../../../shop/data/shop_repository.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String? _selectedCategoryId;
  String? _selectedBrand;
  String? _selectedColor;
  List<Product> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  int _currentPage = 0;
  bool _hasMore = true;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _search({bool reset = true}) async {
    if (reset) {
      _currentPage = 0;
      _results = [];
      _hasMore = true;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      final repo = ref.read(searchRepositoryProvider);
      final products = await repo.searchProducts(
        query: _searchController.text.isEmpty ? null : _searchController.text,
        categoryId: _selectedCategoryId,
        brand: _selectedBrand,
        color: _selectedColor,
        page: _currentPage,
      );

      setState(() {
        if (reset) {
          _results = products;
        } else {
          _results.addAll(products);
        }
        _hasMore = products.length >= 20;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMore() async {
    _currentPage++;
    await _search(reset: false);
  }

  void _clearFilters() {
    setState(() {
      _selectedCategoryId = null;
      _selectedBrand = null;
      _selectedColor = null;
      _searchController.clear();
      _results = [];
      _hasSearched = false;
    });
  }

  int get _activeFilterCount {
    int count = 0;
    if (_selectedCategoryId != null) count++;
    if (_selectedBrand != null) count++;
    if (_selectedColor != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final brandsAsync = ref.watch(availableBrandsProvider);
    final colorsAsync = ref.watch(availableColorsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar removido para evitar problemas directos
      body: SafeArea(
        child: Column(
          children: [
            // ─── SEARCH BAR ───
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                   IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF202020), width: 2),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          const Icon(Icons.search, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'Buscar productos...',
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              style: const TextStyle(fontSize: 14),
                              onSubmitted: (_) => _search(),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _showFilters(context, categoriesAsync, brandsAsync, colorsAsync),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _activeFilterCount > 0 ? const Color(0xFF202020) : Colors.white,
                        border: Border.all(color: const Color(0xFF202020), width: 2),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.tune,
                            size: 20,
                            color: _activeFilterCount > 0 ? Colors.white : const Color(0xFF202020),
                          ),
                          if (_activeFilterCount > 0)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '$_activeFilterCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── ACTIVE FILTERS CHIPS ───
            if (_activeFilterCount > 0)
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    if (_selectedCategoryId != null)
                      _buildActiveChip('Categoría', () {
                        setState(() => _selectedCategoryId = null);
                        _search();
                      }),
                    if (_selectedBrand != null)
                      _buildActiveChip(_selectedBrand!, () {
                        setState(() => _selectedBrand = null);
                        _search();
                      }),
                    if (_selectedColor != null)
                      _buildActiveChip(_selectedColor!, () {
                        setState(() => _selectedColor = null);
                        _search();
                      }),
                    TextButton(
                      onPressed: _clearFilters,
                      child: const Text('Limpiar todo', style: TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                  ],
                ),
              ),

            // ─── RESULTS ───
            Expanded(
              child: !_hasSearched
                  ? _buildSuggestions(context)
                  : _results.isEmpty && !_isLoading
                      ? _buildEmptyState()
                      : GridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.55,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 24,
                          ),
                          itemCount: _results.length + (_isLoading && _hasMore ? 2 : 0),
                          itemBuilder: (context, index) {
                            if (index >= _results.length) {
                              return const ProductCardShimmer();
                            }
                            final product = _results[index];
                            return ProductCard(
                              product: product,
                              onTap: () => context.push('/product/${product.slug}'),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveChip(String label, VoidCallback onRemove) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 11, color: Colors.white)),
        backgroundColor: const Color(0xFF202020),
        deleteIcon: const Icon(Icons.close, size: 14, color: Colors.white),
        onDeleted: onRemove,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        side: BorderSide.none,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'BUSCA TU PRENDA',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Por nombre, categoría, color o marca',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'SIN RESULTADOS',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
          ),
          const SizedBox(height: 8),
          const Text('Prueba con otros términos o filtros',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  void _showFilters(
    BuildContext context,
    AsyncValue categoriesAsync,
    AsyncValue brandsAsync,
    AsyncValue colorsAsync,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.7,
              maxChildSize: 0.9,
              builder: (_, scrollCtrl) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: ListView(
                    controller: scrollCtrl,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('FILTROS',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2,
                                  )),
                          IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(ctx)),
                        ],
                      ),
                      Divider(color: Color(0xFF202020), thickness: 2),
                      const SizedBox(height: 16),

                      // ── Category ──
                      const Text('CATEGORÍA',
                          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.5, fontSize: 12)),
                      const SizedBox(height: 8),
                      categoriesAsync.when(
                        data: (categories) => Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _filterChip('TODAS', _selectedCategoryId == null, () {
                              setModalState(() {});
                              setState(() => _selectedCategoryId = null);
                            }),
                            ...categories.map((cat) => _filterChip(
                                  cat.name.toUpperCase(),
                                  _selectedCategoryId == cat.id,
                                  () {
                                    setModalState(() {});
                                    setState(() => _selectedCategoryId = cat.id);
                                  },
                                )),
                          ],
                        ),
                        loading: () => const CromaLoading(),
                        error: (_, __) => const Text('Error'),
                      ),

                      const SizedBox(height: 24),

                      // ── Brand ──
                      const Text('MARCA',
                          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.5, fontSize: 12)),
                      const SizedBox(height: 8),
                      brandsAsync.when(
                        data: (brands) => Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _filterChip('TODAS', _selectedBrand == null, () {
                              setModalState(() {});
                              setState(() => _selectedBrand = null);
                            }),
                            ...brands.map((b) => _filterChip(
                                  b.toUpperCase(),
                                  _selectedBrand == b,
                                  () {
                                    setModalState(() {});
                                    setState(() => _selectedBrand = b);
                                  },
                                )),
                          ],
                        ),
                        loading: () => const CromaLoading(),
                        error: (_, __) => const Text('Error'),
                      ),

                      const SizedBox(height: 24),

                      // ── Color ──
                      const Text('COLOR',
                          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.5, fontSize: 12)),
                      const SizedBox(height: 8),
                      colorsAsync.when(
                        data: (colors) => Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _filterChip('TODOS', _selectedColor == null, () {
                              setModalState(() {});
                              setState(() => _selectedColor = null);
                            }),
                            ...colors.map((c) => _filterChip(
                                  c.toUpperCase(),
                                  _selectedColor == c,
                                  () {
                                    setModalState(() {});
                                    setState(() => _selectedColor = c);
                                  },
                                )),
                          ],
                        ),
                        loading: () => const CromaLoading(),
                        error: (_, __) => const Text('Error'),
                      ),

                      const SizedBox(height: 32),

                      // ── Apply ──
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _search();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF202020),
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          ),
                          child: const Text('APLICAR FILTROS',
                              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF202020) : Colors.white,
          border: Border.all(color: const Color(0xFF202020), width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF202020),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
