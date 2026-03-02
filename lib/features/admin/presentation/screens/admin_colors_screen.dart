import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/admin_repository.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/admin_sort_dropdown.dart';

final colorSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');
final colorSortProvider = StateProvider.autoDispose<AdminSortOption>((ref) => AdminSortOption.newest);

class AdminColorsScreen extends ConsumerWidget {
  const AdminColorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorsAsync = ref.watch(adminColorsProvider);
    final searchQuery = ref.watch(colorSearchQueryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminAppBar(title: 'MAESTRO DE COLORES'),
      drawer: const AdminDrawer(),
      body: colorsAsync.when(
        data: (colors) {
          var filtered = colors.where((color) {
            final name = (color['name'] as String).toLowerCase();
            final slug = (color['slug'] as String).toLowerCase();
            final hex = (color['hex_code'] as String?)?.toLowerCase() ?? '';
            final query = searchQuery.toLowerCase();
            return name.contains(query) || slug.contains(query) || hex.contains(query);
          }).toList();

          final sortOption = ref.watch(colorSortProvider);
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
                child: _buildIndustrialActionBar(context, ref, filtered.length, colors.length),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final color = filtered[index];
                      return _buildColorRow(context, ref, color);
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
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF18181b),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 50, offset: const Offset(0, 20))
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
                            onChanged: (val) => ref.read(colorSearchQueryProvider.notifier).state = val,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                            ),
                            decoration: InputDecoration(
                              hintText: 'FILTRAR POR DENOMINACIÓN O HEX...',
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
                  value: ref.watch(colorSortProvider),
                  onChanged: (val) => ref.read(colorSortProvider.notifier).state = val,
                ),
                const SizedBox(width: 12),
                Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.1)),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () => context.push('/admin/colors/new'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add, color: Colors.black, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'NUEVA VARIANTE',
                          style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
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
                      ref.watch(colorSearchQueryProvider).isEmpty
                          ? '$totalCount VARIANTES DETECTADAS'
                          : '$visibleCount DE $totalCount RESULTADOS',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 2.0),
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

  Widget _buildColorRow(BuildContext context, WidgetRef ref, Map<String, dynamic> colorData) {
    final String name = colorData['name'] ?? '';
    final String slug = colorData['slug'] ?? '';
    final String id = colorData['id'] ?? '';
    final String? hexCode = colorData['hex_code'];

    Color parsedColor = Colors.grey.shade200;
    if (hexCode != null && hexCode.isNotEmpty) {
      try {
        final hexString = hexCode.replaceAll('#', '');
        if (hexString.length == 6) {
          parsedColor = Color(int.parse('FF$hexString', radix: 16));
        }
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: parsedColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          alignment: Alignment.center,
          child: hexCode == null || hexCode.isEmpty
              ? const Text('N/A', style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w900))
              : null,
        ),
        title: Text(
          name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: -0.5),
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
                  style: const TextStyle(fontSize: 9, fontFamily: 'monospace', fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 8),
              if (hexCode != null && hexCode.isNotEmpty)
                Text(
                  hexCode.toUpperCase(),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black45, letterSpacing: 1.5),
                ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey, size: 20),
              onPressed: () => context.push('/admin/colors/$id/edit'),
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
          'ELIMINAR VARIANTE',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2.0, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        content: Text(
          '¿ESTÁS SEGURO DE QUE QUIERES ELIMINAR EL COLOR "${name.toUpperCase()}"? ESTA ACCIÓN NO SE PUEDE DESHACER.',
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
        await ref.read(adminRepositoryProvider).deleteColor(id);
        ref.invalidate(adminColorsProvider);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('COLOR ELIMINADO', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.green),
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
