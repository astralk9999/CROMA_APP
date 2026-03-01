import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:croma_app/config/theme.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: BoxConstraints(
        minHeight: screenHeight * 0.6,
        maxHeight: 600,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.network(
            'https://images.unsplash.com/photo-1490481651871-ab68624d5517?q=80&w=2000&auto=format&fit=crop',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: AppTheme.gray800),
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppTheme.black.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: textTheme.displayMedium?.copyWith(
                          color: AppTheme.white,
                          height: 0.9,
                        ),
                        children: const [
                          TextSpan(text: 'URBAN\n'),
                          TextSpan(
                            text: 'COLLECTIVE',
                            style: TextStyle(
                              color: AppTheme.gray400, // Gradient effect
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Elevando el streetwear a una nueva dimensión.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppTheme.gray200,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push('/catalog'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.white,
                        foregroundColor: AppTheme.black,
                      ),
                      child: const Text('SHOP NOW'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.push('/catalog/viral-trends'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.white,
                        side: const BorderSide(color: AppTheme.white, width: 2),
                      ),
                      child: const Text('EXPLORE TRENDS'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
