import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/account_repository.dart';
import '../../../../shared/widgets/croma_loading.dart';
import '../../../../shared/widgets/cached_image.dart';

class ReturnRequestFormScreen extends ConsumerStatefulWidget {
  final String orderId;

  const ReturnRequestFormScreen({super.key, required this.orderId});

  @override
  ConsumerState<ReturnRequestFormScreen> createState() => _ReturnRequestFormScreenState();
}

class _ReturnRequestFormScreenState extends ConsumerState<ReturnRequestFormScreen> {
  final List<String> _selectedItemIds = [];
  String _selectedReason = 'Talla incorrecta';
  final _detailsController = TextEditingController();
  final List<File> _images = [];
  bool _isSubmitting = false;

  final _reasons = [
    'Talla incorrecta',
    'Producto defectuoso',
    'No es lo que esperaba',
    'Producto equivocado',
    'Otro'
  ];

  Future<void> _pickImage() async {
    if (_images.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Máximo 3 imágenes permitidas')));
      return;
    }
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      setState(() => _images.add(File(pickedFile.path)));
    }
  }

  Future<void> _submitReturn() async {
    if (_selectedItemIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona al menos un artículo')));
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      // NOTE: In a real app, images would be uploaded to Supabase Storage first and URLs passed perfectly.
      // We pass local paths for the moment.
      await ref.read(accountRepositoryProvider).createReturnRequest(
        orderId: widget.orderId,
        reason: _selectedReason,
        details: _detailsController.text.trim(),
        orderItemIds: _selectedItemIds,
        images: _images.map((e) => e.path).toList(),
      );

      // Invalidate returns cache so it updates
      ref.invalidate(userReturnsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Solicitud y artículos en proceso')));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(orderDetailsProvider(widget.orderId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'SOLICITUD DE DEVOLUCIÓN',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 1, fontSize: 13),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: orderAsync.when(
        data: (order) {
          if (order == null) return const Center(child: Text('Pedido no encontrado'));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('1. SELECCIONA LOS ARTÍCULOS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                const SizedBox(height: 16),
                ...order.items.map((item) {
                  final isSelected = _selectedItemIds.contains(item.id);
                  return CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: isSelected,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selectedItemIds.add(item.id);
                        } else {
                          _selectedItemIds.remove(item.id);
                        }
                      });
                    },
                    title: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          margin: const EdgeInsets.only(right: 12),
                          color: const Color(0xFFF9F9F9),
                          child: item.productImage.isNotEmpty
                              ? CachedImage(imageUrl: item.productImage, fit: BoxFit.cover)
                              : const Icon(Icons.image_not_supported, color: Colors.black12),
                        ),
                        Expanded(child: Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      ],
                    ),
                    subtitle: Text('Talla: ${item.size} - ${(item.price).toStringAsFixed(2)} €', style: const TextStyle(fontSize: 10)),
                  );
                }),
                const SizedBox(height: 32),
                const Text('2. MOTIVO DE LA DEVOLUCIÓN', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0)),
                  items: _reasons.map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 12)))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedReason = val);
                  },
                ),
                const SizedBox(height: 32),
                const Text('3. DETALLES ADICIONALES', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                const SizedBox(height: 16),
                TextField(
                  controller: _detailsController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Describe el problema con el/los productos...',
                    hintStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 32),
                const Text('4. FOTOGRAFÍAS (OPCIONAL, MÁX. 3)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ..._images.map((img) => Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                              child: Image.file(img, fit: BoxFit.cover),
                            ),
                            Positioned(
                              top: -10,
                              right: -10,
                              child: IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () => setState(() => _images.remove(img)),
                              ),
                            )
                          ],
                        )),
                    if (_images.length < 3)
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(border: Border.all(color: Colors.black12), color: const Color(0xFFF9F9F9)),
                          child: const Icon(Icons.add_a_photo, color: Colors.black26),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitReturn,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF202020)),
                    child: _isSubmitting
                        ? const CromaLoading(color: Colors.white, size: 24)
                        : const Text('ENVIAR SOLICITUD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2)),
                  ),
                ),
                const SizedBox(height: 64),
              ],
            ),
          );
        },
        loading: () => const Center(child: CromaLoading()),
        error: (e, __) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
