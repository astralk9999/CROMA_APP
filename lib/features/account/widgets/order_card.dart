import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:croma_app/config/theme.dart';
import 'package:croma_app/shared/models/order.dart';
import 'package:croma_app/core/utils/formatters.dart';
import 'package:croma_app/core/services/supabase_service.dart';

class OrderCard extends StatefulWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isCancelling = false;

  double _getProgress(String status) {
    switch (status) {
      case 'shipped':
        return 0.75;
      case 'processing':
        return 0.5;
      case 'delivered':
        return 1.0;
      default:
        return 0.25;
    }
  }

  Future<void> _launchInvoice() async {
    final url = Uri.parse(
      'https://clltyqjuqpvgvtglgrrn.supabase.co/invoices/${widget.order.id}',
    ); // Adjust base URL if needed
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch invoice')),
        );
      }
    }
  }

  Future<void> _handleCancel() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Cancelar pedido?'),
        content: const Text(
          '¿Estás seguro de que deseas cancelar este pedido? Esta acción es irreversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('NO'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'SÍ, CANCELAR',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isCancelling = true);
      final success = await SupabaseService().cancelOrder(widget.order.id);
      if (mounted) {
        setState(() => _isCancelling = false);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pedido cancelado correctamente')),
          );
          // In a real app, we'd trigger a provider refresh here
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al cancelar el pedido')),
          );
        }
      }
    }
  }

  void _showReturnInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_return,
                color: Colors.blue,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Devolución Pedido', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sigue estos pasos para proceder con la devolución:',
              style: TextStyle(fontSize: 14, color: AppTheme.gray600),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.gray100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.gray200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dirección de Envío:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text('Calle de la Moda 123', style: TextStyle(fontSize: 13)),
                  Text('Polígono Industrial', style: TextStyle(fontSize: 13)),
                  Text('28000, Madrid, España', style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const BulletPoint(
              text: 'Envía los artículos en su embalaje original.',
            ),
            const BulletPoint(
              text: 'Incluye el albarán de entrega dentro del paquete.',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Una vez recibido y validado el paquete, el reembolso se procesará en un plazo de 5 a 7 días hábiles.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'ENTENDIDO',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _getProgress(widget.order.status);
    final date = widget.order.createdAt.toString().split(' ')[0];
    final canCancel = [
      'pending',
      'processing',
      'paid',
    ].contains(widget.order.status);
    final canReturn = widget.order.status == 'delivered';

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppTheme.gray100,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: AppTheme.gray200)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoColumn('FECHA', date),
                    _buildInfoColumn(
                      'TOTAL',
                      Formatters.formatPrice(widget.order.totalAmount),
                      alignEnd: true,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoColumn(
                      'PEDIDO #',
                      widget.order.id.substring(0, 8).toUpperCase(),
                    ),
                    InkWell(
                      onTap: _launchInvoice,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.gray300),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.description_outlined,
                              size: 14,
                              color: AppTheme.gray600,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'RECIBO',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.gray600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Bar
                if (widget.order.status != 'cancelled') ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppTheme.gray200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.black,
                      ),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatusLabel(label: 'Pago', active: true),
                      StatusLabel(label: 'Proc.'),
                      StatusLabel(label: 'Envío'),
                      StatusLabel(label: 'Entregado'),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],

                // Items
                ...widget.order.items.map((item) => OrderItemRow(item: item)),

                // Actions
                if (canCancel ||
                    canReturn ||
                    widget.order.status == 'cancelled') ...[
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.order.status == 'cancelled')
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Colors.red.withValues(alpha: 0.2),
                            ),
                          ),
                          child: const Text(
                            'CANCELADO',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      if (canCancel)
                        OutlinedButton(
                          onPressed: _isCancelling ? null : _handleCancel,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: Text(
                            _isCancelling ? 'CANCELANDO...' : 'CANCELAR PEDIDO',
                          ),
                        ),
                      if (canReturn)
                        OutlinedButton(
                          onPressed: _showReturnInfo,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.gray600,
                            side: const BorderSide(color: AppTheme.gray300),
                          ),
                          child: const Text('SOLICITAR DEVOLUCIÓN'),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, {bool alignEnd = false}) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppTheme.gray600,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}

class StatusLabel extends StatelessWidget {
  final String label;
  final bool active;
  const StatusLabel({super.key, required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 10,
        color: active ? AppTheme.black : AppTheme.gray400,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class OrderItemRow extends StatelessWidget {
  final OrderItem item;
  const OrderItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.gray100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.gray200),
            ),
            child: item.product?.images.isNotEmpty == true
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: CachedNetworkImage(
                      imageUrl: item.product!.images[0],
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.image_not_supported),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product?.name ?? 'Unknown Product',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Talla: ${item.size} | Cant: ${item.quantity}',
                  style: const TextStyle(color: AppTheme.gray600, fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            Formatters.formatPrice(item.price),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: AppTheme.gray600),
            ),
          ),
        ],
      ),
    );
  }
}
