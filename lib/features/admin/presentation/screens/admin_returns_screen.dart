import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/admin_repository.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/admin_sort_dropdown.dart';
import '../../../../shared/widgets/croma_loading.dart';

final returnSearchQueryProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);
final returnSortProvider = StateProvider.autoDispose<AdminSortOption>(
  (ref) => AdminSortOption.newest,
);

class AdminReturnsScreen extends ConsumerWidget {
  const AdminReturnsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final returnsAsync = ref.watch(adminReturnsProvider);
    final searchQuery = ref.watch(returnSearchQueryProvider);
    final sortOption = ref.watch(returnSortProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminAppBar(title: 'GESTIÓN DE DEVOLUCIONES'),
      drawer: const AdminDrawer(),
      body: returnsAsync.when(
        data: (returns) {
          var filtered = returns.where((r) {
            final id = (r['id'] as String).toLowerCase();
            final orderId = (r['order_id'] as String).toLowerCase();
            final profile = r['profiles'] as Map<String, dynamic>?;
            final name = (profile?['full_name'] as String? ?? '').toLowerCase();
            final email = (profile?['email'] as String? ?? '').toLowerCase();
            final query = searchQuery.toLowerCase();
            return id.contains(query) ||
                orderId.contains(query) ||
                name.contains(query) ||
                email.contains(query);
          }).toList();

          filtered.sort((a, b) {
            switch (sortOption) {
              case AdminSortOption.newest:
                return (b['created_at'] as String? ?? '').compareTo(
                  a['created_at'] as String? ?? '',
                );
              case AdminSortOption.oldest:
                return (a['created_at'] as String? ?? '').compareTo(
                  b['created_at'] as String? ?? '',
                );
              case AdminSortOption.alphabetical:
                final profileA = a['profiles'] as Map<String, dynamic>?;
                final profileB = b['profiles'] as Map<String, dynamic>?;
                return (profileA?['full_name'] as String? ?? '').compareTo(
                  profileB?['full_name'] as String? ?? '',
                );
              default:
                return 0;
            }
          });

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildIndustrialActionBar(
                  context,
                  ref,
                  filtered.length,
                  returns.length,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final request = filtered[index];
                    return _ReturnRequestCard(request: request);
                  }, childCount: filtered.length),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
        loading: () => const Center(child: CromaLoading()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildIndustrialActionBar(
    BuildContext context,
    WidgetRef ref,
    int visibleCount,
    int totalCount,
  ) {
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
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 50,
                  offset: const Offset(0, 20),
                ),
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
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: Colors.white54,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            onChanged: (val) =>
                                ref
                                        .read(
                                          returnSearchQueryProvider.notifier,
                                        )
                                        .state =
                                    val,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'IDENTIFICAR SOLICITUD, PEDIDO...',
                              hintStyle: TextStyle(
                                color: Colors.white12,
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
                  value: ref.watch(returnSortProvider),
                  onChanged: (val) =>
                      ref.read(returnSortProvider.notifier).state = val,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.black.withValues(alpha: 0.03),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.05),
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3f3f46),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ref.watch(returnSearchQueryProvider).isEmpty
                          ? '$totalCount SOLICITUDES RECIBIDAS'
                          : '$visibleCount DE $totalCount RESULTADOS',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.black.withValues(alpha: 0.03),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReturnRequestCard extends ConsumerWidget {
  final Map<String, dynamic> request;

  const _ReturnRequestCard({required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = request['profiles'] as Map<String, dynamic>?;
    final status = request['status'] as String? ?? 'pending';
    final reason = request['reason'] as String? ?? 'No especificada';
    final createdAtStr = request['created_at'] as String? ?? '';
    final date = createdAtStr.isNotEmpty
        ? DateTime.tryParse(createdAtStr)
        : null;
    final formattedDate = date != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(date)
        : 'N/A';

    final statusColor = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
                'RET_ID: ${request['id'].toString().substring(0, 8).toUpperCase()}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 1.0,
                  color: Colors.grey,
                ),
              ),
              _StatusBadge(status: status, color: statusColor),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            (profile?['full_name'] ?? 'USUARIO ANÓNIMO')
                .toString()
                .toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            (profile?['email'] ?? '').toString(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _InfoRow(
            label: 'PEDIDO ORIGEN',
            value:
                '#${request['order_id'].toString().substring(0, 8).toUpperCase()}',
          ),
          _InfoRow(label: 'MOTIVO', value: reason.toUpperCase()),
          _InfoRow(label: 'FECHA', value: formattedDate),
          const SizedBox(height: 20),
          if (request['details'] != null &&
              request['details'].toString().isNotEmpty) ...[
            const Text(
              'DETALLES ADICIONALES:',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              request['details'].toString(),
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
            const SizedBox(height: 20),
          ],
          Row(
            children: [
              const Spacer(),
              PopupMenuButton<String>(
                onSelected: (newStatus) =>
                    _updateStatus(ref, context, request['id'], newStatus),
                itemBuilder: (context) => [
                  _statusItem('pending', 'MARCAR COMO PENDIENTE'),
                  _statusItem('approved', 'APROBAR SOLICITUD'),
                  _statusItem('rejected', 'RECHAZAR SOLICITUD'),
                  _statusItem('completed', 'MARCAR COMO FINALIZADA'),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'GESTIONAR ESTADO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 14,
                      ),
                    ],
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
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 10,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  void _updateStatus(
    WidgetRef ref,
    BuildContext context,
    String id,
    String status,
  ) async {
    try {
      await ref
          .read(adminRepositoryProvider)
          .updateReturnRequestStatus(id, status);
      ref.invalidate(adminReturnsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'ESTADO ACTUALIZADO A ${status.toUpperCase()}',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 10,
                letterSpacing: 1.0,
              ),
            ),
            backgroundColor: Colors.black,
            behavior: SnackBarBehavior.floating,
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
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    String label = status.toUpperCase();
    if (status == 'pending') label = 'PENDIENTE';
    if (status == 'approved') label = 'APROBADA';
    if (status == 'rejected') label = 'RECHAZADA';
    if (status == 'completed') label = 'FINALIZADA';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
