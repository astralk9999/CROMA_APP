import 'package:flutter/material.dart';

class StickyAddToCart extends StatelessWidget {
  final double price;
  final bool hasDiscount;
  final double originalPrice;
  final VoidCallback onAddToCart;
  final VoidCallback onSizeSelectorTap;
  final String? selectedSize;
  final bool isOutOfStock;
  final bool isUpcoming;

  const StickyAddToCart({
    super.key,
    required this.price,
    required this.hasDiscount,
    required this.originalPrice,
    required this.onAddToCart,
    required this.onSizeSelectorTap,
    this.selectedSize,
    required this.isOutOfStock,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Row(
        children: [
          // Select Size Button
          Expanded(
            flex: 1,
            child: OutlinedButton(
              onPressed: (isOutOfStock || isUpcoming)
                  ? null
                  : onSizeSelectorTap,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                side: BorderSide(
                  color: (isOutOfStock || isUpcoming)
                      ? Colors.grey.shade300
                      : Colors.black,
                  width: 2,
                ),
              ),
              child: Text(
                selectedSize ?? 'TALLA',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: (isOutOfStock || isUpcoming)
                      ? Colors.grey
                      : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Add to Cart / notify button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _getButtonAction(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getButtonColor(),
                padding: const EdgeInsets.symmetric(vertical: 20),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: Text(
                _getButtonText(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: (isOutOfStock && !isUpcoming)
                      ? Colors.grey.shade600
                      : Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText() {
    if (isUpcoming) return 'PRÓXIMAMENTE';
    if (isOutOfStock) return 'SOLD OUT';
    if (selectedSize == null) return 'SELECCIONA TALLA';
    return 'AÑADIR - ${price.toStringAsFixed(2)} €';
  }

  Color _getButtonColor() {
    if (isUpcoming) return Colors.black;
    if (isOutOfStock) return Colors.grey.shade300;
    return Colors.black;
  }

  VoidCallback? _getButtonAction() {
    if (isUpcoming || isOutOfStock) return null;
    if (selectedSize == null) return onSizeSelectorTap;
    return onAddToCart;
  }
}
