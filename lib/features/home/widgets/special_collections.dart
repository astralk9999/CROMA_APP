import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:croma_app/config/theme.dart';

class SpecialCollections extends StatelessWidget {
  const SpecialCollections({super.key});

  @override
  Widget build(BuildContext context) {
    final specials = [
      {
        'name': 'VIRAL TRENDS',
        'slug': 'viral-trends',
        'icon': Icons.trending_up,
        'color': Colors.red,
      },
      {
        'name': 'SALE / OUTLET',
        'slug': 'sale',
        'icon': Icons.local_offer,
        'color': Colors.black,
      },
      {
        'name': 'BESTSELLERS',
        'slug': 'bestsellers',
        'icon': Icons.star,
        'color': Colors.amber,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SPECIALS',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 16),
          ...specials.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => context.push('/catalog/${item['slug']}'),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    border: Border.all(color: AppTheme.gray200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: item['color'] as Color,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        item['name'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right, color: AppTheme.gray400),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
