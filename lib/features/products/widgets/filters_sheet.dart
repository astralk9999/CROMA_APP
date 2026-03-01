import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:croma_app/config/theme.dart';
import 'package:croma_app/features/products/providers/filter_provider.dart';

class FiltersSheet extends ConsumerWidget {
  const FiltersSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(productFiltersProvider);
    final filterNotifier = ref.read(productFiltersProvider.notifier);

    final brands = [
      'SMOG',
      'FSBN',
      'BLACK SQUAD',
      'ICONO',
      'IQ',
      'LUCKY ATHLETES',
    ];
    final colors = [
      {'name': 'Beige', 'color': const Color(0xFFF5F5DC)},
      {'name': 'Blue', 'color': Colors.blue},
      {'name': 'Brown', 'color': Colors.brown},
      {'name': 'Green', 'color': Colors.green},
      {'name': 'Red', 'color': Colors.red},
      {'name': 'White', 'color': Colors.white},
      {'name': 'Black', 'color': Colors.black},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FILTERS',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              TextButton(
                onPressed: () => filterNotifier.clearAll(),
                child: const Text(
                  'CLEAR ALL',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Brands
          const Text(
            'BRANDS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.gray400,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: brands.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final brand = brands[index];
                final isSelected = filters.brand == brand;
                return ChoiceChip(
                  label: Text(brand),
                  selected: isSelected,
                  onSelected: (selected) {
                    filterNotifier.setBrand(selected ? brand : null);
                  },
                  selectedColor: AppTheme.black,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),

          // Colors
          const Text(
            'COLORS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.gray400,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: colors.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final colorItem = colors[index];
                final colorName = colorItem['name'] as String;
                final colorValue = colorItem['color'] as Color;
                final isSelected = filters.color == colorName;

                return GestureDetector(
                  onTap: () =>
                      filterNotifier.setColor(isSelected ? null : colorName),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorValue,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppTheme.black : AppTheme.gray200,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: colorValue == Colors.white
                                ? Colors.black
                                : Colors.white,
                            size: 20,
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),

          // Price Range
          const Text(
            'MAX PRICE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.gray400,
            ),
          ),
          Slider(
            value: filters.maxPrice ?? 200,
            min: 0,
            max: 200,
            divisions: 20,
            activeColor: AppTheme.black,
            inactiveColor: AppTheme.gray200,
            label: '${filters.maxPrice?.round() ?? 200}€',
            onChanged: (value) {
              filterNotifier.setMaxPrice(value);
            },
          ),
          const SizedBox(height: 32),

          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: AppTheme.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('SHOW RESULTS'),
          ),
        ],
      ),
    );
  }
}
