import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/croma_loading.dart';
import 'package:fashion_store/features/cart/providers/cart_provider.dart';
import 'package:fashion_store/features/address/providers/address_provider.dart';
import '../../../../core/services/auth_provider.dart';
import '../services/checkout_service.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController(text: 'ES'); // Default Spain
  final _discountController = TextEditingController();

  bool _isProcessing = false;
  bool _isDiscountApplied = false;
  bool _isAddressStepExpanded = true;
  String? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    // Pre-fill if logged in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authNotifierProvider);
      if (user != null) {
        _emailController.text = user.email ?? '';
        _nameController.text = user.userMetadata?['full_name'] ?? '';
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    try {
      final cartItems = ref.read(cartNotifierProvider).value ?? [];
      if (cartItems.isEmpty) throw Exception('Carrito vacío');

      // Transformar items para el API: { productId, size, quantity }
      final apiItems = cartItems
          .map(
            (item) => {
              'id': item.productId,
              'name': item.name,
              'price': item.price,
              'image': item.image,
              'size': item.size,
              'quantity': item.quantity,
            },
          )
          .toList();

      final shippingAddress = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'postal_code': _postalCodeController.text.trim(),
        'country': _countryController.text.trim(),
      };

      final success = await CheckoutService.processPayment(
        items: apiItems,
        shippingAddress: shippingAddress,
        selectedAddressId: _selectedAddressId,
      );

      if (success && mounted) {
        if (!kIsWeb) {
          // Limpiar carrito (En web se limpia al volver en el success_screen)
          await ref.read(cartNotifierProvider.notifier).clearCart();
          if (mounted) {
            context.go('/success');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al procesar el pago: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartTotal = ref.read(cartNotifierProvider.notifier).cartTotal;
    const shippingCost = 0.0; // Todo: Calcular basado en dirección
    final discountAmount = _isDiscountApplied ? cartTotal * 0.10 : 0.0; // 10% discount for demo
    final finalTotal = cartTotal + shippingCost - discountAmount;

    final addressesAsync = ref.watch(addressNotifierProvider);
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      // AppBar removido para evitar problemas directos
      body: Stack(
        children: [
          SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FINALIZAR COMPRA',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 32),

              // ─── Saved Addresses (Pill List) ───
              addressesAsync.when(
                data: (addresses) {
                  if (addresses.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'DIRECCIONES GUARDADAS / SAVED ADDRESSES',
                          style: TextStyle(
                            fontWeight: FontWeight.w900, 
                            fontSize: 10, 
                            letterSpacing: 2,
                            color: Colors.black.withValues(alpha: 0.4)
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: addresses.length,
                          itemBuilder: (context, index) {
                            final addr = addresses[index];
                            final isSelected = _addressController.text == addr.address;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _emailController.text = addr.email;
                                  _nameController.text = addr.name;
                                  _phoneController.text = addr.phone;
                                  _addressController.text = addr.address;
                                  _cityController.text = addr.city;
                                  _postalCodeController.text = addr.postalCode;
                                  _selectedAddressId = addr.id;
                                  _isAddressStepExpanded = false;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 240,
                                margin: const EdgeInsets.only(right: 16, bottom: 8, top: 4),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF202020) : Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFF202020),
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isSelected 
                                          ? Colors.black.withValues(alpha: 0.15) 
                                          : Colors.black.withValues(alpha: 0.05),
                                      offset: const Offset(6, 6),
                                      blurRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            addr.name.toUpperCase(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 13,
                                              color: isSelected ? Colors.white : const Color(0xFF202020),
                                              letterSpacing: 0.5
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (isSelected) 
                                          const Icon(Icons.check_circle, color: Colors.white, size: 16),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      addr.address,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected ? Colors.white.withValues(alpha: 0.7) : Colors.black54,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${addr.postalCode} ${addr.city}'.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                        color: isSelected ? Colors.white.withValues(alpha: 0.5) : Colors.black38,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              // ─── Post-Industrial Shipping Header ───
              GestureDetector(
                onTap: () => setState(() => _isAddressStepExpanded = !_isAddressStepExpanded),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFF202020), width: 2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32, height: 32,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0xFF202020), 
                        ),
                        child: const Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                      ),
                      const SizedBox(width: 20),
                      const Expanded(
                        child: Text(
                          'DATOS DE ENVÍO / SHIPPING DATA',
                          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 3, fontSize: 12),
                        ),
                      ),
                      Icon(_isAddressStepExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, size: 28),
                    ],
                  ),
                ),
              ),
  
              if (_isAddressStepExpanded)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Color(0xFF202020), width: 1.5),
                      right: BorderSide(color: Color(0xFF202020), width: 1.5),
                      bottom: BorderSide(color: Color(0xFF202020), width: 1.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildTextField(
                        _emailController,
                        'Email',
                        TextInputType.emailAddress,
                        (v) => v!.isEmpty || !v.contains('@') ? 'Email inválido' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _nameController,
                        'Nombre Completo',
                        TextInputType.name,
                        (v) => v!.isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _phoneController,
                        'Teléfono',
                        TextInputType.phone,
                        (v) => v!.isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _addressController,
                        'Dirección',
                        TextInputType.streetAddress,
                        (v) => v!.isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildTextField(
                              _cityController,
                              'Ciudad',
                              TextInputType.text,
                              (v) => v!.isEmpty ? 'Requerido' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              _postalCodeController,
                              'Código Postal',
                              TextInputType.number,
                              (v) => v!.isEmpty ? 'Requerido' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isAddressStepExpanded = false);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF202020),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 60),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          elevation: 0,
                        ),
                        child: const Text(
                          'SIGUIENTE PASO / NEXT', 
                          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 3, fontSize: 11)
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Color(0xFF202020), width: 2),
                      right: BorderSide(color: Color(0xFF202020), width: 2),
                      bottom: BorderSide(color: Color(0xFF202020), width: 2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: Colors.green, size: 24),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _nameController.text.isEmpty ? 'DATOS PENDIENTES' : _nameController.text.toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1),
                            ),
                            if (_addressController.text.isNotEmpty)
                              Text(
                                '${_addressController.text}, ${_cityController.text}'.toUpperCase(),
                                style: const TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                              ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _isAddressStepExpanded = true),
                        child: const Text(
                          'EDITAR',
                          style: TextStyle(color: Color(0xFF202020), fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 48),

              // Resumen
              Container(
                padding: const EdgeInsets.all(24),
                color: Colors.grey.shade50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'RESUMEN',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (authState != null) ...[
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _discountController,
                              decoration: const InputDecoration(
                                hintText: 'CÓDIGO DE DESCUENTO',
                                hintStyle: TextStyle(fontSize: 11, letterSpacing: 1),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                              ),
                              enabled: !_isDiscountApplied,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _isDiscountApplied ? null : () {
                              if (_discountController.text.trim().toUpperCase() == 'CROMA10') {
                                setState(() => _isDiscountApplied = true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Descuento del 10% aplicado ✅', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.green)
                                );
                              } else if (_discountController.text.trim().isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Código inválido ❌'), backgroundColor: Colors.red)
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF202020),
                              foregroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                            child: const Text('APLICAR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(color: Colors.black12, thickness: 1),
                      ),
                    ],
                    _buildSummaryRow(
                      'Subtotal',
                      '${cartTotal.toStringAsFixed(2)} €',
                      isBold: false,
                    ),
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                      'Envío',
                      shippingCost == 0
                          ? 'Gratis'
                          : '${shippingCost.toStringAsFixed(2)} €',
                      isBold: false,
                    ),
                    if (_isDiscountApplied) ...[
                      const SizedBox(height: 8),
                      _buildSummaryRow(
                        'Descuento (10%)',
                        '-${discountAmount.toStringAsFixed(2)} €',
                        isBold: false,
                        color: Colors.green,
                      ),
                    ],
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: Color(0xFF202020), thickness: 1),
                    ),
                    _buildSummaryRow(
                      'TOTAL',
                      '${finalTotal.toStringAsFixed(2)} €',
                      isBold: true,
                    ),
                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: _isProcessing ? null : _processPayment,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CromaLoading(size: 24),
                            )
                          : const Text('PAGAR AHORA'),
                    ),
                  ],
                ),
              ),
            ],
          ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white.withValues(alpha: 0.8),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => context.pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    TextInputType type,
    String? Function(String?) validator,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: validator,
    );
  }

  Widget _buildSummaryRow(String label, String value, {required bool isBold, Color? color}) {
    final style = Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontWeight: isBold ? FontWeight.w900 : FontWeight.normal,
      fontSize: isBold ? 18 : 14,
      color: color,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}
