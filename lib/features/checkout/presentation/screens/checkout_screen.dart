import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/croma_app_bar.dart';
import '../../../../core/services/stripe_service.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../cart/providers/cart_provider.dart';

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

  @override
  void initState() {
    super.initState();
    // Pre-fill if logged in
    final user = SupabaseService.currentUser;
    if (user != null) {
      _emailController.text = user.email ?? '';
      _nameController.text = user.userMetadata?['full_name'] ?? '';
    }
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
              'productId': item.productId,
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

      final success = await StripeService.processPayment(
        items: apiItems,
        shippingAddress: shippingAddress,
        email: _emailController.text.trim(),
        userId: SupabaseService.currentUser?.id,
      );

      if (success && mounted) {
        // Limpiar carrito
        await ref.read(cartNotifierProvider.notifier).clearCart();
        if (context.mounted) {
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
    final cartTotal = ref.watch(cartNotifierProvider.notifier).cartTotal;
    // Envío gratis si total > 100, si no 5.90
    final shippingCost = cartTotal > 100 ? 0.0 : 5.90;
    final finalTotal = cartTotal + shippingCost;

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

              Text(
                'DATOS DE ENVÍO',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildTextField(
                _emailController,
                'Añade tu Email',
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
                      child: Divider(color: Colors.black, thickness: 1),
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
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
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
