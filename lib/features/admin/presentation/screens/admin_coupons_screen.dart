import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/admin_repository.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/admin_sort_dropdown.dart';

final couponSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');
final couponSortProvider = StateProvider.autoDispose<AdminSortOption>((ref) => AdminSortOption.newest);

class AdminCouponsScreen extends ConsumerWidget {
  const AdminCouponsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsAsync = ref.watch(adminCouponsProvider);
    final searchQuery = ref.watch(couponSearchQueryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminAppBar(title: 'PROMOCIONES Y CUPONES'),
      drawer: const AdminDrawer(),
      body: couponsAsync.when(
        data: (coupons) {
          var filtered = coupons.where((coupon) {
            final code = (coupon['code'] as String).toLowerCase();
            final query = searchQuery.toLowerCase();
            return code.contains(query);
          }).toList();

          final sortOption = ref.watch(couponSortProvider);
          filtered.sort((a, b) {
            switch (sortOption) {
              case AdminSortOption.newest:
                return (b['created_at'] as String? ?? '').compareTo(a['created_at'] as String? ?? '');
              case AdminSortOption.oldest:
                return (a['created_at'] as String? ?? '').compareTo(b['created_at'] as String? ?? '');
              case AdminSortOption.alphabetical:
                return (a['code'] as String).compareTo(b['code'] as String);
              case AdminSortOption.priceDesc:
              case AdminSortOption.stockDesc:
                final numA = a['discount_percent'] as num? ?? 0;
                final numB = b['discount_percent'] as num? ?? 0;
                return numB.compareTo(numA);
              case AdminSortOption.priceAsc:
              case AdminSortOption.stockAsc:
                final numA = a['discount_percent'] as num? ?? 0;
                final numB = b['discount_percent'] as num? ?? 0;
                return numA.compareTo(numB);
              default:
                return 0;
            }
          });

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildIndustrialActionBar(context, ref, filtered.length, coupons.length),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final coupon = filtered[index];
                      return _buildCouponRow(context, ref, coupon);
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

  Widget _buildIndustrialActionBar(BuildContext context, WidgetRef ref, int visibleCount, int totalCount) {
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
                            onChanged: (val) => ref.read(couponSearchQueryProvider.notifier).state = val,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                            ),
                            decoration: InputDecoration(
                              hintText: 'FILTRAR POR CÓDIGO...',
                              hintStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.1),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
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
                  value: ref.watch(couponSortProvider),
                  onChanged: (val) => ref.read(couponSortProvider.notifier).state = val,
                ),
                const SizedBox(width: 12),
                Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.1)),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () => context.push('/admin/coupons/new'),
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
                        Text(
                          'NUEVA PROMO',
                          style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 2.0),
                        ),
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
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(color: Color(0xFF3f3f46), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ref.watch(couponSearchQueryProvider).isEmpty
                          ? '$totalCount CUPONES REGISTRADOS'
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

  Widget _buildCouponRow(BuildContext context, WidgetRef ref, Map<String, dynamic> coupon) {
    final String code = coupon['code'] ?? '';
    final num discountNum = coupon['discount_percent'] ?? 0;
    final int discount = discountNum.toInt();
    final String id = coupon['id'] ?? '';
    final bool isActive = coupon['is_active'] ?? true;
    final String validUntilStr = coupon['valid_until'] ?? '';
    
    DateTime? validUntil;
    if (validUntilStr.isNotEmpty) {
      validUntil = DateTime.tryParse(validUntilStr);
    }
    
    final bool isExpired = validUntil != null && validUntil.isBefore(DateTime.now());
    final bool effectivelyActive = isActive && !isExpired;

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: effectivelyActive ? Colors.white : const Color(0xFFfafafa),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: effectivelyActive ? Colors.green.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: effectivelyActive ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: effectivelyActive ? Colors.green.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.05)),
          ),
          alignment: Alignment.center,
          child: Text(
            '$discount%',
            style: TextStyle(
              color: effectivelyActive ? Colors.green.shade700 : Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        title: Text(
          code.toUpperCase(),
          style: TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.w900, 
            color: effectivelyActive ? Colors.black : Colors.grey, 
            letterSpacing: 2.0
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: effectivelyActive ? Colors.green.shade50 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isExpired ? 'EXPIRADO' : (isActive ? 'ACTIVO' : 'INACTIVO'),
                  style: TextStyle(
                    fontSize: 9, 
                    fontWeight: FontWeight.w900, 
                    letterSpacing: 1.0,
                    color: effectivelyActive ? Colors.green.shade700 : Colors.grey.shade600
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (validUntil != null)
                Text(
                  'HASTA: ${DateFormat('dd/MM/yyyy').format(validUntil)}',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black45),
                ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey, size: 20),
              onPressed: () => context.push('/admin/coupons/$id/edit'),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
              onPressed: () => _confirmDelete(context, ref, id, code),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, String id, String code) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF18181b),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'ELIMINAR CUPÓN',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2.0, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        content: Text(
          '¿SEGURO QUE QUIERES ELIMINAR EL CUPÓN DE DESCUENTO "$code"?',
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
        await ref.read(adminRepositoryProvider).deleteCoupon(id);
        ref.invalidate(adminCouponsProvider);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('CUPÓN ELIMINADO', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.green),
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
