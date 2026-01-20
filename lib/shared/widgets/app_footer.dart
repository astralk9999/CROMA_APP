import 'package:flutter/material.dart';
import 'package:croma_app/config/theme.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      color: AppTheme.white,
      child: Column(
        children: [
          Image.asset('assets/images/chromakopia_logo.png', height: 48),
          const SizedBox(height: 32),
          const Text(
            'ARTE, CULTURA Y STREETWEAR.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 48),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FooterLink('ABOUT US'),
              _FooterLink('SHIPPING'),
              _FooterLink('RETURNS'),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_FooterLink('PRIVACY'), _FooterLink('CONTACT')],
          ),
          const SizedBox(height: 64),
          const Text(
            '© 2026 CROMA COLLECTIVE.\nALL RIGHTS RESERVED.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.gray400,
              fontSize: 10,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  const _FooterLink(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: () {},
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
