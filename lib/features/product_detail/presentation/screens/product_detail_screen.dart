import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../shared/models/cart_item.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/widgets/croma_app_bar.dart';
import '../../../../shared/widgets/scroll_fading_widget.dart';
import '../../../../shared/widgets/croma_loading.dart';
import '../../../shop/data/shop_repository.dart';
import '../../../cart/providers/cart_provider.dart';
import '../widgets/product_gallery.dart';
import '../widgets/size_selector_sheet.dart';
import '../widgets/sticky_add_to_cart.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String slug;

  const ProductDetailScreen({super.key, required this.slug});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  String? _selectedSize;

  void _showSizeSelector(
    BuildContext context,
    List<String> availableSizes,
    Map<String, dynamic>? stockBySizes,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizeSelectorSheet(
        selectedSize: _selectedSize,
        availableSizes: availableSizes,
        stockBySizes: stockBySizes,
        onSizeSelected: (size) {
          setState(() {
            _selectedSize = size;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.slug));
    final isEs = ref.watch(languageProvider) == 'es';

    return productAsync.when(
      data: (product) {
        return Scaffold(
          // AppBar removido para evitar problemas directos
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Gallery
                    ProductGallery(
                      images: product.images,
                      productId: product.id,
                    ),

                    const SizedBox(height: 24),

                    // Product Info
                    ScrollFadingWidget(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Brand
                            if (product.brand != null)
                              Text(
                                product.brand!.toUpperCase(),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                            const SizedBox(height: 8),

                            // Name & Price
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    product.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontSize: 24),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (product.discountActive == true || (product.salePrice != null && product.salePrice! < product.price)) ...[
                                      Text(
                                        '${((product.salePrice ?? product.price).isFinite ? (product.salePrice ?? product.price) : 0.0).toStringAsFixed(2)} €',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.error,
                                            ),
                                      ),
                                      Text(
                                        '${(product.price.isFinite ? product.price : 0.0).toStringAsFixed(2)} €',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey,
                                            ),
                                      ),
                                    ] else ...[
                                      Text(
                                        '${(product.price.isFinite ? product.price : 0.0).toStringAsFixed(2)} €',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.headlineMedium,
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Description
                            if (product.description != null)
                              Text(
                                product.description!,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(height: 1.5),
                              ),

                            const SizedBox(height: 32),

                            // Details (Colors, Fit, Etc)
                            Divider(color: Color(0xFF202020), thickness: 2),
                            const SizedBox(height: 16),
                            _buildDetailRow(
                              isEs ? 'Color' : 'Color',
                              (product.colors.isNotEmpty && product.colors.any((c) => c.trim().isNotEmpty)) 
                                ? product.colors.where((c) => c.trim().isNotEmpty).join(' / ').toUpperCase() 
                                : (isEs ? 'COLOR ÚNICO' : 'ONE COLOR'),
                            ),
                            if (product.category != null) ...[
                              const SizedBox(height: 8),
                              _buildDetailRow(isEs ? 'Categoría' : 'Category', product.category!),
                            ],
                            const SizedBox(height: 16),
                            Divider(color: Color(0xFF202020), thickness: 2),

                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Sticky Add to Cart Bottom Bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: StickyAddToCart(
                  price: product.finalPrice,
                  hasDiscount: product.hasDiscount,
                  originalPrice: product.price,
                  selectedSize: _selectedSize,
                  isOutOfStock: (product.stockBySizes?.values.fold<int>(0, (sum, quantity) => sum + (quantity as int? ?? 0)) ?? 0) <= 0,
                  isUpcoming: (product.launchDate ?? product.availableFrom)?.isAfter(DateTime.now()) ?? false,
                  onSizeSelectorTap: () => _showSizeSelector(
                    context,
                    product.sizes,
                    product.stockBySizes,
                  ),
                  onAddToCart: () {
                    if (_selectedSize == null) {
                      _showSizeSelector(
                        context,
                        product.sizes,
                        product.stockBySizes,
                      );
                      return;
                    }

                    final stock =
                        (product.stockBySizes?[_selectedSize] as int?) ?? 0;

                    final cartItem = CartItem(
                      id: const Uuid().v4(),
                      productId: product.id,
                      name: product.name,
                      price: product.finalPrice,
                      image: product.images.isNotEmpty
                          ? product.images.first
                          : '',
                      size: _selectedSize!,
                      quantity: 1,
                      maxStock: stock,
                    );

                    ref.read(cartNotifierProvider.notifier).addItem(cartItem);

                    // Show confirmation SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${product.name} ($_selectedSize) añadido al carrito',
                        ),
                        backgroundColor: const Color(0xFF202020),
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'VER CARRITO',
                          textColor: Colors.white,
                          onPressed: () => context.push('/cart'),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Back Button (Floating)
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.8),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => context.pop(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CromaLoading()),
      ),
      error: (err, stack) => Scaffold(
        appBar: const CromaAppBar(),
        body: Center(child: Text('Error al cargar producto: $err')),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: Colors.grey.shade600),
        ),
        Text(
          value.toUpperCase(),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
