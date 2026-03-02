import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/account_repository.dart';
import '../../../../shared/widgets/croma_loading.dart';
import '../../../../shared/widgets/cached_image.dart';
import '../../../../core/providers/language_provider.dart';
import '../../services/invoice_generator.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailsProvider(orderId));
    final isEs = ref.watch(languageProvider) == 'es';

    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar removido para evitar problemas directos
      body: orderAsync.when(
        data: (order) {
          if (order == null) return const Center(child: Text('Pedido no encontrado'));

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ─── STATUS & ID ───
                    _buildOrderHeader(order, isEs),
                    const SizedBox(height: 32),

                    // ─── ITEMS ───
                    Text(
                      isEs ? 'ARTÍCULOS' : 'ITEMS',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 2, color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    ...order.items.map((item) => _buildOrderItem(item)),
                    const SizedBox(height: 32),

                    // ─── SUMMARY ───
                    _buildOrderSummary(order, isEs),
                    const SizedBox(height: 32),

                    // ─── SHIPPING ───
                    _buildShippingInfo(order, isEs),
                    const SizedBox(height: 48),

                    // ─── ACTIONS ───
                    _buildActions(context, ref, order, isEs),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.8),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => context.pop(),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CromaLoading()),
        error: (e, __) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildOrderHeader(dynamic order, bool isEs) {
    final date = DateFormat.yMMMMd(isEs ? 'es_ES' : 'en_US').format(order.createdAt);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ORDEN #${order.id.toString().substring(0, 8).toUpperCase()}',
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: -0.5),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: Colors.black,
              child: Text(
                order.status.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Comprado el $date',
          style: const TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildOrderItem(dynamic item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 90,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
            ),
            child: CachedImage(
              imageUrl: item.productImage,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Talla: ${item.size} • Cantidad: ${item.quantity}',
                  style: const TextStyle(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${(item.price * item.quantity).toStringAsFixed(2)} €',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(dynamic order, bool isEs) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          _summaryRow(isEs ? 'Subtotal' : 'Subtotal', '${order.totalAmount.toStringAsFixed(2)} €'),
          const SizedBox(height: 8),
          _summaryRow(isEs ? 'Envío' : 'Shipping', '0.00 €'),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _summaryRow(isEs ? 'TOTAL' : 'TOTAL', '${order.totalAmount.toStringAsFixed(2)} €', isBold: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w500,
            fontSize: isBold ? 14 : 13,
            color: isBold ? Colors.black : Colors.black54,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            fontSize: isBold ? 18 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildShippingInfo(dynamic order, bool isEs) {
    final addr = order.shippingAddress;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEs ? 'DIRECCIÓN DE ENVÍO' : 'SHIPPING ADDRESS',
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 2, color: Colors.black54),
        ),
        const SizedBox(height: 16),
        Text(addr.address, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        Text('${addr.postalCode} ${addr.city}', style: const TextStyle(fontSize: 14, color: Colors.black87)),
        Text(addr.country, style: const TextStyle(fontSize: 14, color: Colors.black54)),
      ],
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref, dynamic order, bool isEs) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            try {
              await InvoiceGenerator.generateAndShareInvoice(order);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error generating invoice: $e')));
              }
            }
          },
          icon: const Icon(Icons.receipt_long_outlined, color: Colors.white),
          label: Text(isEs ? 'DESCARGAR RECIBO' : 'DOWNLOAD RECEIPT'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF202020),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            textStyle: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 12),
          ),
        ),
        const SizedBox(height: 16),
        if (order.status == 'pending')
          OutlinedButton.icon(
            onPressed: () async {
              try {
                await ref.read(accountRepositoryProvider).updateOrderStatus(order.id, 'cancelled');
                ref.invalidate(orderDetailsProvider(order.id));
                ref.invalidate(userOrdersProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEs ? 'Pedido cancelado ✅' : 'Order cancelled ✅'))
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'))
                  );
                }
              }
            },
            icon: const Icon(Icons.cancel_outlined),
            label: Text(isEs ? 'CANCELAR PEDIDO' : 'CANCEL ORDER'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red, width: 2),
              minimumSize: const Size(double.infinity, 56),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              textStyle: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 12),
            ),
          ),
        const SizedBox(height: 16),
        if (order.status == 'delivered') ...[
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.push('/orders/${order.id}/return');
            },
            icon: const Icon(Icons.assignment_return_outlined),
            label: Text(isEs ? 'SOLICITAR DEVOLUCIÓN' : 'REQUEST RETURN'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              side: const BorderSide(color: Colors.black, width: 2),
              minimumSize: const Size(double.infinity, 56),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              textStyle: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }
}
