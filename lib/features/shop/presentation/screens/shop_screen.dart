import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/croma_bottom_nav.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/models/category.dart';
import '../../../../shared/widgets/croma_loading.dart';
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
  bool _isSearchExpanded = false;
  double? _minPrice;
  double? _maxPrice;
  String _sortBy = 'created_at';
  bool _sortAsc = false;
  final TextEditingController _searchController = TextEditingController();
  final List<Product> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final _scrollController = ScrollController();
  bool _initialLoad = true;
  bool _showGrid = false;

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

  void _applyFilterAndShowGrid({String? especial, String? categoryId, String? brand, String? color}) {
    setState(() {
      if (especial != null) _selectedEspecial = especial == _selectedEspecial ? null : especial;
      if (categoryId != null) _selectedCategoryId = categoryId == _selectedCategoryId ? null : categoryId;
      if (brand != null) _selectedBrand = brand == _selectedBrand ? null : brand;
      if (color != null) _selectedColor = color == _selectedColor ? null : color;
      _showGrid = true;
    });
    _loadProducts(reset: true);
  }

  void _clearAllFilters({bool resetGrid = false}) {

    setState(() {
      _searchQuery = '';
      _searchController.clear();
      _minPrice = null;
      _maxPrice = null;
      _selectedCategoryId = null;
      _selectedBrand = null;
      _selectedColor = null;
      _selectedEspecial = null;
      _isSearchExpanded = false;
      if (resetGrid) _showGrid = false;
    });
    _loadProducts(reset: true);
  }

  Color _getColorFromCode(String colorName) {
    final lower = colorName.toLowerCase();
    switch (lower) {
      case 'beige':
      case 'crema': return const Color(0xFFF5F5DC);
      case 'white':
      case 'blanco': return Colors.white;
      case 'black':
      case 'negro': return const Color(0xFF202020);
      case 'blue-grey': return Colors.blueGrey;
      case 'blue':
      case 'azul': return const Color(0xFF0D47A1);
      case 'dark blue':
      case 'azul oscuro': return const Color(0xFF001F3F);
      case 'brown':
      case 'marrón': return Colors.brown;
      case 'green':
      case 'verde': return const Color(0xFF2E7D32);
      case 'olive':
      case 'oliva': return const Color(0xFF556B2F);
      case 'grey':
      case 'gris': return Colors.grey;
      case 'charcoal':
      case 'carbon': return const Color(0xFF36454F);
      case 'orange':
      case 'naranja': return Colors.orange;
      case 'pink':
      case 'rosa': return Colors.pink;
      case 'purple':
      case 'púrpura': return Colors.purple;
      case 'red':
      case 'rojo': return const Color(0xFFB71C1C);
      case 'yellow':
      case 'amarillo': return Colors.yellow;
      case 'ultraviolet': return const Color(0xFF5F4B8B);
      case 'carbon black': return const Color(0xFF1E1E1E);
      case 'burgundy':
      case 'granate': return const Color(0xFF800020);
      default: return Colors.grey.shade300;
    }
  }

  void _showFilterDrawer(
    AsyncValue<List<String>> brandsAsync,
    AsyncValue<List<String>> colorsAsync,
  ) {
    final categoriesAsync = ref.read(categoriesProvider);

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
                              BorderSide(color: Color(0xFF202020), width: 2),
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
                          // ─── ORDENAR POR ───
                          Row(
                            children: const [
                              Icon(Icons.sort, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'ORDENAR POR',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildSortChip('newest', 'Más recientes', setModalState),
                              _buildSortChip('price_asc', 'Precio ↑', setModalState),
                              _buildSortChip('price_desc', 'Precio ↓', setModalState),
                              _buildSortChip('name_asc', 'Nombre A-Z', setModalState),
                            ],
                          ),

                          const SizedBox(height: 24),
                          const Divider(color: Colors.black12),
                          const SizedBox(height: 24),

                          // ─── ESPECIALES ───
                          _buildFilterSection(
                            'ESPECIALES',
                            Icons.star_outline,
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
                          Row(
                            children: const [
                              Icon(Icons.euro, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'PRECIO',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          RangeSlider(
                            values: RangeValues(_minPrice ?? 0, _maxPrice ?? 500),
                            min: 0,
                            max: 500,
                            divisions: 50,
                            activeColor: const Color(0xFF202020),
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
                          categoriesAsync.when(
                            data: (cats) => _buildFilterSection(
                              'CATEGORÍAS',
                              Icons.menu,
                              cats.map((c) => _FilterOption(c.name.toUpperCase(), c.id)).toList(),
                              _selectedCategoryId,
                              (value) {
                                setModalState(() {
                                  _selectedCategoryId =
                                      _selectedCategoryId == value ? null : value;
                                });
                              },
                            ),
                            loading: () => const CromaLoading(),
                            error: (_, __) => const SizedBox.shrink(),
                          ),

                          const SizedBox(height: 24),
                          const Divider(color: Colors.black12),
                          const SizedBox(height: 24),

                          // ─── MARCAS ───
                          brandsAsync.when(
                            data: (brands) => _buildFilterSection(
                              'MARCAS',
                              Icons.business,
                              brands.map((b) => _FilterOption(b.toUpperCase(), b)).toList(),
                              _selectedBrand,
                              (value) {
                                setModalState(() {
                                  _selectedBrand =
                                      _selectedBrand == value ? null : value;
                                });
                              },
                            ),
                            loading: () => const CromaLoading(),
                            error: (_, __) => const SizedBox.shrink(),
                          ),

                          const SizedBox(height: 24),
                          const Divider(color: Colors.black12),
                          const SizedBox(height: 24),

                          // ─── CROMATOGRAFÍA (Colores) ───
                          Row(
                            children: const [
                              Icon(Icons.palette_outlined, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'CROMATOGRAFÍA',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          colorsAsync.when(
                            data: (colors) => Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: colors.map((color) {
                                final selected = _selectedColor == color;
                                return GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      _selectedColor = selected ? null : color;
                                    });
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _getColorFromCode(color),
                                      border: Border.all(
                                        color: selected ? const Color(0xFF202020) : Colors.black12,
                                        width: selected ? 3 : 1,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            loading: () => const CromaLoading(),
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
                              color: Color(0xFF202020), width: 2),
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _loadProducts(reset: true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF202020),
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
    IconData icon,
    List<_FilterOption> options,
    String? selected,
    ValueChanged<String> onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 14,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...options.map((opt) {
          final isSelected = selected == opt.value;
          return InkWell(
            onTap: () => onSelect(opt.value),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? const Color(0xFF202020) : Colors.black12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      opt.label,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                        fontSize: 13,
                        letterSpacing: 1,
                        color: isSelected ? const Color(0xFF202020) : Colors.black87,
                      ),
                    ),
                  ),
                  if (isSelected) 
                     const Icon(Icons.close, size: 16, color: Color(0xFF202020))
                  else
                     const Icon(Icons.chevron_right, size: 16, color: Colors.black26),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSortChip(String value, String label, StateSetter setModalState) {
    // Determine if this is the currently active sort configuration
    bool isSelected = false;
    if (value == 'newest' && _sortBy == 'created_at' && !_sortAsc) isSelected = true;
    if (value == 'price_asc' && _sortBy == 'price' && _sortAsc) isSelected = true;
    if (value == 'price_desc' && _sortBy == 'price' && !_sortAsc) isSelected = true;
    if (value == 'name_asc' && _sortBy == 'name' && _sortAsc) isSelected = true;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setModalState(() {
          switch (value) {
            case 'newest':
              _sortBy = 'created_at';
              _sortAsc = false;
              break;
            case 'price_asc':
              _sortBy = 'price';
              _sortAsc = true;
              break;
            case 'price_desc':
              _sortBy = 'price';
              _sortAsc = false;
              break;
            case 'name_asc':
              _sortBy = 'name';
              _sortAsc = true;
              break;
          }
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
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final brandsAsync = ref.watch(availableBrandsProvider);
    final colorsAsync = ref.watch(availableColorsProvider);

    return Scaffold(
      extendBody: true,
      // AppBar removido para evitar problemas directos
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Global Shop Header ───
          Container(
            padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 16, 24, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.black12, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (_showGrid) ...[
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF202020)),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              setState(() {
                                _showGrid = false;
                                _clearAllFilters(resetGrid: true);
                              });
                            },
                          ),
                          const SizedBox(width: 16),
                        ],
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _showGrid 
                                ? (_selectedCategoryId != null ? 'CATEGORÍA' : (_selectedBrand != null ? 'MARCA' : 'COLECCIÓN'))
                                : 'PRODUCTOS',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                                color: Colors.black38,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'SHOP',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 4,
                                    fontSize: 28,
                                    height: 1.1,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _HeaderCircleButton(
                          icon: _isSearchExpanded ? Icons.close : Icons.search,
                          onPressed: () => setState(() => _isSearchExpanded = !_isSearchExpanded),
                        ),
                        if (_showGrid) ...[
                          const SizedBox(width: 12),
                          _HeaderCircleButton(
                            icon: Icons.tune,
                            badgeCount: _activeFilterCount > 0 ? _activeFilterCount : null,
                            onPressed: () => _showFilterDrawer(ref.read(availableBrandsProvider), ref.read(availableColorsProvider)),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ─── Search Bar (Collapsible) ───
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isSearchExpanded ? 70 : 0,
            curve: Curves.easeInOut,
            child: ClipRect(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: TextField(
                  controller: _searchController,
                  autofocus: _isSearchExpanded,
                  decoration: InputDecoration(
                    hintText: 'Buscar prendas, marcas, colores...',
                    hintStyle: const TextStyle(fontSize: 12),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF202020), size: 18),
                    suffixIcon: IconButton(
                            icon: const Icon(Icons.close, color: Color(0xFF202020), size: 18),
                            onPressed: () {
                              setState(() => _isSearchExpanded = false);
                              if (_searchQuery.isNotEmpty) {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                                _loadProducts(reset: true);
                              }
                            },
                          ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(color: Color(0xFF202020), width: 2),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(color: Color(0xFF202020), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      _searchQuery = value;
                      if (value.isNotEmpty) _showGrid = true;
                    });
                    _loadProducts(reset: true);
                  },
                ),
              ),
            ),
          ),

          if (!_showGrid)
            _buildIndexMenu(brandsAsync, colorsAsync, categoriesAsync)
          else
            ..._buildGridContent(brandsAsync, colorsAsync),
        ],
      ),
      bottomNavigationBar: const CromaBottomNav(currentIndex: 1),
    );
  }

  List<Widget> _buildGridContent(
    AsyncValue<List<String>> brandsAsync,
    AsyncValue<List<String>> colorsAsync,
  ) {
    return [
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
                onTap: () => _clearAllFilters(resetGrid: false),
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

      const SizedBox(height: 8),

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
                            onPressed: () => _clearAllFilters(resetGrid: false),
                            child: const Text('LIMPIAR FILTROS'),
                          ),
                        ],
                      ],
                    ),
                  )
                : GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 120.0),
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
    ];
  }

  Widget _buildIndexMenu(
    AsyncValue<List<String>> brandsAsync,
    AsyncValue<List<String>> colorsAsync,
    AsyncValue<List<Category>> categoriesAsync,
  ) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        children: [
          // SHOP ALL Button
          InkWell(
            onTap: () {
              setState(() {
                _clearAllFilters(resetGrid: false);
                _showGrid = true;
              });
              _loadProducts(reset: true);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF202020),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('TODA NUESTRA ROPA', style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1)),
                      Text('SHOP ALL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 2)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white12),
                    child: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          // ESPECIALES
          _buildFilterSection(
            'ESPECIALES',
            Icons.star_outline,
            const [
              _FilterOption('LANZAMIENTOS LIMITADOS', 'limited'),
              _FilterOption('DESCUENTOS', 'discount'),
              _FilterOption('TENDENCIA', 'viral'),
              _FilterOption('MÁS VENDIDOS', 'bestseller'),
            ],
            _selectedEspecial,
            (value) => _applyFilterAndShowGrid(especial: value),
          ),

          const SizedBox(height: 24),
          const Divider(color: Colors.black12),
          const SizedBox(height: 24),

          // CATEGORÍAS
          categoriesAsync.when(
            data: (cats) => _buildFilterSection(
              'CATEGORÍAS',
              Icons.menu,
              cats.map((c) => _FilterOption(c.name.toUpperCase(), c.id)).toList(),
              _selectedCategoryId,
              (value) => _applyFilterAndShowGrid(categoryId: value),
            ),
            loading: () => const CromaLoading(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 24),
          const Divider(color: Colors.black12),
          const SizedBox(height: 24),

          // MARCAS
          brandsAsync.when(
            data: (brands) => _buildFilterSection(
              'MARCAS',
              Icons.business,
              brands.map((b) => _FilterOption(b.toUpperCase(), b)).toList(),
              _selectedBrand,
              (value) => _applyFilterAndShowGrid(brand: value),
            ),
            loading: () => const CromaLoading(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 24),
          const Divider(color: Colors.black12),
          const SizedBox(height: 24),

          // CROMATOGRAFÍA
          Row(
            children: const [
              Icon(Icons.palette_outlined, size: 20),
              SizedBox(width: 8),
              Text(
                'CROMATOGRAFÍA',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          colorsAsync.when(
            data: (colors) => Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colors.map((color) {
                final selected = _selectedColor == color;
                return GestureDetector(
                  onTap: () => _applyFilterAndShowGrid(color: color),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getColorFromCode(color),
                      border: Border.all(
                        color: selected ? const Color(0xFF202020) : Colors.black12,
                        width: selected ? 3 : 1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            loading: () => const CromaLoading(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 120), // Bottom padding for nav bar
        ],
      ),
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
        backgroundColor: const Color(0xFF202020),
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
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 120.0),
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

class _HeaderCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final int? badgeCount;

  const _HeaderCircleButton({
    required this.icon,
    required this.onPressed,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Badge(
        isLabelVisible: badgeCount != null,
        label: Text(badgeCount?.toString() ?? '', style: const TextStyle(fontSize: 8, color: Colors.white)),
        backgroundColor: Colors.black,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F0),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black12, width: 1),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF202020)),
        ),
      ),
    );
  }
}

