import 'package:flutter/material.dart';
import 'package:croma_app/config/theme.dart';

class NewsletterForm extends StatelessWidget {
  const NewsletterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      color: AppTheme.black,
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'JOIN THE CULTURE',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppTheme.white,
                letterSpacing: 4,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Recibe un 10% de descuento y acceso exclusivo a nuevos lanzamientos.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.gray400),
          ),
          const SizedBox(height: 48),
          TextField(
            style: const TextStyle(color: AppTheme.white),
            cursorColor: AppTheme.white,
            decoration: InputDecoration(
              hintText: 'TU@EMAIL.COM',
              hintStyle: const TextStyle(color: AppTheme.gray600),
              filled: true,
              fillColor: AppTheme.gray900,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppTheme.gray800),
                borderRadius: BorderRadius.zero,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppTheme.white),
                borderRadius: BorderRadius.zero,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward, color: AppTheme.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Suscrito correctamente!'),
                      backgroundColor: AppTheme.brandRed,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
