import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:croma_app/config/theme.dart';
import 'package:croma_app/core/services/supabase_service.dart';
import 'package:croma_app/features/account/providers/order_provider.dart';
import 'package:croma_app/features/account/widgets/order_card.dart';
import 'package:croma_app/shared/widgets/croma_app_bar.dart';
import 'package:croma_app/shared/widgets/croma_drawer.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = SupabaseService.currentUser;
    final ordersAsync = ref.watch(userOrdersProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const CromaAppBar(
          bottom: TabBar(
            labelColor: AppTheme.black,
            unselectedLabelColor: AppTheme.gray600,
            indicatorColor: AppTheme.black,
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'PERFIL'),
              Tab(text: 'PEDIDOS'),
            ],
          ),
        ),
        drawer: const CromaDrawer(),
        body: TabBarView(
          children: [
            // Profile Tab
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'INFORMACIÓN PESONAL',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  _buildProfileField('Email', user?.email ?? ''),
                  const SizedBox(height: 16),
                  _buildProfileField(
                    'Nombre',
                    user?.userMetadata?['full_name'] ?? 'Usuario',
                  ),

                  _buildProfileField(
                    'Nombre',
                    user?.userMetadata?['full_name'] ?? 'Usuario',
                  ),

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/favorites'),
                      icon: const Icon(Icons.favorite_border),
                      label: const Text('MIS FAVORITOS'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        foregroundColor: AppTheme.black,
                        side: const BorderSide(color: AppTheme.black),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await SupabaseService.signOut();
                        if (context.mounted) context.go('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('CERRAR SESIÓN'),
                    ),
                  ),
                ],
              ),
            ),

            // Orders Tab
            ordersAsync.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_bag_outlined,
                          size: 64,
                          color: AppTheme.gray400,
                        ),
                        const SizedBox(height: 16),
                        const Text('Aún no has realizado pedidos'),
                        TextButton(
                          onPressed: () => context.go('/catalog'),
                          child: const Text('EXPLORAR COLECCIÓN'),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) =>
                      OrderCard(order: orders[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.gray600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.gray100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.gray200),
          ),
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
