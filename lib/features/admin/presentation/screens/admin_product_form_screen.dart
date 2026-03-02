import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/admin_repository.dart';

class AdminProductFormScreen extends ConsumerStatefulWidget {
  final String? productId;

  const AdminProductFormScreen({super.key, this.productId});

  @override
  ConsumerState<AdminProductFormScreen> createState() => _AdminProductFormScreenState();
}

class _AdminProductFormScreenState extends ConsumerState<AdminProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  
  String? _selectedCategoryId;
  String? _selectedBrandId;
  bool _isHidden = false;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final items = await ref.read(adminProductsProvider.future);
      final item = items.firstWhere((element) => element['id'] == widget.productId, orElse: () => {});
      if (item.isNotEmpty) {
        _nameController.text = item['name'] ?? '';
        _descriptionController.text = item['description'] ?? '';
        _priceController.text = (item['price'] ?? '').toString();
        _selectedCategoryId = item['category_id'];
        _selectedBrandId = item['brand_id'];
        _isHidden = item['is_hidden'] ?? false;
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
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final Map<String, dynamic> data = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
        'is_hidden': _isHidden,
      };

      if (_selectedCategoryId != null) data['category_id'] = _selectedCategoryId;
      if (_selectedBrandId != null) data['brand_id'] = _selectedBrandId;

      if (widget.productId == null) {
        await ref.read(adminRepositoryProvider).createProduct(data);
      } else {
        await ref.read(adminRepositoryProvider).updateProduct(widget.productId!, data);
      }

      ref.invalidate(adminProductsProvider);
      
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
    final isNew = widget.productId == null;
    final categoriesAsync = ref.watch(adminCategoriesProvider);
    final brandsAsync = ref.watch(adminBrandsProvider);

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
          isNew ? 'NUEVA EDICIÓN' : 'MODIFICAR EDICIÓN',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLabel('OCULTO DEL PÚBLICO'),
                        Switch(
                          value: _isHidden,
                          onChanged: (val) => setState(() => _isHidden = val),
                          activeThumbColor: Colors.black,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('DENOMINACIÓN DEL PRODUCTO'),
                    _buildTextField(
                      controller: _nameController,
                      hint: 'Ej: Camiseta Básica Black',
                      validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('PRECIO DE VENTA (€)'),
                    _buildTextField(
                      controller: _priceController,
                      hint: 'Ej: 29.99',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Requerido';
                        if (double.tryParse(val) == null) return 'Valor numérico inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('SECTOR / CATEGORÍA'),
                              categoriesAsync.when(
                                data: (categories) => _buildDropdown(
                                  value: _selectedCategoryId,
                                  items: categories.map((c) => DropdownMenuItem(
                                    value: c['id'].toString(),
                                    child: Text(c['name'] ?? 'Sin nombre', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  )).toList(),
                                  onChanged: (val) => setState(() => _selectedCategoryId = val),
                                ),
                                loading: () => const LinearProgressIndicator(color: Colors.black),
                                error: (e, _) => Text('Error: $e'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('FIRMA / MARCA'),
                              brandsAsync.when(
                                data: (brands) => _buildDropdown(
                                  value: _selectedBrandId,
                                  items: brands.map((b) => DropdownMenuItem(
                                    value: b['id'].toString(),
                                    child: Text(b['name'] ?? 'Sin nombre', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  )).toList(),
                                  onChanged: (val) => setState(() => _selectedBrandId = val),
                                ),
                                loading: () => const LinearProgressIndicator(color: Colors.black),
                                error: (e, _) => Text('Error: $e'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    _buildLabel('DESCRIPCIÓN COMERCIAL'),
                    _buildTextField(
                      controller: _descriptionController,
                      hint: 'Características principales...',
                      maxLines: 4,
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

  Widget _buildDropdown({
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: const Text('Seleccionar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          items: items,
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      keyboardType: keyboardType,
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
      ),
    );
  }
}
