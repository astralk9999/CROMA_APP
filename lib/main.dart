import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'app.dart';
import 'config/env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    debugPrint('Initializing Environment...');
    await Env.init();
    debugPrint('Environment Ready.');

    debugPrint('Initializing Supabase...');
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );
    debugPrint('Supabase Ready.');

    debugPrint('Initializing Stripe...');
    Stripe.publishableKey = Env.stripePublishableKey;
    await Stripe.instance.applySettings();
    debugPrint('Stripe Ready.');
  } catch (e) {
    debugPrint('CRITICAL INITIALIZATION ERROR: $e');
  }

  debugPrint('Launching App...');
  runApp(const ProviderScope(child: CromaApp()));
}
