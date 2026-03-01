import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/admin_repository.dart';
import '../../../../shared/widgets/croma_app_bar.dart';
import '../../../../shared/widgets/croma_loading.dart';
import '../widgets/admin_drawer.dart';

class AdminProductsScreen extends ConsumerWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(adminProductsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: CromaAppBar(
        title: const Text(
          'INVENTARIO_SISTEMA',
          style: TextStyle(
            color: Color(0xFF202020),
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ),
      drawer: const AdminDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create product
        },
        backgroundColor: const Color(0xFF202020),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: productsAsync.when(
        data: (products) => ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return _ProductAdminCard(product: product);
          },
        ),
        loading: () => const Center(child: CromaLoading()),
        error: (e, __) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _ProductAdminCard extends ConsumerWidget {
  final Map<String, dynamic> product;

  const _ProductAdminCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHidden = product['is_hidden'] == true;
    final images = product['images'] as List<dynamic>?;
    final imageUrl = images != null && images.isNotEmpty ? images[0] as String : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Preview
            Container(
              width: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                image: imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                        colorFilter: isHidden
                            ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                            : null,
                      )
                    : null,
              ),
              child: imageUrl == null
                  ? const Icon(Icons.image_not_supported_outlined, color: Colors.black12)
                  : null,
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product['name']?.toString().toUpperCase() ?? 'SIN NOMBRE',
                            style: TextStyle(
                              fontWeight: FontWeight.black,
                              fontSize: 13,
                              letterSpacing: -0.5,
                              color: isHidden ? Colors.black26 : Colors.black,
                            ),
                          ),
                        ),
                        if (isHidden)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: const Text('OCULTO', style: TextStyle(fontSize: 8, fontWeight: FontWeight.black)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product['categories']?['name']?.toString().toUpperCase() ?? 'SIN CATEGORIA',
                      style: const TextStyle(color: Colors.black26, fontSize: 9, fontWeight: FontWeight.black, letterSpacing: 1),
                    ),
                    const Spacer(),
                    Text(
                      '${(product['price'] as num).toStringAsFixed(2)} €',
                      style: const TextStyle(fontWeight: FontWeight.black, fontSize: 14, tabularNums: true),
                    ),
                  ],
                ),
              ),
            ),

            // Actions
            Container(
              width: 48,
              border: const Border(left: BorderSide(color: Color(0xFFF5F5F5))),
              child: Column(
                children: [
                  Expanded(
                    child: IconButton(
                      icon: Icon(
                        isHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 18,
                        color: isHidden ? Colors.orange : Colors.black26,
                      ),
                      onPressed: () => _toggleVisibility(ref, product['id'], !isHidden),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.black26),
                      onPressed: () {}, // TODO: Navigate to edit
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                      onPressed: () => _confirmDelete(context, ref, product['id'], product['name']),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleVisibility(WidgetRef ref, String id, bool hide) async {
    await ref.read(adminRepositoryProvider).toggleProductVisibility(id, hide);
    ref.invalidate(adminProductsProvider);
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ELIMINAR PRODUCTO', style: TextStyle(fontWeight: FontWeight.black, fontSize: 16)),
        content: Text('¿Desea eliminar permanentemente "$name" de la base de datos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR', style: TextStyle(color: Colors.black38, fontWeight: FontWeight.black)),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(adminRepositoryProvider).deleteProduct(id);
              ref.invalidate(adminProductsProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('ELIMINAR', style: TextStyle(color: Colors.red, fontWeight: FontWeight.black)),
          ),
        ],
      ),
    );
  }
}
