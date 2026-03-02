import 'package:flutter/material.dart';

class SizeSelectorSheet extends StatelessWidget {
  final String? selectedSize;
  final List<String> availableSizes;
  final Map<String, dynamic>? stockBySizes;
  final ValueChanged<String> onSizeSelected;

  const SizeSelectorSheet({
    super.key,
    required this.selectedSize,
    required this.availableSizes,
    required this.stockBySizes,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SELECCIONA UNA TALLA',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(fontSize: 20),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: availableSizes.map((size) {
              final stock = (stockBySizes?[size] as int?) ?? 0;
              final isOutOfStock = stock <= 0;
              final isSelected = selectedSize == size;

              return InkWell(
                onTap: isOutOfStock
                    ? null
                    : () {
                        onSizeSelected(size);
                        Navigator.pop(context);
                      },
                child: Container(
                  width:
                      (MediaQuery.of(context).size.width - 48 - 36) /
                      4, // 4 items per row
                  height: 65,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF202020) : Colors.white,
                    border: Border.all(
                      color: isOutOfStock
                          ? Colors.grey.shade300
                          : isSelected
                          ? const Color(0xFF202020)
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          size,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: isOutOfStock
                                ? Colors.grey.shade400
                                : isSelected
                                ? Colors.white
                                : const Color(0xFF202020),
                          ),
                        ),
                      ),
                      if (isOutOfStock)
                        Positioned(
                          child: Transform.rotate(
                            angle: -0.5,
                            child: Container(
                              height: 2,
                              width: 40,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 4,
                        child: Text(
                          isOutOfStock ? 'SIN STOCK' : '$stock DISP.',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w900,
                                color: isOutOfStock
                                    ? Colors.grey.shade400
                                    : isSelected
                                        ? Colors.white
                                        : (stock <= 3 ? Colors.red : Colors.black87),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
