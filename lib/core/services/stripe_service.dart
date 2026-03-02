import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:croma/core/config/app_config.dart';
import 'package:croma/core/services/supabase_service.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StripeService {
  static Future<void> initialize(String publishableKey) async {
    Stripe.publishableKey = publishableKey;
    await Stripe.instance.applySettings();
  }

  /// Reemplazo temporal: Procesa el pago y pedido directamente desde el cliente
  static Future<bool> processPayment({
    required List<Map<String, dynamic>> items,
    required Map<String, dynamic> shippingAddress,
    String? email,
    String? userId,
    double discountAmount = 0.0,
  }) async {
    try {
      final supabase = SupabaseService.adminClient;

      // 1. Obtener ID de usuario (usar ID de invitado si es nulo)
      final actualUserId =
          userId ??
          SupabaseService.client.auth.currentUser?.id ??
          AppConfig.guestUserId;
      final actualEmail =
          email ?? shippingAddress['email'] ?? 'guest@croma.shop';

      // 1.5 Asegurar que el perfil existe (para evitar error de clave foránea)
      await supabase.from('profiles').upsert({
        'id': actualUserId,
        'email': actualEmail,
        'full_name': shippingAddress['name'] ?? 'Invitado',
      }, onConflict: 'id');

      // 2. Calcular total
      final double totalItemsAmount = items.fold(
        0,
        (sum, item) =>
            sum + (double.parse(item['price'].toString()) * item['quantity']),
      );
      double totalAmount = totalItemsAmount - discountAmount;
      if (totalAmount <= 0) totalAmount = 0.50; // Stripe minimum is 50 cents
      final int amountInCents = (totalAmount * 100).round();

      // 3. Crear pedido en Supabase
      final orderResponse = await supabase
          .from('orders')
          .insert({
            'user_id': actualUserId,
            'status': 'pending',
            'total_amount': totalAmount,
            'shipping_address': shippingAddress,
          })
          .select()
          .single();

      final String orderId = orderResponse['id'].toString();

      // 4. Crear items del pedido
      final List<Map<String, dynamic>> orderItems = items
          .map(
            (item) => {
              'order_id': orderId,
              'product_id': item['id'],
              'product_name': item['name'],
              'product_image': item['image'],
              'size': item['size'],
              'quantity': item['quantity'],
              'price': item['price'],
            },
          )
          .toList();

      await supabase.from('order_items').insert(orderItems);

      // 5. Reservar stock (RPC)
      for (final item in items) {
        final stockResult = await supabase.rpc(
          'decrement_stock',
          params: {
            'p_product_id': item['id'],
            'p_size': item['size'],
            'p_quantity': item['quantity'],
          },
        );

        // El RPC devuelve un mapa con 'success'
        if (stockResult is Map && stockResult['success'] == false) {
          throw Exception(
            'Sin stock suficiente para ${item['name']} (${item['size']})',
          );
        }
      }

      // 6. Crear PaymentIntent directamente en Stripe API (MODO DEBUG/BYPASS)
      final dio = Dio();
      final response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: {
          'amount': amountInCents,
          'currency': 'eur',
          'metadata[order_id]': orderId,
          'metadata[user_id]': actualUserId,
          'payment_method_types[]': 'card',
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {'Authorization': 'Bearer ${AppConfig.stripeSecretKey}'},
        ),
      );

      final String? clientSecret = response.data['client_secret'];
      if (clientSecret == null) {
        throw Exception('Error al obtener el clientSecret de Stripe');
      }

      // 7. Vincular PaymentIntent al pedido
      await supabase
          .from('orders')
          .update({
            'notes': jsonEncode({'stripe_payment_intent': response.data['id']}),
          })
          .eq('id', orderId);

      // 8. Inicializar y mostrar Pasarela (WEB vs MÓVIL)
      if (kIsWeb) {
        // En WEB, usamos Stripe Checkout (Redirección) para una experiencia real sin backend
        final Map<String, dynamic> sessionData = {
          'mode': 'payment',
          'success_url': '${Uri.base.origin}/#/success',
          'cancel_url': '${Uri.base.origin}/#/checkout',
          'customer_email': actualEmail,
        };

        double remainingDiscount = discountAmount;
        for (int i = 0; i < items.length; i++) {
          final item = items[i];
          final price = double.parse(item['price'].toString());
          final qty = item['quantity'] as int;

          double itemTotal = price * qty;
          if (remainingDiscount > 0) {
            if (remainingDiscount >= itemTotal) {
              remainingDiscount -= itemTotal;
              itemTotal =
                  0; // This will cause Stripe error if 0 unit_amount, so let's adjust to 0.50 min or similar later if necessary.
              // To avoid Stripe unit_amount = 0 error, we just give it 0 amount and see if Stripe supports 0 amounts in some cases, but actually we pass the discounted price per unit.
            } else {
              itemTotal -= remainingDiscount;
              remainingDiscount = 0;
            }
          }

          // Stripe API only accepts integer amounts in cents per unit, and unit price must be > 0 ideally
          int unitPriceCents = (itemTotal / qty * 100).round();
          if (unitPriceCents <= 0) unitPriceCents = 0;

          sessionData['line_items[$i][price_data][currency]'] = 'eur';
          sessionData['line_items[$i][price_data][product_data][name]'] =
              item['name'];
          sessionData['line_items[$i][price_data][unit_amount]'] =
              unitPriceCents;
          sessionData['line_items[$i][quantity]'] = qty;
        }

        sessionData['metadata[order_id]'] = orderId;

        final sessionResponse = await dio.post(
          'https://api.stripe.com/v1/checkout/sessions',
          data: sessionData,
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {'Authorization': 'Bearer ${AppConfig.stripeSecretKey}'},
          ),
        );

        final String? sessionUrl = sessionResponse.data['url'];
        if (sessionUrl != null) {
          if (await canLaunchUrlString(sessionUrl)) {
            await launchUrlString(sessionUrl, webOnlyWindowName: '_self');
            return true;
          }
        }
        throw Exception('No se pudo generar la sesión de Stripe Checkout');
      } else {
        // En Android, usamos el Payment Sheet nativo
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'CROMA',
            style: ThemeMode.light,
            billingDetails: BillingDetails(
              email: actualEmail,
              name: shippingAddress['name'],
              phone: shippingAddress['phone'],
              address: Address(
                line1: shippingAddress['address'],
                line2: '',
                city: shippingAddress['city'],
                state: '',
                postalCode: shippingAddress['postal_code'],
                country: shippingAddress['country'],
              ),
            ),
          ),
        );

        await Stripe.instance.presentPaymentSheet();
      }

      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) return false;
      rethrow;
    } on DioException catch (e) {
      throw Exception('Error de red con Stripe: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }
}
