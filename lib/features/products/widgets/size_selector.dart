import 'package:flutter/material.dart';
import 'package:croma_app/config/theme.dart';

class SizeSelector extends StatefulWidget {
  final List<String> sizes;
  final String? selectedSize;
  final ValueChanged<String> onSelected;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.onSelected,
  });

  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SELECT SIZE',
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppTheme.gray600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: widget.sizes.map((size) {
            final isSelected = widget.selectedSize == size;
            return GestureDetector(
              onTap: () => widget.onSelected(size),
              child: Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.black : AppTheme.white,
                  border: Border.all(
                    color: isSelected ? AppTheme.black : AppTheme.gray300,
                  ),
                ),
                child: Text(
                  size,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppTheme.white : AppTheme.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
