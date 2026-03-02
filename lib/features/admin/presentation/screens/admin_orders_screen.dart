import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/admin_repository.dart';
import '../../../../shared/widgets/croma_loading.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/admin_sort_dropdown.dart';

final orderSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');
final orderSortProvider = StateProvider.autoDispose<AdminSortOption>(
  (ref) => AdminSortOption.newest,
);

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(allAdminOrdersProvider);
    final searchQuery = ref.watch(orderSearchQueryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminAppBar(title: 'PEDIDOS'),
      drawer: const AdminDrawer(),
      body: ordersAsync.when(
        data: (orders) {
          final filteredOrders = orders.where((order) {
            final query = searchQuery.toLowerCase();
            final profile = order['profiles'] as Map<String, dynamic>?;
            final userEmail = profile?['email'] as String? ?? '';
            final id = order['id'] as String? ?? '';
            final status = order['status'] as String? ?? '';

            return id.toLowerCase().contains(query) ||
                userEmail.toLowerCase().contains(query) ||
                status.toLowerCase().contains(query);
          }).toList();

          if (filteredOrders.isEmpty) {
            return const Center(child: Text('No se encontraron pedidos'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: filteredOrders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = filteredOrders[index];
              return _OrderCard(order: order);
            },
          );
        },
        loading: () => const CromaLoading(),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final status = order['status'] as String? ?? 'pending';
    final total = (order['total_amount'] as num?)?.toDouble() ?? 0.0;
    final profile = order['profiles'] as Map<String, dynamic>?;
    final userEmail = profile?['email'] as String? ?? 'SIN EMAIL';
    final color = _getStatusColor(status);

    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
      child: ExpansionTile(
        title: Text(
          'PEDIDO #${(order['id'] as String? ?? '').substring(0, 8).toUpperCase()}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userEmail,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            _StatusBadge(status: status, color: color),
          ],
        ),
        trailing: Text(
          '${total.toStringAsFixed(2)}€',
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PRODUCTOS:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
                const SizedBox(height: 8),
                // Map items here
                if (order['items'] != null)
                  ...(order['items'] as List).map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${item['quantity']}x ${item['product_name']}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            '${(item['price'] as num?)?.toDouble().toStringAsFixed(2)}€',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'FECHA:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      (order['created_at'] as String? ?? '').substring(0, 16),
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: Update status logic
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                          shape: const RoundedRectangleBorder(),
                        ),
                        child: const Text(
                          'ACTUALIZAR ESTADO',
                          style: TextStyle(color: Colors.black, fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return const Color(0xFF10B981);
      case 'shipped':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.black38;
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
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
