import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_config.dart';
import 'core/services/supabase_service.dart';
import 'core/services/stripe_service.dart';
import 'core/services/dio_client.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Cargar variables de entorno
  await AppConfig.loadConfig();

  // 2. Inicializar servicios core
  await SupabaseService.initialize();
  DioClient.initialize();

  // Stripe requiere la publishable key
  try {
    await StripeService.initialize(AppConfig.stripePublishableKey);
  } catch (e) {
    debugPrint('Stripe init error (posible clave faltante o inválida): $e');
  }

  runApp(
    // ProviderScope es necesario para Riverpod
    const ProviderScope(child: CromaApp()),
  );
}
