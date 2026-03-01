import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/croma_app_bar.dart';
import '../../../../shared/widgets/croma_loading.dart';
import 'package:fashion_store/features/cart/providers/cart_provider.dart';
import 'package:fashion_store/features/address/providers/address_provider.dart';
import '../../../../core/services/auth_provider.dart';
import '../../../../shared/models/shipping_address.dart';
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

  bool _isProcessing = false;
  bool _isAddressStepExpanded = true;
  String? _selectedAddressType; // 'home', 'work', 'other'
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
        // Limpiar carrito
        await ref.read(cartNotifierProvider.notifier).clearCart();
        if (mounted) {
          context.go('/success');
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
    final cartState = ref.watch(cartNotifierProvider);
    final cartItems = cartState.value ?? [];
    final cartTotal = ref.read(cartNotifierProvider.notifier).cartTotal;
    const shippingCost = 0.0; // Todo: Calcular basado en dirección
    final finalTotal = cartTotal + shippingCost;

    final addressesAsync = ref.watch(addressNotifierProvider);

    return Scaffold(
      appBar: const CromaAppBar(),
      body: SingleChildScrollView(
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

              // ─── Saved Addresses (Horizontal List) ───
              addressesAsync.when(
                data: (addresses) {
                  if (addresses.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DIRECCIONES GUARDADAS',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 140,
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
                                  _isAddressStepExpanded = false;
                                });
                              },
                              child: Container(
                                width: 220,
                                margin: const EdgeInsets.only(right: 12, bottom: 8, top: 2),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF202020) : Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFF202020),
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(isSelected ? 30 : 10),
                                      offset: const Offset(4, 4),
                                      blurRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      addr.name.toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12,
                                        color: isSelected ? Colors.white : const Color(0xFF202020),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      addr.address,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isSelected ? Colors.white70 : Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '${addr.postalCode} ${addr.city}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isSelected ? Colors.white70 : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              // ─── Shipping Address Section ───
              GestureDetector(
                onTap: () => setState(() => _isAddressStepExpanded = !_isAddressStepExpanded),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFF202020), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Color(0xFF202020), shape: BoxShape.circle),
                        child: const Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'DIRECCIÓN DE ENVÍO',
                        style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
                      ),
                      const Spacer(),
                      Icon(_isAddressStepExpanded ? Icons.expand_less : Icons.expand_more),
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
                        onPressed: () => setState(() => _isAddressStepExpanded = false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF202020),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        ),
                        child: const Text('CONTINUAR', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(top: 8),
                  color: Colors.grey.shade100,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _nameController.text.isEmpty ? 'Dirección no completada' : _nameController.text.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      if (_addressController.text.isNotEmpty)
                        Text(
                          '${_addressController.text}, ${_cityController.text}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
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

  Widget _buildSummaryRow(String label, String value, {required bool isBold}) {
    final style = Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontWeight: isBold ? FontWeight.w900 : FontWeight.normal,
      fontSize: isBold ? 18 : 14,
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
