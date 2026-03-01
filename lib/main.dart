import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_config.dart';
import 'core/services/supabase_service.dart';
import 'core/services/stripe_service.dart';
import 'core/services/dio_client.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Cargar variables de entorno e inicializar fecha
  await AppConfig.loadConfig();
  await initializeDateFormatting('es_ES', null);
  await initializeDateFormatting('en_US', null);

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
