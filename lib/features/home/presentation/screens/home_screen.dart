import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/croma_app_bar.dart';
import '../../../../shared/widgets/croma_bottom_nav.dart';
import '../../../../shared/widgets/scroll_fading_widget.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/models/product.dart';
import '../../data/home_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bestSellersAsync = ref.watch(bestSellersProvider);
    final limitedDropsAsync = ref.watch(limitedDropsProvider);
    final viralTrendsAsync = ref.watch(viralTrendsProvider);
    final discountsAsync = ref.watch(discountedProductsProvider);
    final comingSoonAsync = ref.watch(comingSoonProvider);

    return Scaffold(
      appBar: const CromaAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ─── HERO ───
            ScrollFadingWidget(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 500,
                    width: double.infinity,
                    color: Colors.black,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo_c_horns.png',
                        height: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'STREETWEAR CULTURE',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white70,
                              fontSize: 14,
                              letterSpacing: 4,
                            ),
                      ),
                      const SizedBox(height: 32),
                      OutlinedButton(
                        onPressed: () => context.go('/shop'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white, width: 2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: const Text(
                          'EXPLORAR',
                          style: TextStyle(
                            letterSpacing: 3,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ─── BESTSELLERS (Horizontal Carousel) ───
            const SizedBox(height: 48),
            _buildSectionHeader(context, 'BESTSELLERS'),
            const SizedBox(height: 16),
            bestSellersAsync.when(
              data: (products) => _buildHorizontalCarousel(context, products),
              loading: () => _buildLoadingList(),
              error: (err, _) => _buildErrorWidget(err),
            ),

            // ─── LIMITED DROPS (Full-width stacked cards) ───
            const SizedBox(height: 56),
            Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  _buildSectionHeader(context, 'LIMITED DROPS', light: true),
                  const SizedBox(height: 8),
                  Text(
                    'Ediciones exclusivas. No vuelven.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white60,
                          letterSpacing: 1.5,
                        ),
                  ),
                  const SizedBox(height: 24),
                  limitedDropsAsync.when(
                    data: (products) =>
                        _buildStackedCards(context, products),
                    loading: () => _buildLoadingList(light: true),
                    error: (err, _) => _buildErrorWidget(err, light: true),
                  ),
                ],
              ),
            ),

            // ─── DISCOUNTS (2-column grid, max 4) ───
            const SizedBox(height: 56),
            _buildSectionHeader(context, 'DESCUENTOS'),
            const SizedBox(height: 8),
            Text(
              'Ofertas que no puedes dejar escapar',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    letterSpacing: 1.2,
                  ),
            ),
            const SizedBox(height: 24),
            discountsAsync.when(
              data: (products) => _buildCompactGrid(context, products),
              loading: () => _buildLoadingGrid(),
              error: (err, _) => _buildErrorWidget(err),
            ),

            // ─── COMING SOON (Large feature card) ───
            const SizedBox(height: 56),
            comingSoonAsync.when(
              data: (products) =>
                  products.isEmpty
                      ? const SizedBox.shrink()
                      : _buildComingSoonSection(context, products),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // ─── VIRAL TRENDS (Different carousel style) ───
            const SizedBox(height: 56),
            _buildSectionHeader(context, 'VIRAL TRENDS'),
            const SizedBox(height: 8),
            Text(
              'Lo que está rompiendo en redes',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    letterSpacing: 1.2,
                  ),
            ),
            const SizedBox(height: 24),
            viralTrendsAsync.when(
              data: (products) =>
                  _buildWideCarousel(context, products),
              loading: () => _buildLoadingList(),
              error: (err, _) => _buildErrorWidget(err),
            ),

            // ─── VALUE PROPS ───
            const SizedBox(height: 64),
            ScrollFadingWidget(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    _buildValueProp(context, Icons.local_shipping_outlined,
                        'ENVÍO EXPRESS', '24/48h a toda la península'),
                    const SizedBox(height: 32),
                    _buildValueProp(context, Icons.sync_outlined,
                        'CAMBIOS GRATIS', '30 días para devoluciones'),
                    const SizedBox(height: 32),
                    _buildValueProp(context, Icons.lock_outline,
                        'PAGO SEGURO', 'Stripe & Apple Pay'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
      bottomNavigationBar: const CromaBottomNav(currentIndex: 0),
    );
  }

  // ─── SECTION HEADER ───
  Widget _buildSectionHeader(BuildContext context, String title,
      {bool light = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Container(width: 4, height: 24, color: light ? Colors.white : Colors.black),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: light ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
          ),
        ],
      ),
    );
  }

  // ─── HORIZONTAL CAROUSEL (Bestsellers) ───
  Widget _buildHorizontalCarousel(BuildContext context, List<Product> products) {
    if (products.isEmpty) {
      return const SizedBox(height: 80, child: Center(child: Text('Sin productos')));
    }
    return SizedBox(
      height: 320,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 180,
            child: ProductCard(
              product: products[index],
              onTap: () => context.push('/product/${products[index].slug}'),
            ),
          );
        },
      ),
    );
  }

  // ─── STACKED CARDS (Limited Drops) ───
  Widget _buildStackedCards(BuildContext context, List<Product> products) {
    if (products.isEmpty) {
      return const SizedBox(
        height: 80,
        child: Center(child: Text('Sin drops', style: TextStyle(color: Colors.white60))),
      );
    }
    return SizedBox(
      height: 380,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.85),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () => context.push('/product/${product.slug}'),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (product.images.isNotEmpty)
                      Image.network(product.images.first, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: Colors.grey[900]),
                      )
                    else
                      Container(color: Colors.grey[900]),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withAlpha(200)],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 24,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.brand != null)
                            Text(
                              product.brand!.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 11,
                                letterSpacing: 2,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            product.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${product.price.toStringAsFixed(2)} €',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        color: Colors.white,
                        child: const Text(
                          'LIMITED',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── COMPACT GRID (Discounts, max 4) ───
  Widget _buildCompactGrid(BuildContext context, List<Product> products) {
    if (products.isEmpty) {
      return const SizedBox(height: 80, child: Center(child: Text('Sin descuentos disponibles')));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.55,
          crossAxisSpacing: 16,
          mainAxisSpacing: 24,
        ),
        itemCount: products.length > 4 ? 4 : products.length,
        itemBuilder: (context, index) {
          return ProductCard(
            product: products[index],
            onTap: () => context.push('/product/${products[index].slug}'),
          );
        },
      ),
    );
  }

  // ─── COMING SOON SECTION ───
  Widget _buildComingSoonSection(BuildContext context, List<Product> products) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4, height: 24, color: Colors.black),
              const SizedBox(width: 12),
              Text(
                'COMING SOON',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...products.take(3).map((product) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: () => context.push('/product/${product.slug}'),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: product.images.isNotEmpty
                            ? Image.network(product.images.first, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.image))
                            : const Icon(Icons.image),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            if (product.availableFrom != null)
                              Text(
                                'Disponible: ${_formatDate(product.availableFrom!)}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Icon(Icons.notifications_none, size: 20),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  // ─── WIDE CAROUSEL (Viral Trends — larger cards) ───
  Widget _buildWideCarousel(BuildContext context, List<Product> products) {
    if (products.isEmpty) {
      return const SizedBox(height: 80, child: Center(child: Text('Sin tendencias')));
    }
    return SizedBox(
      height: 260,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () => context.push('/product/${product.slug}'),
            child: Container(
              width: 280,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey[100],
                      child: product.images.isNotEmpty
                          ? Image.network(product.images.first, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Center(child: Icon(Icons.image)))
                          : const Center(child: Icon(Icons.image)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (product.brand != null)
                                Text(
                                  product.brand!,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 11,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          '${product.price.toStringAsFixed(2)} €',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildLoadingGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.55,
          crossAxisSpacing: 16, mainAxisSpacing: 24,
        ),
        itemCount: 4,
        itemBuilder: (_, __) => const ProductCardShimmer(),
      ),
    );
  }

  Widget _buildLoadingList({bool light = false}) {
    return SizedBox(
      height: 320,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, __) => const SizedBox(width: 180, child: ProductCardShimmer()),
      ),
    );
  }

  Widget _buildErrorWidget(Object err, {bool light = false}) {
    return Center(
      child: Text(
        'Error: $err',
        style: TextStyle(color: light ? Colors.white60 : Colors.red),
      ),
    );
  }

  Widget _buildValueProp(
      BuildContext context, IconData icon, String title, String subtitle) {
    return Column(
      children: [
        Icon(icon, size: 48, color: Colors.black),
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
        ),
        const SizedBox(height: 8),
        Text(subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center),
      ],
    );
  }
}
