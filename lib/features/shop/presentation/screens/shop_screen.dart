import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/croma_app_bar.dart';
import '../../../../shared/widgets/croma_bottom_nav.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/models/product.dart';
import '../../data/shop_repository.dart';
import '../../../search/data/search_repository.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  String? _selectedCategoryId;
  String? _selectedBrand;
  String? _selectedColor;
  String? _selectedEspecial; // 'limited', 'discount', 'viral', 'bestseller'
  String _searchQuery = '';
  double? _minPrice;
  double? _maxPrice;
  String _sortBy = 'created_at';
  bool _sortAsc = false;
  String _sortLabel = 'Más recientes';
  final TextEditingController _searchController = TextEditingController();
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

  int get _activeFilterCount {
    int count = 0;
    if (_searchQuery.isNotEmpty) count++;
    if (_minPrice != null || _maxPrice != null) count++;
    if (_selectedCategoryId != null) count++;
    if (_selectedBrand != null) count++;
    if (_selectedColor != null) count++;
    if (_selectedEspecial != null) count++;
    return count;
  }

  Future<void> _loadProducts({bool reset = false}) async {
    if (reset) {
      _currentPage = 0;
      _products.clear();
      _hasMore = true;
      _initialLoad = _products.isEmpty;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(shopRepositoryProvider);
      final newProducts = await repo.getProducts(
        query: _searchQuery,
        categoryId: _selectedCategoryId,
        brand: _selectedBrand,
        color: _selectedColor,
        isLimitedDrop: _selectedEspecial == 'limited' ? true : null,
        hasDiscount: _selectedEspecial == 'discount' ? true : null,
        isViralTrend: _selectedEspecial == 'viral' ? true : null,
        isBestseller: _selectedEspecial == 'bestseller' ? true : null,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
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

  void _clearAllFilters() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
      _minPrice = null;
      _maxPrice = null;
      _selectedCategoryId = null;
      _selectedBrand = null;
      _selectedColor = null;
      _selectedEspecial = null;
    });
    _loadProducts(reset: true);
  }

  void _showFilterDrawer() {
    final categoriesAsync = ref.read(categoriesProvider);
    final brandsAsync = ref.read(availableBrandsProvider);
    final colorsAsync = ref.read(availableColorsProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.85,
              maxChildSize: 0.95,
              minChildSize: 0.5,
              expand: false,
              builder: (_, scrollController) {
                return Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'FILTROS',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              letterSpacing: 3,
                            ),
                          ),
                          Row(
                            children: [
                              if (_activeFilterCount > 0)
                                TextButton(
                                  onPressed: () {
                                    setModalState(() {
                                      _selectedCategoryId = null;
                                      _selectedBrand = null;
                                      _selectedColor = null;
                                      _selectedEspecial = null;
                                      _minPrice = null;
                                      _maxPrice = null;
                                      _searchController.clear();
                                      _searchQuery = '';
                                    });
                                  },
                                  child: const Text(
                                    'LIMPIAR',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              IconButton(
                                onPressed: () => Navigator.pop(ctx),
                                icon: const Icon(Icons.close, size: 24),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Filter sections
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(24),
                        children: [
                          // ─── ESPECIALES ───
                          _buildFilterSection(
                            'ESPECIALES',
                            [
                              _FilterOption('LANZAMIENTOS LIMITADOS', 'limited'),
                              _FilterOption('DESCUENTOS', 'discount'),
                              _FilterOption('TENDENCIA', 'viral'),
                              _FilterOption('MÁS VENDIDOS', 'bestseller'),
                            ],
                            _selectedEspecial,
                            (value) {
                              setModalState(() {
                                _selectedEspecial =
                                    _selectedEspecial == value ? null : value;
                              });
                            },
                          ),

                          const SizedBox(height: 24),
                          const Divider(color: Colors.black12),
                          const SizedBox(height: 24),

                          // ─── PRECIO ───
                          const Text(
                            'PRECIO',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          RangeSlider(
                            values: RangeValues(_minPrice ?? 0, _maxPrice ?? 500),
                            min: 0,
                            max: 500,
                            divisions: 50,
                            activeColor: Colors.black,
                            inactiveColor: Colors.black12,
                            labels: RangeLabels(
                                '€${(_minPrice ?? 0).toInt()}', '€${(_maxPrice ?? 500).toInt()}'),
                            onChanged: (values) {
                              setModalState(() {
                                _minPrice = values.start;
                                _maxPrice = values.end;
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('€${(_minPrice ?? 0).toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('€${(_maxPrice ?? 500).toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),

                          const SizedBox(height: 24),
                          const Divider(color: Colors.black12),
                          const SizedBox(height: 24),

                          // ─── CATEGORÍAS ───
                          const Text(
                            'CATEGORÍAS',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          categoriesAsync.when(
                            data: (cats) => Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: cats.map((cat) {
                                final selected =
                                    _selectedCategoryId == cat.id;
                                return ChoiceChip(
                                  label: Text(cat.name.toUpperCase()),
                                  selected: selected,
                                  onSelected: (_) {
                                    setModalState(() {
                                      _selectedCategoryId =
                                          selected ? null : cat.id;
                                    });
                                  },
                                  selectedColor: Colors.black,
                                  labelStyle: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    letterSpacing: 1,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                    side: BorderSide(
                                        color: Colors.black, width: 1),
                                  ),
                                  backgroundColor: Colors.white,
                                );
                              }).toList(),
                            ),
                            loading: () => const CircularProgressIndicator(
                                color: Colors.black),
                            error: (_, __) => const SizedBox.shrink(),
                          ),

                          const SizedBox(height: 24),
                          const Divider(color: Colors.black12),
                          const SizedBox(height: 24),

                          // ─── MARCAS ───
                          const Text(
                            'MARCAS',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          brandsAsync.when(
                            data: (brands) => Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: brands.map((brand) {
                                final selected = _selectedBrand == brand;
                                return ChoiceChip(
                                  label: Text(brand.toUpperCase()),
                                  selected: selected,
                                  onSelected: (_) {
                                    setModalState(() {
                                      _selectedBrand =
                                          selected ? null : brand;
                                    });
                                  },
                                  selectedColor: Colors.black,
                                  labelStyle: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    letterSpacing: 1,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                    side: BorderSide(
                                        color: Colors.black, width: 1),
                                  ),
                                  backgroundColor: Colors.white,
                                );
                              }).toList(),
                            ),
                            loading: () => const CircularProgressIndicator(
                                color: Colors.black),
                            error: (_, __) => const SizedBox.shrink(),
                          ),

                          const SizedBox(height: 24),
                          const Divider(color: Colors.black12),
                          const SizedBox(height: 24),

                          // ─── CROMATOGRAFÍA (Colores) ───
                          const Text(
                            'CROMATOGRAFÍA',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          colorsAsync.when(
                            data: (colors) => Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: colors.map((color) {
                                final selected = _selectedColor == color;
                                return ChoiceChip(
                                  label: Text(color.toUpperCase()),
                                  selected: selected,
                                  onSelected: (_) {
                                    setModalState(() {
                                      _selectedColor =
                                          selected ? null : color;
                                    });
                                  },
                                  selectedColor: Colors.black,
                                  labelStyle: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    letterSpacing: 1,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                    side: BorderSide(
                                        color: Colors.black, width: 1),
                                  ),
                                  backgroundColor: Colors.white,
                                );
                              }).toList(),
                            ),
                            loading: () => const CircularProgressIndicator(
                                color: Colors.black),
                            error: (_, __) => const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),

                    // Apply button
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 16,
                        bottom:
                            MediaQuery.of(ctx).padding.bottom + 16,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                              color: Colors.black, width: 2),
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _loadProducts(reset: true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                        ),
                        child: Text(
                          _activeFilterCount > 0
                              ? 'APLICAR FILTROS ($_activeFilterCount)'
                              : 'APLICAR FILTROS',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildFilterSection(
    String title,
    List<_FilterOption> options,
    String? selected,
    ValueChanged<String> onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        ...options.map((opt) {
          final isSelected = selected == opt.value;
          return InkWell(
            onTap: () => onSelect(opt.value),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: isSelected ? 2 : 1,
                      ),
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check,
                            size: 14, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    opt.label,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.w900 : FontWeight.w500,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: const CromaAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Search Bar ───
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar prendas, marcas, colores...',
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.black),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                          _loadProducts(reset: true);
                        },
                      )
                    : null,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (value) {
                setState(() => _searchQuery = value);
                _loadProducts(reset: true);
              },
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // ─── Header ───
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SHOP',
                  style:
                      Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                          ),
                ),
                Row(
                  children: [
                    // Filter button with badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          onPressed: _showFilterDrawer,
                          icon: const Icon(Icons.tune, size: 22),
                        ),
                        if (_activeFilterCount > 0)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                  minWidth: 18, minHeight: 18),
                              child: Text(
                                '$_activeFilterCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    // Sort dropdown
                    PopupMenuButton<String>(
                      icon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.sort, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            _sortLabel,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                            value: 'newest', child: Text('Más recientes')),
                        const PopupMenuItem(
                            value: 'price_asc',
                            child: Text('Precio: menor a mayor')),
                        const PopupMenuItem(
                            value: 'price_desc',
                            child: Text('Precio: mayor a menor')),
                        const PopupMenuItem(
                            value: 'name_asc', child: Text('Nombre A-Z')),
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
              ],
            ),
          ),

          // ─── Active Filter Chips ───
          if (_activeFilterCount > 0)
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  if (_selectedEspecial != null)
                    _buildActiveChip(
                      _getEspecialLabel(_selectedEspecial!),
                      () => setState(() {
                        _selectedEspecial = null;
                        _loadProducts(reset: true);
                      }),
                    ),
                  if (_selectedCategoryId != null)
                    _buildActiveChip(
                      'Categoría',
                      () => setState(() {
                        _selectedCategoryId = null;
                        _loadProducts(reset: true);
                      }),
                    ),
                  if (_selectedBrand != null)
                    _buildActiveChip(
                      _selectedBrand!,
                      () => setState(() {
                        _selectedBrand = null;
                        _loadProducts(reset: true);
                      }),
                    ),
                  if (_selectedColor != null)
                    _buildActiveChip(
                      _selectedColor!,
                      () => setState(() {
                        _selectedColor = null;
                        _loadProducts(reset: true);
                      }),
                    ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _clearAllFilters,
                    child: const Center(
                      child: Text(
                        'LIMPIAR TODO',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ─── Categories Quick Filter ───
          categoriesAsync.when(
            data: (categories) => SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  if (index == 0) return _buildFilterChip('ALL', null);
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
              child: Center(
                  child: CircularProgressIndicator(color: Colors.black)),
            ),
            error: (err, stack) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 12),

          // ─── Products Grid (Infinite Scroll) ───
          Expanded(
            child: _initialLoad
                ? _buildLoadingGrid()
                : _products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.inventory_2_outlined,
                                size: 48, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              'NO SE ENCONTRARON PRODUCTOS',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(fontSize: 14),
                            ),
                            if (_activeFilterCount > 0) ...[
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: _clearAllFilters,
                                child: const Text('LIMPIAR FILTROS'),
                              ),
                            ],
                          ],
                        ),
                      )
                    : GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.50,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 24,
                        ),
                        itemCount: _products.length +
                            (_isLoading && _hasMore ? 2 : 0),
                        itemBuilder: (context, index) {
                          if (index >= _products.length) {
                            return const ProductCardShimmer();
                          }
                          final product = _products[index];
                          return ProductCard(
                            product: product,
                            onTap: () => context
                                .push('/product/${product.slug}'),
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

  Widget _buildActiveChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        deleteIcon:
            const Icon(Icons.close, size: 14, color: Colors.white70),
        onDeleted: onRemove,
        backgroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        side: BorderSide.none,
      ),
    );
  }

  String _getEspecialLabel(String value) {
    switch (value) {
      case 'limited':
        return 'LIMITED';
      case 'discount':
        return 'OFERTAS';
      case 'viral':
        return 'VIRAL';
      case 'bestseller':
        return 'BESTSELLERS';
      default:
        return value;
    }
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.50,
        crossAxisSpacing: 16,
        mainAxisSpacing: 24,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const ProductCardShimmer(),
    );
  }
}

class _FilterOption {
  final String label;
  final String value;
  const _FilterOption(this.label, this.value);
}
