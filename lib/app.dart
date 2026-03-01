import 'package:flutter/material.dart';
import 'core/config/theme.dart';
import 'core/config/router.dart';

class CromaApp extends StatelessWidget {
  const CromaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CROMA',
      theme: AppTheme.lightTheme,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
