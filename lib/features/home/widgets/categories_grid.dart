import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:croma_app/config/theme.dart';

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({super.key});

  final List<Map<String, String>> categories = const [
    {
      'name': 'VIRAL TRENDS',
      'image':
          'https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?q=80&w=1000&auto=format&fit=crop',
      'link': 'viral-trends',
    },
    {
      'name': 'SALE / OFF',
      'image':
          'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?q=80&w=1000&auto=format&fit=crop',
      'link': 'sale',
    },
    {
      'name': 'BESTSELLERS',
      'image':
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=1000&auto=format&fit=crop',
      'link': 'bestsellers',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.black,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'CATEGORIES',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(height: 24),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return InkWell(
                onTap: () {
                  context.push('/catalog/${cat['link']}');
                },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: cat['image']!,
                        fit: BoxFit.cover,
                        color: AppTheme.black.withValues(alpha: 0.5),
                        colorBlendMode: BlendMode.darken,
                      ),
                      Center(
                        child: Text(
                          cat['name']!,
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                color: AppTheme.white,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
