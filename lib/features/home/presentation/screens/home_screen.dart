import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/croma_app_bar.dart';
import '../../../../shared/widgets/croma_bottom_nav.dart';
import '../../../../shared/widgets/scroll_fading_widget.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/cached_image.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/models/product.dart';
import '../../data/home_repository.dart';
import '../../../shop/data/shop_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bestSellersAsync = ref.watch(bestSellersProvider);
    final limitedDropsAsync = ref.watch(limitedDropsProvider);
    final viralTrendsAsync = ref.watch(viralTrendsProvider);
    final discountsAsync = ref.watch(discountedProductsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: const CromaAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ═══════════════════════════════════════════
            // ─── HERO ───
            // ═══════════════════════════════════════════
            ScrollFadingWidget(
              child: Container(
                height: 520,
                width: double.infinity,
                color: Colors.black,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Subtle grid pattern
                    Positioned.fill(
                      child: CustomPaint(painter: _GridPainter()),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo_c_horns.png',
                          height: 100,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'URBAN COLLECTIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'STREETWEAR CULTURE',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                            letterSpacing: 6,
                          ),
                        ),
                        const SizedBox(height: 36),
                        OutlinedButton(
                          onPressed: () => context.go('/shop'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white, width: 2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 18,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Text(
                            'EXPLORAR',
                            style: TextStyle(
                              letterSpacing: 4,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ═══════════════════════════════════════════
            // ─── PHILOSOPHY / NUESTRA FILOSOFÍA ───
            // ═══════════════════════════════════════════
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 56),
              color: const Color(0xFFF5F5F0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 3,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Nuestra Filosofía',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'MÁS QUE MODA, UN ESTILO DE VIDA.',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'En CROMA creemos que la ropa es el lienzo de tu identidad. '
                    'Cada pieza está diseñada con una atención obsesiva al detalle, '
                    'mezclando la rudeza de la calle con la precisión de la alta costura.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.7,
                          color: Colors.black54,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // ═══════════════════════════════════════════
            // ─── DROPS / 2026 ───
            // ═══════════════════════════════════════════
            Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Container(width: 4, height: 28, color: Colors.white),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DROPS',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 3,
                                  ),
                            ),
                            Text(
                              '2026',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: Colors.white60,
                                    letterSpacing: 6,
                                  ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => context.go('/shop'),
                          child: const Text(
                            'VER TODO →',
                            style: TextStyle(
                              color: Colors.white60,
                              letterSpacing: 1,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  limitedDropsAsync.when(
                    data: (products) => _buildDropsCarousel(context, products),
                    loading: () => _buildLoadingCarousel(light: true),
                    error: (err, _) => _buildErrorWidget(err, light: true),
                  ),
                ],
              ),
            ),

            // ═══════════════════════════════════════════
            // ─── CATEGORÍAS ───
            // ═══════════════════════════════════════════
            const SizedBox(height: 48),
            _buildSectionHeader(context, 'CATEGORÍAS'),
            const SizedBox(height: 24),
            categoriesAsync.when(
              data: (categories) => _buildCategoriesGrid(context, categories),
              loading: () => const SizedBox(
                height: 200,
                child: Center(
                    child: CircularProgressIndicator(color: Colors.black)),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // ═══════════════════════════════════════════
            // ─── TENDENCIA ───
            // ═══════════════════════════════════════════
            const SizedBox(height: 48),
            _buildSectionHeader(context, 'TENDENCIA'),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Lo que está rompiendo en redes',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
              ),
            ),
            const SizedBox(height: 20),
            viralTrendsAsync.when(
              data: (products) => _buildHorizontalCarousel(context, products),
              loading: () => _buildLoadingCarousel(),
              error: (err, _) => _buildErrorWidget(err),
            ),

            // ═══════════════════════════════════════════
            // ─── OFERTAS / DESCUENTOS ───
            // ═══════════════════════════════════════════
            const SizedBox(height: 48),
            Container(
              color: const Color(0xFFF5F5F0),
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  _buildSectionHeader(context, 'OFERTAS'),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Ofertas que no puedes dejar escapar',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                            letterSpacing: 1.2,
                          ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  discountsAsync.when(
                    data: (products) => _buildCompactGrid(context, products),
                    loading: () => _buildLoadingGrid(),
                    error: (err, _) => _buildErrorWidget(err),
                  ),
                ],
              ),
            ),

            // ═══════════════════════════════════════════
            // ─── MÁS VENDIDOS / BESTSELLERS ───
            // ═══════════════════════════════════════════
            const SizedBox(height: 48),
            _buildSectionHeader(context, 'MÁS VENDIDOS'),
            const SizedBox(height: 20),
            bestSellersAsync.when(
              data: (products) => _buildHorizontalCarousel(context, products),
              loading: () => _buildLoadingCarousel(),
              error: (err, _) => _buildErrorWidget(err),
            ),

            // ═══════════════════════════════════════════
            // ─── NEWSLETTER ───
            // ═══════════════════════════════════════════
            const SizedBox(height: 56),
            Container(
              width: double.infinity,
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 56),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo_c_horns.png',
                    height: 40,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'ÚNETE A LA RESISTENCIA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Consigue acceso exclusivo a los próximos drops y un 10% de descuento',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.white38, width: 1),
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'tu@email.com',
                            style: TextStyle(color: Colors.white38, fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: const Text(
                          'UNIRSE',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ═══════════════════════════════════════════
            // ─── VALUE PROPS ───
            // ═══════════════════════════════════════════
            const SizedBox(height: 48),
            ScrollFadingWidget(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildValueProp(
                        context,
                        Icons.workspace_premium_outlined,
                        'Calidad\nPremium',
                        'Materiales de grado industrial',
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 80,
                      color: Colors.black12,
                    ),
                    Expanded(
                      child: _buildValueProp(
                        context,
                        Icons.local_shipping_outlined,
                        'Envío\nRápido',
                        '24-48h en península',
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 80,
                      color: Colors.black12,
                    ),
                    Expanded(
                      child: _buildValueProp(
                        context,
                        Icons.sync_outlined,
                        'Devolución\nFácil',
                        '30 días sin compromiso',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 56),

            // ═══════════════════════════════════════════
            // ─── FOOTER ───
            // ═══════════════════════════════════════════
            Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              width: double.infinity,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/chromakopia_logo.png',
                    height: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Moda urbana premium para la era moderna.',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _footerLink(context, 'Sobre CROMA', '/about'),
                      const SizedBox(width: 16),
                      _footerLink(context, 'Contacto', '/contact'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '© 2026 CROMA. Todos los derechos reservados.',
                    style: TextStyle(color: Colors.white30, fontSize: 10),
                  ),
                ],
              ),
            ),
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
          Container(
              width: 4,
              height: 28,
              color: light ? Colors.white : Colors.black),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: light ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                ),
          ),
        ],
      ),
    );
  }

  // ─── DROPS CAROUSEL (large cards with gradient overlay) ───
  Widget _buildDropsCarousel(BuildContext context, List<Product> products) {
    if (products.isEmpty) {
      return const SizedBox(
        height: 80,
        child: Center(
            child: Text('Sin drops', style: TextStyle(color: Colors.white60))),
      );
    }
    return SizedBox(
      height: 400,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.82),
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
                      CachedImage(
                        imageUrl: product.images.first,
                        fit: BoxFit.cover,
                      )
                    else
                      Container(color: Colors.grey[900]),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withAlpha(200),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 24,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.brand != null)
                            Text(
                              product.brand!.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white54,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
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

  // ─── CATEGORIES GRID ───
  Widget _buildCategoriesGrid(
      BuildContext context, List<dynamic> categories) {
    if (categories.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return GestureDetector(
            onTap: () => context.push('/shop?category=${cat.id}'),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey[900]!,
                          Colors.black,
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      cat.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                      ),
                      textAlign: TextAlign.center,
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

  // ─── HORIZONTAL CAROUSEL ───
  Widget _buildHorizontalCarousel(
      BuildContext context, List<Product> products) {
    if (products.isEmpty) {
      return const SizedBox(
          height: 80, child: Center(child: Text('Sin productos')));
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
              onTap: () =>
                  context.push('/product/${products[index].slug}'),
            ),
          );
        },
      ),
    );
  }

  // ─── COMPACT GRID (max 4) ───
  Widget _buildCompactGrid(BuildContext context, List<Product> products) {
    if (products.isEmpty) {
      return const SizedBox(
          height: 80,
          child: Center(child: Text('Sin descuentos disponibles')));
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
            onTap: () =>
                context.push('/product/${products[index].slug}'),
          );
        },
      ),
    );
  }

  // ─── VALUE PROP ───
  Widget _buildValueProp(
      BuildContext context, IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Colors.black),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 1,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _footerLink(BuildContext context, String label, String route) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 12,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white30,
        ),
      ),
    );
  }

  Widget _buildLoadingCarousel({bool light = false}) {
    return SizedBox(
      height: 320,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, __) =>
            const SizedBox(width: 180, child: ProductCardShimmer()),
      ),
    );
  }

  Widget _buildLoadingGrid() {
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
        itemCount: 4,
        itemBuilder: (_, __) => const ProductCardShimmer(),
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
}

// ─── Subtle grid pattern for hero ───
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 0.5;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
