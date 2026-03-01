import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../constants/api_constants.dart';
import 'dio_client.dart';

class StripeService {
  static Future<void> initialize(String publishableKey) async {
    Stripe.publishableKey = publishableKey;
    await Stripe.instance.applySettings();
  }

  /// Conecta con el endpoint /api/mobile-checkout para crear el PaymentIntent
  static Future<bool> processPayment({
    required List<Map<String, dynamic>> items,
    required Map<String, dynamic> shippingAddress,
    String? email,
    String? userId,
  }) async {
    try {
      // 1. Llamar al backend existente de Astro
      final response = await DioClient.instance.post(
        ApiConstants.mobileCheckoutPath,
        data: {
          'items': items,
          'shippingAddress': shippingAddress,
          'email': email ?? shippingAddress['email'],
          'userId': userId,
        },
      );

      final data = response.data;
      if (data['error'] != null) {
        throw Exception(data['error']);
      }

      final clientSecret = data['clientSecret'];
      if (clientSecret == null) {
        throw Exception('No clientSecret received from backend');
      }

      // 2. Inicializar el Payment Sheet de Stripe
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'CROMA',
          style: ThemeMode
              .light, // CROMA is predominantly light/black-on-white based on Astro design
          billingDetails: BillingDetails(
            email: email ?? shippingAddress['email'],
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

      // 3. Mostrar el Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      // Si llega aquí, el pago fue exitoso
      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        // Usuario canceló, no es un error real
        return false;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
