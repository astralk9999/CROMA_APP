import 'package:flutter/material.dart';
import 'package:croma_app/config/theme.dart';

class BrandManifesto extends StatelessWidget {
  const BrandManifesto({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      color: AppTheme.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'THE MANIFESTO',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppTheme.gray400,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'MÁS QUE MODA,\nUN ESTILO DE VIDA.',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          Text(
            'En CROMA creemos que la ropa es el lienzo de tu identidad. Cada pieza está diseñada con una atención obsesiva al detalle.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.gray600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _buildStat(context, '10k+', 'Styles'),
              const SizedBox(width: 48),
              _buildStat(context, '100%', 'Quality'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineLarge),
        Text(
          label.toUpperCase(),
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppTheme.gray400),
        ),
      ],
    );
  }
}
