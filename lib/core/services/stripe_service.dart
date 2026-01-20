import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:croma_app/config/env.dart';
import 'package:croma_app/core/services/supabase_service.dart';
import 'package:croma_app/features/cart/screens/checkout_webview.dart';
import 'package:croma_app/features/cart/providers/cart_provider.dart';

class StripeService {
  static final StripeService instance = StripeService._internal();

  factory StripeService() {
    return instance;
  }

  StripeService._internal();

  Future<void> makePayment({
    required List<CartItem> items,
    required double amount,
    required BuildContext context,
    required Function onSuccess,
  }) async {
    try {
      // 1. Create Checkout Session on Server (Using existing Web Endpoint)
      final sessionData = await _createCheckoutSession(items);
      final url = sessionData['url'];
      final orderId = sessionData['orderId'];

      if (url == null) throw Exception('Failed to get checkout URL');

      if (!context.mounted) return;

      // 2. Open WebView
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CheckoutWebView(
            url: url,
            successUrl:
                'app-checkout/success', // We will modify this matching logic
            cancelUrl: 'app-checkout/cancel',
          ),
        ),
      );

      // 3. Handle Result
      if (result == true) {
        onSuccess(orderId);
      } else {
        // Canceled or closed
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> _createCheckoutSession(
    List<CartItem> items,
  ) async {
    final url = Uri.parse('${Env.apiUrl}/checkout');
    final user = SupabaseService.currentUser;
    final token = SupabaseService.client.auth.currentSession?.accessToken;

    final body = {
      'items': items
          .map(
            (item) => {
              'id': item.product.id,
              'name': item.product.name,
              'slug': item.product.slug,
              'image': item.product.images.isNotEmpty
                  ? item.product.images[0]
                  : '',
              'size': item.size,
              'quantity': item.quantity,
              'price': item.product.price,
            },
          )
          .toList(),
      'shippingAddress': {
        // Mock shipping address, checkout.ts requires it
        'name': user?.userMetadata?['full_name'] ?? 'Guest',
        'email': user?.email ?? 'guest@croma.shop',
        'address': '123 Croma St',
        'city': 'Madrid',
        'country': 'ES',
        'postal_code': '28001',
        'phone': '555-555-555',
      },
      // Important: We use a custom origin or a distinguishable path for interception
      // But checkout.ts uses this for success_url construction
      // We will intercept ANY navigation containing 'checkout/success' regardless of domain
      'origin': 'https://croma.shop',
      'guestEmail': user?.email ?? 'guest@croma.shop',
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Cookie': 'sb-access-token=$token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create checkout session: ${response.body}');
    }

    return jsonDecode(response.body);
  }
}
