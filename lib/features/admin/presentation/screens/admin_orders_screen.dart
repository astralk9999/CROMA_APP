import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/admin_repository.dart';
import '../../../../shared/widgets/croma_loading.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/admin_sort_dropdown.dart';

final orderSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');
final orderSortProvider = StateProvider.autoDispose<AdminSortOption>((ref) => AdminSortOption.newest);

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(allAdminOrdersProvider);
    final searchQuery = ref.watch(orderSearchQueryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: const AdminAppBar(title: 'GESTI�N DE PEDIDOS'),
      drawer: const AdminDrawer(),
      body: ordersAsync.when(
        data: (orders) {
          var filtered = orders.where((o) {
            final id = (o['id'] as String).toLowerCase();
            final profile = o['profiles'] as Map<String, dynamic>?;
            final name = (profile?['full_name'] as String? ?? '').toLowerCase();
            final email = (profile?['email'] as String? ?? '').toLowerCase();
            final query = searchQuery.toLowerCase();
            return id.contains(query) || name.contains(query) || email.contains(query);
          }).toList();

          final sortOption = ref.watch(orderSortProvider);
          filtered.sort((a, b) {
            switch (sortOption) {
              case AdminSortOption.newest:
                return (b['created_at'] as String? ?? '').compareTo(a['created_at'] as String? ?? '');
              case AdminSortOption.oldest:
                return (a['created_at'] as String? ?? '').compareTo(b['created_at'] as String? ?? '');
              case AdminSortOption.priceDesc:
                final numA = a['total_amount'] as num? ?? 0;
                final numB = b['total_amount'] as num? ?? 0;
                return numB.compareTo(numA);
              case AdminSortOption.priceAsc:
                final numA = a['total_amount'] as num? ?? 0;
                final numB = b['total_amount'] as num? ?? 0;
                return numA.compareTo(numB);
              case AdminSortOption.alphabetical:
              case AdminSortOption.stockDesc:
              case AdminSortOption.stockAsc:
                return 0; // Not strictly applicable to orders
            }
          });

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 24.0, top: 16.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF18181b),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withAlpha(12)),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withAlpha(128), blurRadius: 50, offset: const Offset(0, 20))
                          ],
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(12),
                                  border: Border.all(color: Colors.white.withAlpha(25), width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    const Icon(Icons.search, color: Colors.white54, size: 20),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextField(
                                        onChanged: (val) => ref.read(orderSearchQueryProvider.notifier).state = val,
                                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2.0),
                                        decoration: InputDecoration(
                                          hintText: 'FILTRAR POR ID, E-MAIL...',
                                          hintStyle: TextStyle(color: Colors.white.withAlpha(25), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2.0),
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
                              value: ref.watch(orderSortProvider),
                              onChanged: (val) => ref.read(orderSortProvider.notifier).state = val,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(child: Container(height: 1, color: Colors.black.withAlpha(8))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black.withAlpha(12)),
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
                                  ref.watch(orderSearchQueryProvider).isEmpty
                                      ? '\ PEDIDOS REGISTRADOS'
                                      : '\ DE \ RESULTADOS',
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 2.0),
                                ),
                              ],
                            ),
                          ),
                          Expanded(child: Container(height: 1, color: Colors.black.withAlpha(8))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final order = filtered[index];
                      return _OrderAdminCard(order: order);
                    },
                    childCount: filtered.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
        loading: () => const Center(child: CromaLoading()),
        error: (e, __) => Center(child: Text('Error: \')),
      ),
    );
  }
}

class _OrderAdminCard extends ConsumerWidget {
  final Map<String, dynamic> order;

  const _OrderAdminCard({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = order['profiles'] as Map<String, dynamic>?;
    final status = order['status'].toString();
    final statusColor = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ORD_ID: ${order['id'].toString().substring(0, 12).toUpperCase()}',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: -0.5),
              ),
              _StatusBadge(status: status, color: statusColor),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            (profile?['full_name'] ?? 'USUARIO ANÓN').toString().toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            (profile?['email'] ?? '').toString(),
            style: const TextStyle(color: Colors.black38, fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL: ${(order['total_amount'] as num).toStringAsFixed(2)} €',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
              ),
              PopupMenuButton<String>(
                onSelected: (newStatus) => _updateStatus(ref, context, order['id'], newStatus),
                itemBuilder: (context) => [
                  _statusItem('pending', 'PENDIENTE'),
                  _statusItem('processing', 'PROCESANDO'),
                  _statusItem('shipped', 'ENVIADO'),
                  _statusItem('delivered', 'ENTREGADO'),
                  _statusItem('cancelled', 'CANCELADO'),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'CAMBIAR ESTADO',
                    style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _statusItem(String value, String label) {
    return PopupMenuItem(
      value: value,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  void _updateStatus(WidgetRef ref, BuildContext context, String id, String status) async {
    try {
      await ref.read(adminRepositoryProvider).updateOrderStatus(id, status);
      ref.invalidate(allAdminOrdersProvider);
      
      if (context.mounted) {
        String message = 'Estado actualizado a ${status.toUpperCase()}';
        if (status == 'cancelled') {
          message = 'Pedido cancelado y stock restaurado ✅';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: status == 'cancelled' ? Colors.red : Colors.black,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered': return const Color(0xFF10B981);
      case 'shipped': return Colors.blue;
      case 'pending': return Colors.orange;
      case 'cancelled': return Colors.red;
      default: return Colors.black38;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1),
      ),
    );
  }
}

