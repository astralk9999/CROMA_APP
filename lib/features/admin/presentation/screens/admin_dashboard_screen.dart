import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/admin_repository.dart';
import '../../../../shared/widgets/croma_app_bar.dart';
import '../../../../shared/widgets/croma_loading.dart';
import '../widgets/admin_drawer.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(adminMetricsProvider);
    final recentOrdersAsync = ref.watch(recentOrdersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: CromaAppBar(
        title: const Text(
          'ADMIN PANEL',
          style: TextStyle(
            color: Color(0xFF202020),
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AdminTechnicalHeader(),
            const SizedBox(height: 48),
            
            // ─── METRICS GRID ───
            metricsAsync.when(
              data: (metrics) => GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.3,
                children: [
                   _MetricCard(
                    label: 'CAPITAL TOTAL', 
                    value: '${(metrics['revenue'] as num).toStringAsFixed(0)} €', 
                    icon: Icons.payments_outlined, 
                    isDark: true,
                    subtitle: 'LIQUIDACIÓN TIEMPO REAL',
                  ),
                  _MetricCard(
                    label: 'ALCANCE MKT', 
                    value: metrics['marketingReach'].toString(), 
                    icon: Icons.campaign_outlined,
                    subtitle: '${metrics['users']} PERFILES',
                  ),
                  _MetricCard(
                    label: 'OPERACIONES', 
                    value: metrics['orders'].toString(), 
                    icon: Icons.shopping_bag_outlined,
                    subtitle: '${metrics['pendingOrders']} PENDIENTES',
                  ),
                  _MetricCard(
                    label: 'ALERT_STOCK', 
                    value: metrics['lowStockCount'].toString(), 
                    icon: Icons.warning_amber_rounded,
                    isAlert: (metrics['lowStockCount'] as int) > 0,
                    subtitle: 'MONITORIZACIÓN CRÍTICA',
                  ),
                ],
              ),
              loading: () => const Center(child: CromaLoading()),
              error: (e, __) => Center(child: Text('Error: $e')),
            ),

            const SizedBox(height: 56),

            // ─── RECENT ORDERS ───
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'LOGÍSTICA_SISTEMA',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1, color: Colors.black),
                ),
                TextButton(
                  onPressed: () => context.push('/admin/products'),
                  child: const Text('BASE_COMPLETA >', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: Colors.black45)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            recentOrdersAsync.when(
              data: (orders) => Column(
                children: orders.map((o) => _RecentOrderTile(order: o)).toList(),
              ),
              loading: () => const SizedBox(height: 100, child: Center(child: CromaLoading())),
              error: (e, __) => Text('Error: $e'),
            ),
            
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}

class _AdminTechnicalHeader extends StatelessWidget {
  const _AdminTechnicalHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.emerald.withValues(alpha: 0.1),
                border: Border.all(color: Colors.emerald.withValues(alpha: 0.2)),
              ),
              child: const Text(
                'SISTEMA_LISTO',
                style: TextStyle(color: Colors.emerald, fontSize: 8, fontWeight: FontWeight.black, letterSpacing: 1),
              ),
            ),
            const SizedBox(width: 8),
            Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.black12, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            const Text(
              'v2.0.48_ADMIN',
              style: TextStyle(color: Colors.black26, fontSize: 8, fontWeight: FontWeight.black, letterSpacing: 1),
            ),
          ],
        ),
        const SizedBox(height: 16),
        RichText(
          text: const TextSpan(
            style: TextStyle(color: Colors.black, fontSize: 40, fontWeight: FontWeight.black, height: 0.9, letterSpacing: -1),
            children: [
              TextSpan(text: 'SISTEMA\n'),
              TextSpan(text: 'PANEL_CENTRAL', style: TextStyle(color: Colors.black12)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.bolt, size: 14, color: Colors.black26),
            const SizedBox(width: 8),
            const Text(
              'PANEL DE CONTROL CENTRAL DE OPERACIONES',
              style: TextStyle(color: Colors.black26, fontSize: 9, fontWeight: FontWeight.black, letterSpacing: 1),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final String subtitle;
  final bool isDark;
  final bool isAlert;

  const _MetricCard({
    required this.label, 
    required this.value, 
    required this.icon, 
    required this.subtitle,
    this.isDark = false,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white54 : Colors.black26;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: isDark ? Colors.transparent : Colors.black12),
        boxShadow: [
          if (isDark)
            BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))
          else
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(color: subColor, fontSize: 9, fontWeight: FontWeight.black, letterSpacing: 1.5),
              ),
              Icon(icon, color: isAlert ? Colors.orange : subColor, size: 16),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(color: textColor, fontSize: 28, fontWeight: FontWeight.black, letterSpacing: -1, height: 1),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(color: isAlert ? Colors.orange : subColor, fontSize: 8, fontWeight: FontWeight.black, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}

class _RecentOrderTile extends StatelessWidget {
  final Map<String, dynamic> order;

  const _RecentOrderTile({required this.order});

  @override
  Widget build(BuildContext context) {
    final profile = order['profiles'] as Map<String, dynamic>?;
    final statusColor = _getStatusColor(order['status'].toString());
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
            ),
            child: Center(
              child: Text(
                '#${order['id'].toString().substring(0, 3).toUpperCase()}',
                style: const TextStyle(fontWeight: FontWeight.black, fontSize: 10, color: Colors.black26),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SEC_ID: ${order['id'].toString().substring(0, 12).toUpperCase()}',
                  style: const TextStyle(fontWeight: FontWeight.black, fontSize: 13, letterSpacing: -0.5),
                ),
                Text(
                  (profile?['full_name'] ?? 'USUARIO ANÓN').toString().toUpperCase(),
                  style: const TextStyle(color: Colors.black26, fontSize: 9, fontWeight: FontWeight.black, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  border: Border.all(color: statusColor.withValues(alpha: 0.2)),
                ),
                child: Text(
                  order['status'].toString().toUpperCase(),
                  style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.black, letterSpacing: 1),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${(order['total_amount'] as num).toStringAsFixed(2)} €',
                style: const TextStyle(fontWeight: FontWeight.black, fontSize: 14, tabularNums: true),
              ),
            ],
          ),
          const SizedBox(width: 12),
          const Icon(Icons.chevron_right, color: Colors.black12, size: 20),
        ],
      ),
    );
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


