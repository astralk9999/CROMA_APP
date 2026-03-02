import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/admin_repository.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/admin_sort_dropdown.dart';

// State provider for the local search query
final categorySearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');
final categorySortProvider = StateProvider.autoDispose<AdminSortOption>((ref) => AdminSortOption.newest);

class AdminCategoriesScreen extends ConsumerWidget {
  const AdminCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(adminCategoriesProvider);
    final searchQuery = ref.watch(categorySearchQueryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminAppBar(title: 'ARCHIVADOR DE GÉNEROS'),
      drawer: const AdminDrawer(),
      body: categoriesAsync.when(
        data: (categories) {
          final sortOption = ref.watch(categorySortProvider);
          // Filter categories
          var filtered = categories.where((cat) {
            final name = (cat['name'] as String).toLowerCase();
            final slug = (cat['slug'] as String).toLowerCase();
            final query = searchQuery.toLowerCase();
            return name.contains(query) || slug.contains(query);
          }).toList();

          filtered.sort((a, b) {
            switch (sortOption) {
              case AdminSortOption.newest:
                return (b['created_at'] as String? ?? '').compareTo(a['created_at'] as String? ?? '');
              case AdminSortOption.oldest:
                return (a['created_at'] as String? ?? '').compareTo(b['created_at'] as String? ?? '');
              case AdminSortOption.alphabetical:
                return (a['name'] as String).compareTo(b['name'] as String);
              default:
                return 0;
            }
          });

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildIndustrialActionBar(context, ref, filtered.length, categories.length),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final cat = filtered[index];
                      return _buildCategoryRow(context, ref, cat);
                    },
                    childCount: filtered.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildIndustrialActionBar(BuildContext context, WidgetRef ref, int visibleCount, int totalCount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0, top: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Action Bar Background
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF18181b), // zinc-800 equivalent
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 50,
                  offset: const Offset(0, 20),
                )
              ],
            ),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Search Input
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.white54, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            onChanged: (val) => ref.read(categorySearchQueryProvider.notifier).state = val,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                            ),
                            decoration: InputDecoration(
                              hintText: 'IDENTIFICAR CATEGORÍA O SECTOR...',
                              hintStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.1),
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
                  value: ref.watch(categorySortProvider),
                  onChanged: (val) => ref.read(categorySortProvider.notifier).state = val,
                ),
                const SizedBox(width: 12),
                // Native vertical divider replacement
                Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.1)),
                const SizedBox(width: 12),
                // Add button
                InkWell(
                  onTap: () => context.push('/admin/categories/new'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add, color: Colors.black, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'NUEVA FAMILIA',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Info Bar: Executive Insight
          Row(
            children: [
              Expanded(child: Container(height: 1, color: Colors.black.withValues(alpha: 0.03))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(color: Color(0xFF3f3f46), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ref.watch(categorySearchQueryProvider).isEmpty
                          ? '$totalCount SECTORES DETECTADOS'
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
              Expanded(child: Container(height: 1, color: Colors.black.withValues(alpha: 0.03))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(BuildContext context, WidgetRef ref, Map<String, dynamic> cat) {
    final String name = cat['name'] ?? '';
    final String slug = cat['slug'] ?? '';
    final String id = cat['id'] ?? '';
    final String imageUrl = cat['image'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF18181b),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
            image: imageUrl.isNotEmpty
                ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
                : null,
          ),
          alignment: Alignment.center,
          child: imageUrl.isEmpty
              ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                )
              : null,
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFf4f4f5),
                  border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  slug,
                  style: const TextStyle(
                    fontSize: 9,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey, size: 20),
              onPressed: () {
                context.push('/admin/categories/$id/edit');
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
              onPressed: () => _confirmDelete(context, ref, id, name),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, String id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF18181b),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'ELIMINAR SECTOR',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2.0, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        content: Text(
          '¿ESTÁS SEGURO DE QUE QUIERES ELIMINAR EL SECTOR "${name.toUpperCase()}"? ESTA OPERACIÓN PUEDE AFECTAR A PRODUCTOS VINCULADOS.',
          style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('CANCELAR', style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('CONFIRMAR', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(adminRepositoryProvider).deleteCategory(id);
        ref.invalidate(adminCategoriesProvider);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('SECTOR ELIMINADO', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ERROR: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }
}
