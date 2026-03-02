import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/admin_repository.dart';

class AdminCouponFormScreen extends ConsumerStatefulWidget {
  final String? couponId;

  const AdminCouponFormScreen({super.key, this.couponId});

  @override
  ConsumerState<AdminCouponFormScreen> createState() => _AdminCouponFormScreenState();
}

class _AdminCouponFormScreenState extends ConsumerState<AdminCouponFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _discountController = TextEditingController();
  DateTime? _validUntil;
  bool _isActive = true;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.couponId != null) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final items = await ref.read(adminCouponsProvider.future);
      final item = items.firstWhere((element) => element['id'] == widget.couponId, orElse: () => {});
      if (item.isNotEmpty) {
        _codeController.text = item['code'] ?? '';
        _discountController.text = (item['discount_percent'] ?? '').toString();
        _isActive = item['is_active'] ?? true;
        if (item['valid_until'] != null) {
          _validUntil = DateTime.tryParse(item['valid_until'].toString());
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al cargar: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _validUntil ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _validUntil = picked;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final data = {
        'code': _codeController.text.trim().toUpperCase(),
        'discount_percent': int.tryParse(_discountController.text.trim()) ?? 0,
        'is_active': _isActive,
        'valid_until': _validUntil?.toIso8601String(),
      };

      if (widget.couponId == null) {
        await ref.read(adminRepositoryProvider).createCoupon(data);
      } else {
        await ref.read(adminRepositoryProvider).updateCoupon(widget.couponId!, data);
      }

      ref.invalidate(adminCouponsProvider);
      
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
    final isNew = widget.couponId == null;

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
          isNew ? 'NUEVO CUPÓN' : 'EDITAR CUPÓN',
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
                        _buildLabel('ESTADO DEL CUPÓN'),
                        Switch(
                          value: _isActive,
                          onChanged: (val) => setState(() => _isActive = val),
                          activeThumbColor: Colors.black,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('CÓDIGO PROMOCIONAL'),
                    _buildTextField(
                      controller: _codeController,
                      hint: 'Ej: VERANO2025',
                      validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('DESCUENTO (%)'),
                    _buildTextField(
                      controller: _discountController,
                      hint: 'Ej: 15',
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Requerido';
                        final num = int.tryParse(val);
                        if (num == null || num <= 0 || num > 100) return 'Valor entre 1 y 100';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('VÁLIDO HASTA (OPCIONAL)'),
                    InkWell(
                      onTap: _selectDate,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFA),
                          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 20, color: Colors.black.withValues(alpha: 0.5)),
                            const SizedBox(width: 12),
                            Text(
                              _validUntil == null
                                  ? 'Sin fecha de expiración'
                                  : DateFormat('dd/MM/yyyy').format(_validUntil!),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _validUntil == null ? Colors.grey.withValues(alpha: 0.5) : Colors.black,
                              ),
                            ),
                            const Spacer(),
                            if (_validUntil != null)
                              IconButton(
                                icon: const Icon(Icons.close, size: 16),
                                onPressed: () => setState(() => _validUntil = null),
                              )
                          ],
                        ),
                      ),
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
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      textCapitalization: textCapitalization,
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
