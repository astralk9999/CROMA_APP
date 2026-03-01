import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/account_repository.dart';
import '../../../../shared/widgets/croma_app_bar.dart';
import '../../../../shared/widgets/croma_loading.dart';
import '../../../../core/providers/language_provider.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(userOrdersProvider);
    final isEs = ref.watch(languageProvider) == 'es';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CromaAppBar(
        title: Text(
          isEs ? 'MIS PEDIDOS' : 'MY ORDERS',
          style: const TextStyle(
            color: Color(0xFF202020),
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.black12),
                  const SizedBox(height: 16),
                  Text(
                    isEs ? 'No tienes pedidos aún' : 'No orders yet',
                    style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final order = orders[index];
              return _OrderCard(order: order, isEs: isEs);
            },
          );
        },
        loading: () => const Center(child: CromaLoading()),
        error: (e, __) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final dynamic order;
  final bool isEs;

  const _OrderCard({required this.order, required this.isEs});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMMd(isEs ? 'es_ES' : 'en_US').format(order.createdAt);
    final statusColor = _getStatusColor(order.status);

    return InkWell(
      onTap: () => context.push('/orders/${order.id}'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${order.id.toString().substring(0, 8).toUpperCase()}',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Text(
                    order.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              date,
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEs ? 'TOTAL' : 'TOTAL',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Colors.black38),
                ),
                Text(
                  '${order.totalAmount.toStringAsFixed(2)} €',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
