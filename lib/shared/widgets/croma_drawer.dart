import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:croma_app/config/theme.dart';
import 'package:croma_app/features/home/providers/category_provider.dart';
import 'package:croma_app/features/auth/providers/auth_provider.dart';
import 'package:croma_app/core/services/supabase_service.dart';

class CromaDrawer extends ConsumerWidget {
  const CromaDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(allCategoriesProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    return Drawer(
      backgroundColor: AppTheme.white,
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.black),
            child: Center(
              child: Image.asset(
                'assets/images/chromakopia_logo.png',
                height: 40,
                // Removed color filter to show logo correctly
              ),
            ),
          ),

          // Categories Section
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSectionHeader('CATEGORIES'),
                categoriesAsync.when(
                  data: (categories) => Column(
                    children: categories
                        .map(
                          (cat) => ListTile(
                            title: Text(
                              cat.name.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              context.pop();
                              context.push('/catalog/${cat.slug}');
                            },
                          ),
                        )
                        .toList(),
                  ),
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(color: AppTheme.black),
                    ),
                  ),
                  error: (err, _) => ListTile(
                    title: const Text('Error loading categories'),
                    subtitle: Text(err.toString()),
                  ),
                ),

                const Divider(),
                _buildSectionHeader('SHOP BY COLLECTION'),
                _buildDrawerItem(
                  context,
                  'VIRAL TRENDS',
                  Icons.trending_up,
                  () => context.push('/catalog/viral-trends'),
                ),
                _buildDrawerItem(
                  context,
                  'SALE / OUTLET',
                  Icons.local_offer,
                  () => context.push('/catalog/sale'),
                ),
                _buildDrawerItem(
                  context,
                  'BESTSELLERS',
                  Icons.star_outline,
                  () => context.push('/catalog/bestsellers'),
                ),

                const Divider(),
                _buildSectionHeader('ACCOUNT'),
                if (isAuthenticated) ...[
                  _buildDrawerItem(
                    context,
                    'MY PROFILE',
                    Icons.person_outline,
                    () => context.push('/account'),
                  ),
                  _buildDrawerItem(context, 'SIGN OUT', Icons.logout, () async {
                    await SupabaseService.signOut();
                    if (context.mounted) {
                      context.pop();
                      context.go('/'); // Return to home on sign out
                    }
                  }),
                ] else
                  _buildDrawerItem(
                    context,
                    'SIGN IN / REGISTER',
                    Icons.login,
                    () => context.push('/login'),
                  ),

                const Divider(),
                _buildSectionHeader('THE BRAND'),
                _buildDrawerItem(
                  context,
                  'OUR MANIFESTO',
                  Icons.auto_awesome,
                  () {},
                ),
                _buildDrawerItem(
                  context,
                  'CONTACT US',
                  Icons.mail_outline,
                  () {},
                ),
              ],
            ),
          ),

          // Footer version
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'CROMA v1.2.0',
              style: TextStyle(color: AppTheme.gray400, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.gray400,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.black, size: 22),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      onTap: () {
        context.pop();
        onTap();
      },
    );
  }
}
