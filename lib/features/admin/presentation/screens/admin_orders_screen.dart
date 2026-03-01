import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/admin_repository.dart';
import '../../../../shared/widgets/croma_app_bar.dart';
import '../../../../shared/widgets/croma_loading.dart';
import '../widgets/admin_drawer.dart';

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(allAdminOrdersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: CromaAppBar(
        title: const Text(
          'LOGÍSTICA_ORDENES',
          style: TextStyle(
            color: Color(0xFF202020),
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ),
      drawer: const AdminDrawer(),
      body: ordersAsync.when(
        data: (orders) => ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return _OrderAdminCard(order: order);
          },
        ),
        loading: () => const Center(child: CromaLoading()),
        error: (e, __) => Center(child: Text('Error: $e')),
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
                style: const TextStyle(fontWeight: FontWeight.black, fontSize: 13, letterSpacing: -0.5),
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
                style: const TextStyle(fontWeight: FontWeight.black, fontSize: 15, tabularNums: true),
              ),
              PopupMenuButton<String>(
                onSelected: (newStatus) => _updateStatus(ref, order['id'], newStatus),
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
                    style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.black, letterSpacing: 1),
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

  void _updateStatus(WidgetRef ref, String id, String status) async {
    await ref.read(adminRepositoryProvider).updateOrderStatus(id, status);
    ref.invalidate(allAdminOrdersProvider);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered': return Colors.emerald;
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
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.black, letterSpacing: 1),
      ),
    );
  }
}
