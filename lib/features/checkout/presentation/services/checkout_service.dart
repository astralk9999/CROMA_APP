import '../../../../core/services/stripe_service.dart';
import '../../../../shared/models/shipping_address.dart';
import '../../../address/data/address_repository.dart';
import '../../../../core/services/supabase_service.dart';

class CheckoutService {
  static Future<bool> processPayment({
    required List<Map<String, dynamic>> items,
    required Map<String, dynamic> shippingAddress,
    String? selectedAddressId,
    double discountAmount = 0.0,
  }) async {
    // 1. Process Stripe Payment
    final user = SupabaseService.client.auth.currentUser;
    final success = await StripeService.processPayment(
      items: items,
      shippingAddress: shippingAddress,
      email: shippingAddress['email'] ?? '',
      userId: user?.id,
      discountAmount: discountAmount,
    );

    if (success && user != null) {
      // 2. Save address if it's new (not selected from list)
      if (selectedAddressId == null) {
        try {
          final repo = AddressRepository();
          await repo.saveAddress(ShippingAddress.fromJson(shippingAddress));
        } catch (e) {
          // Silently fail address saving to not block the purchase
        }
      }
    }

    return success;
  }
}
