import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/admin_repository.dart';

class AdminCategoryFormScreen extends ConsumerStatefulWidget {
  final String? categoryId; // Null if creating new

  const AdminCategoryFormScreen({super.key, this.categoryId});

  @override
  ConsumerState<AdminCategoryFormScreen> createState() => _AdminCategoryFormScreenState();
}

class _AdminCategoryFormScreenState extends ConsumerState<AdminCategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _slugController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  bool _isLoading = false;
  final bool _isInit = false;

  @override
  void initState() {
    super.initState();
    if (widget.categoryId != null) {
      _loadCategory();
    }
  }

  Future<void> _loadCategory() async {
    setState(() => _isLoading = true);
    try {
      final cats = await ref.read(adminCategoriesProvider.future);
      final cat = cats.firstWhere((element) => element['id'] == widget.categoryId, orElse: () => {});
      if (cat.isNotEmpty) {
        _nameController.text = cat['name'] ?? '';
        _slugController.text = cat['slug'] ?? '';
        _imageController.text = cat['image'] ?? '';
        _descriptionController.text = cat['description'] ?? '';
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al cargar: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final data = {
        'name': _nameController.text.trim(),
        'slug': _slugController.text.trim().toLowerCase(),
        'image': _imageController.text.trim(),
        'description': _descriptionController.text.trim(),
      };

      if (widget.categoryId == null) {
        await ref.read(adminRepositoryProvider).createCategory(data);
      } else {
        await ref.read(adminRepositoryProvider).updateCategory(widget.categoryId!, data);
      }

      ref.invalidate(adminCategoriesProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Guardado correctamente', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.green),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.categoryId == null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isNew ? 'NUEVO SECTOR' : 'EDITAR SECTOR',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 2.0, fontSize: 14),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('DENOMINACIÓN'),
                    _buildTextField(
                      controller: _nameController,
                      hint: 'Ej: Streetwear',
                      validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
                      onChanged: (val) {
                        if (isNew && !_isInit) {
                          _slugController.text = val.toLowerCase().replaceAll(' ', '-').replaceAll(RegExp(r'[^a-z0-9\-]'), '');
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('SLUG (IDENTIFICADOR)'),
                    _buildTextField(
                      controller: _slugController,
                      hint: 'ej: streetwear',
                      validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('URL DE IMAGEN (OPCIONAL)'),
                    _buildTextField(
                      controller: _imageController,
                      hint: 'https://...',
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('DESCRIPCIÓN (OPCIONAL)'),
                    _buildTextField(
                      controller: _descriptionController,
                      hint: '...',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: _save,
                        child: Text(
                          isNew ? 'CREAR REGISTRO' : 'GUARDAR CAMBIOS',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: Colors.grey),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.5)),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
