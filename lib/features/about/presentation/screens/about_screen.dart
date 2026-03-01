import 'package:flutter/material.dart';
import '../../../../shared/widgets/croma_app_bar.dart';
import '../../../../shared/widgets/scroll_fading_widget.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CromaAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScrollFadingWidget(
              child: Text(
                'QUÍENES\nSOMOS',
                style: Theme.of(
                  context,
                ).textTheme.displayLarge?.copyWith(height: 0.9),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 48),
            ScrollFadingWidget(
              child: Text(
                'Croma es más que una marca de streetwear. Es una declaración de intenciones nacida en las calles, donde lo industrial se encuentra con el diseño contemporáneo.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ScrollFadingWidget(
              child: Text(
                'Nos inspiramos en la arquitectura brutalista, la cultura underground y la vida urbana para crear prendas que no solo visten, sino que hablan. Cada colección es una experimentación con siluetas, texturas y materiales, buscando siempre desafiar los límites de la moda convencional.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 64),

            // Values Grid
            ScrollFadingWidget(
              child: Column(
                children: [
                  _buildValueItem(
                    context,
                    'DISEÑO',
                    'Siluetas arquitectónicas y minimalismo industrial.',
                  ),
                  const SizedBox(height: 32),
                  _buildValueItem(
                    context,
                    'CALIDAD',
                    'Materiales premium seleccionados meticulosamente.',
                  ),
                  const SizedBox(height: 32),
                  _buildValueItem(
                    context,
                    'EXCLUSIVIDAD',
                    'Drops limitados para asegurar una identidad única.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 64),
          ],
        ),
      ),
      // No bottom nav — accessed from Profile
    );
  }

  Widget _buildValueItem(
    BuildContext context,
    String title,
    String description,
  ) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(letterSpacing: 2.0),
        ),
        const SizedBox(height: 8),
        Container(width: 40, height: 2, color: Colors.black),
        const SizedBox(height: 16),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
