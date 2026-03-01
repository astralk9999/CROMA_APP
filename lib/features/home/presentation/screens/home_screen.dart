import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/croma_app_bar.dart';
import '../../../../shared/widgets/croma_bottom_nav.dart';
import '../../../../shared/widgets/scroll_fading_widget.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../data/home_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bestSellersAsync = ref.watch(bestSellersProvider);
    final limitedDropsAsync = ref.watch(limitedDropsProvider);

    return Scaffold(
      appBar: const CromaAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Hero Section con Marquee
            ScrollFadingWidget(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 500,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/hero_home.jpg',
                        ), // Necesitamos esta imagen o usar una URL de Cloudinary real
                        fit: BoxFit.cover,
                      ),
                      color: Colors.black, // Placeholder si no hay imagen
                    ),
                  ),
                  Container(height: 500, color: Colors.black.withOpacity(0.3)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'NUEVA COLECCIÓN',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'FALL WINTER 24',
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(color: Colors.white, fontSize: 48),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () => context.go('/shop'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('VER TODO'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Best Sellers
            const SizedBox(height: 48),
            Text(
              'MÁS VENDIDOS',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            bestSellersAsync.when(
              data: (products) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ScrollFadingWidget(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.55,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 24,
                        ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        onTap: () => context.push('/product/${product.slug}'),
                      );
                    },
                  ),
                ),
              ),
              loading: () => _buildLoadingGrid(),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),

            // 3. Limited Drops
            const SizedBox(height: 64),
            Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  Text(
                    'LIMITED DROPS',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  limitedDropsAsync.when(
                    data: (products) => SizedBox(
                      height: 350,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return SizedBox(
                            width: 200,
                            child: ScrollFadingWidget(
                              child: ProductCard(
                                product: product,
                                onTap: () =>
                                    context.push('/product/${product.slug}'),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    loading: () => _buildLoadingList(),
                    error: (err, stack) => Center(
                      child: Text(
                        'Error: $err',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 4. Value Props
            const SizedBox(height: 64),
            ScrollFadingWidget(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    _buildValueProp(
                      context,
                      Icons.local_shipping_outlined,
                      'ENVÍO EXPRESS',
                      '24/48h a toda la península',
                    ),
                    const SizedBox(height: 32),
                    _buildValueProp(
                      context,
                      Icons.sync_outlined,
                      'CAMBIOS GRATIS',
                      '30 días para devoluciones',
                    ),
                    const SizedBox(height: 32),
                    _buildValueProp(
                      context,
                      Icons.lock_outline,
                      'PAGO SEGURO',
                      'Stripe & Apple Pay',
                    ),
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
        itemBuilder: (context, index) => const ProductCardShimmer(),
      ),
    );
  }

  Widget _buildLoadingList() {
    return SizedBox(
      height: 350,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) =>
            const SizedBox(width: 200, child: ProductCardShimmer()),
      ),
    );
  }

  Widget _buildValueProp(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
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
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
