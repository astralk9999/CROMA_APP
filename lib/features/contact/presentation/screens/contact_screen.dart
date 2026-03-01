import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/widgets/croma_app_bar.dart';
import '../../../../shared/widgets/scroll_fading_widget.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  Future<void> _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

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
                'CONTACTO',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 48),
            ScrollFadingWidget(
              child: Text(
                '¿Tienes alguna pregunta, problema con tu pedido o propuesta de colaboración? Estamos aquí para escucharte.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 64),

            // Contact Channels
            ScrollFadingWidget(
              child: Column(
                children: [
                  _buildContactCard(
                    context,
                    icon: Icons.support_agent_outlined,
                    title: 'ATENCIÓN AL CLIENTE',
                    description: 'Dudas sobre pedidos, envíos o devoluciones.',
                    actionText: 'soporte@cromaclub.com',
                    onTap: () => _launchEmail('soporte@cromaclub.com'),
                  ),
                  const SizedBox(height: 24),
                  _buildContactCard(
                    context,
                    icon: Icons.business_center_outlined,
                    title: 'PRENSA Y COLABORACIONES',
                    description:
                        'Propuestas comerciales y medios de comunicación.',
                    actionText: 'info@cromaclub.com',
                    onTap: () => _launchEmail('info@cromaclub.com'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.black),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              actionText,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
