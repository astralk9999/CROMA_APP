import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/admin_repository.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/admin_sort_dropdown.dart';

final productSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');
final productStatusFilterProvider = StateProvider.autoDispose<String>((ref) => 'all');
final productSortProvider = StateProvider.autoDispose<AdminSortOption>((ref) => AdminSortOption.newest);

class AdminProductsScreen extends ConsumerWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(adminProductsProvider);
    final searchQuery = ref.watch(productSearchQueryProvider);
    final statusFilter = ref.watch(productStatusFilterProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminAppBar(title: 'CATÁLOGO MAESTRO'),
      drawer: const AdminDrawer(),
      body: productsAsync.when(
        data: (products) {
          // Calculate insights
          int totalStock = 0;
          double totalValue = 0;
          int hiddenCount = 0;
          int outOfStockCount = 0;

          for (final p in products) {
            final stockMap = p['stock_by_sizes'] as Map<String, dynamic>?;
            int pStock = 0;
            if (stockMap != null) {
              pStock = stockMap.values.fold(0, (sum, val) => sum + (val as int));
            }
            totalStock += pStock;
            
            final price = (p['price'] as num?)?.toDouble() ?? 0.0;
            totalValue += price * pStock;

            if (p['is_hidden'] == true) hiddenCount++;
            if (pStock == 0) outOfStockCount++;
          }

          // Filter products
          var filtered = products.where((p) {
            final name = (p['name'] as String).toLowerCase();
            final query = searchQuery.toLowerCase();
            if (!name.contains(query)) return false;

            final isHidden = p['is_hidden'] == true;
            final stockMap = p['stock_by_sizes'] as Map<String, dynamic>?;
            final pStock = stockMap != null ? stockMap.values.fold(0, (sum, val) => sum + (val as int)) : 0;

            if (statusFilter == 'active' && (isHidden || pStock == 0)) return false;
            if (statusFilter == 'hidden' && !isHidden) return false;
            if (statusFilter == 'out_of_stock' && pStock > 0) return false;

            return true;
          }).toList();

          final sortOption = ref.watch(productSortProvider);
          filtered.sort((a, b) {
            switch (sortOption) {
              case AdminSortOption.newest:
                return (b['created_at'] as String? ?? '').compareTo(a['created_at'] as String? ?? '');
              case AdminSortOption.oldest:
                return (a['created_at'] as String? ?? '').compareTo(b['created_at'] as String? ?? '');
              case AdminSortOption.alphabetical:
                return (a['name'] as String).compareTo(b['name'] as String);
              case AdminSortOption.priceDesc:
                final priceA = (a['price'] as num?)?.toDouble() ?? 0.0;
                final priceB = (b['price'] as num?)?.toDouble() ?? 0.0;
                return priceB.compareTo(priceA);
              case AdminSortOption.priceAsc:
                final priceA = (a['price'] as num?)?.toDouble() ?? 0.0;
                final priceB = (b['price'] as num?)?.toDouble() ?? 0.0;
                return priceA.compareTo(priceB);
              case AdminSortOption.stockDesc:
                final mapA = a['stock_by_sizes'] as Map<String, dynamic>? ?? {};
                final mapB = b['stock_by_sizes'] as Map<String, dynamic>? ?? {};
                final stockA = mapA.values.fold<int>(0, (sum, val) => sum + (val as num).toInt());
                final stockB = mapB.values.fold<int>(0, (sum, val) => sum + (val as num).toInt());
                return stockB.compareTo(stockA);
              case AdminSortOption.stockAsc:
                final mapA = a['stock_by_sizes'] as Map<String, dynamic>? ?? {};
                final mapB = b['stock_by_sizes'] as Map<String, dynamic>? ?? {};
                final stockA = mapA.values.fold<int>(0, (sum, val) => sum + (val as num).toInt());
                final stockB = mapB.values.fold<int>(0, (sum, val) => sum + (val as num).toInt());
                return stockA.compareTo(stockB);
            }
          });

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildInsightsBar(totalStock, totalValue, hiddenCount, outOfStockCount),
              ),
              SliverToBoxAdapter(
                child: _buildIndustrialActionBar(context, ref, filtered.length, products.length, statusFilter),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = filtered[index];
                      return _ProductAdminRow(product: product);
                    },
                    childCount: filtered.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildInsightsBar(int totalStock, double totalValue, int hiddenCount, int outOfStockCount) {
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFfafafa),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInsightItem('VALOR TOTAL', '${totalValue.toStringAsFixed(0)} €', Icons.account_balance_wallet_outlined),
          _buildInsightItem('EN INVENTARIO', '$totalStock', Icons.inventory_2_outlined),
          _buildInsightItem('SIN STOCK', '$outOfStockCount', Icons.warning_amber_rounded, color: Colors.orange.shade700),
          _buildInsightItem('OCULTOS', '$hiddenCount', Icons.visibility_off_outlined, color: Colors.grey.shade600),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String label, String value, IconData icon, {Color color = Colors.black}) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color, letterSpacing: -0.5)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: Colors.black.withValues(alpha: 0.4))),
      ],
    );
  }

  Widget _buildIndustrialActionBar(BuildContext context, WidgetRef ref, int visibleCount, int totalCount, String currentFilter) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0, top: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF18181b),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 50, offset: const Offset(0, 20))
              ],
            ),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.white54, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            onChanged: (val) => ref.read(productSearchQueryProvider.notifier).state = val,
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2.0),
                            decoration: InputDecoration(
                              hintText: 'IDENTIFICAR EDICIÓN...',
                              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.1), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2.0),
                              border: InputBorder.none,
                              filled: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                AdminSortDropdown(
                  value: ref.watch(productSortProvider),
                  onChanged: (val) => ref.read(productSortProvider.notifier).state = val,
                ),
                const SizedBox(width: 12),
                
                // Status Filter Dropdown
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: currentFilter,
                      dropdownColor: const Color(0xFF27272a),
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 16),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                      onChanged: (val) {
                        if (val != null) ref.read(productStatusFilterProvider.notifier).state = val;
                      },
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('TODOS LOS ESTADOS')),
                        DropdownMenuItem(value: 'active', child: Text('EN VENTA (ACTIVOS)')),
                        DropdownMenuItem(value: 'hidden', child: Text('OCULTOS DEL PÚBLICO')),
                        DropdownMenuItem(value: 'out_of_stock', child: Text('AGOTADOS (SIN STOCK)')),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.1)),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () => context.push('/admin/products/new'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add, color: Colors.black, size: 16),
                        SizedBox(width: 8),
                        Text('NUEVA EDICIÓN', style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: Container(height: 1, color: Colors.black.withValues(alpha: 0.03))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Row(
                  children: [
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF3f3f46), shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(
                      ref.watch(productSearchQueryProvider).isEmpty && currentFilter == 'all'
                          ? '$totalCount EDICIONES DETECTADAS'
                          : '$visibleCount DE $totalCount RESULTADOS',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 2.0),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container(height: 1, color: Colors.black.withValues(alpha: 0.03))),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductAdminRow extends ConsumerWidget {
  final Map<String, dynamic> product;

  const _ProductAdminRow({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String id = product['id'] ?? '';
    final String name = product['name'] ?? '';
    final isHidden = product['is_hidden'] == true;
    final images = product['images'] as List<dynamic>?;
    final imageUrl = images != null && images.isNotEmpty ? images[0] as String : null;
    final categoryName = product['categories']?['name']?.toString() ?? 'Sin categoría';
    final price = (product['price'] as num?)?.toDouble() ?? 0.0;
    
    // Calculate stock
    final stockMap = product['stock_by_sizes'] as Map<String, dynamic>?;
    int totalStock = 0;
    if (stockMap != null) {
      totalStock = stockMap.values.fold(0, (sum, val) => sum + (val as int));
    }
    final isOutOfStock = totalStock == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFf4f4f5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
            image: imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                    colorFilter: isHidden || isOutOfStock
                        ? ColorFilter.mode(Colors.grey.withValues(alpha: 0.8), BlendMode.saturation)
                        : null,
                  )
                : null,
          ),
          child: imageUrl == null
              ? const Icon(Icons.image_not_supported_outlined, color: Colors.black26)
              : null,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                name.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: -0.5,
                  color: isHidden ? Colors.black54 : Colors.black,
                  decoration: isHidden ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            if (isHidden)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
                child: const Text('OCULTO', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.black54)),
              ),
            if (isOutOfStock && !isHidden)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.red.shade100)),
                child: Text('AGOTADO', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.red.shade700)),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Text(
                categoryName.toUpperCase(),
                style: const TextStyle(color: Colors.black45, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.5),
              ),
              const SizedBox(width: 12),
              const Text('•', style: TextStyle(color: Colors.black26)),
              const SizedBox(width: 12),
              Text(
                'STOCK: $totalStock',
                style: TextStyle(
                  color: isOutOfStock ? Colors.red.shade700 : Colors.black54,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(width: 12),
              const Text('•', style: TextStyle(color: Colors.black26)),
              const SizedBox(width: 12),
              Text(
                '${price.toStringAsFixed(2)} €',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.black),
              ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 20,
                color: isHidden ? Colors.orange : Colors.grey.shade400,
              ),
              onPressed: () => _toggleVisibility(ref, id, !isHidden),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey, size: 20),
              onPressed: () => context.push('/admin/products/$id/edit'),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
              onPressed: () => _confirmDelete(context, ref, id, name),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleVisibility(WidgetRef ref, String id, bool hide) async {
    await ref.read(adminRepositoryProvider).toggleProductVisibility(id, hide);
    ref.invalidate(adminProductsProvider);
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, String id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF18181b),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'ELIMINAR EDICIÓN',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2.0, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        content: Text(
          '¿ELIMINAR PERMANENTEMENTE "$name"?',
          style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('CANCELAR', style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('CONFIRMAR', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(adminRepositoryProvider).deleteProduct(id);
        ref.invalidate(adminProductsProvider);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('PRODUCTO ELIMINADO', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ERROR: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }
}
