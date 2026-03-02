import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;

    return Drawer(
      backgroundColor: const Color(0xFF1A1A1A),
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              border: Border(bottom: BorderSide(color: Colors.white10)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'CROMA',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 4),
                  ),
                  Text(
                    'ADMIN CONTROL',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 2),
                  ),
                ],
              ),
            ),
          ),
          _DrawerTile(
            icon: Icons.dashboard_outlined,
            label: 'DASHBOARD',
            isActive: currentPath == '/admin',
            onTap: () {
              context.pop();
              context.go('/admin');
            },
          ),
          ExpansionTile(
            leading: const Icon(Icons.inventory_2_outlined, color: Colors.white24, size: 18),
            title: const Text('CATÁLOGO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1)),
            collapsedIconColor: Colors.white24,
            iconColor: Colors.white,
            childrenPadding: const EdgeInsets.only(left: 16),
            children: [
              _DrawerTile(
                icon: Icons.subdirectory_arrow_right,
                label: 'PRODUCTOS',
                isActive: currentPath == '/admin/products',
                onTap: () {
                  context.pop();
                  context.go('/admin/products');
                },
              ),
              _DrawerTile(
                icon: Icons.subdirectory_arrow_right,
                label: 'CATEGORÍAS',
                isActive: currentPath == '/admin/categories',
                onTap: () {
                  context.pop();
                  context.go('/admin/categories');
                },
              ),
              _DrawerTile(
                icon: Icons.subdirectory_arrow_right,
                label: 'MARCAS',
                isActive: currentPath == '/admin/brands',
                onTap: () {
                  context.pop();
                  context.go('/admin/brands');
                },
              ),
              _DrawerTile(
                icon: Icons.subdirectory_arrow_right,
                label: 'COLORES',
                isActive: currentPath == '/admin/colors',
                onTap: () {
                  context.pop();
                  context.go('/admin/colors');
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.shopping_bag_outlined, color: Colors.white24, size: 18),
            title: const Text('VENTAS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1)),
            collapsedIconColor: Colors.white24,
            iconColor: Colors.white,
            childrenPadding: const EdgeInsets.only(left: 16),
            children: [
              _DrawerTile(
                icon: Icons.subdirectory_arrow_right,
                label: 'PEDIDOS',
                isActive: currentPath == '/admin/orders',
                onTap: () {
                  context.pop();
                  context.go('/admin/orders');
                },
              ),
              _DrawerTile(
                icon: Icons.subdirectory_arrow_right,
                label: 'CUPONES',
                isActive: currentPath == '/admin/coupons',
                onTap: () {
                  context.pop();
                  context.go('/admin/coupons');
                },
              ),
              _DrawerTile(
                icon: Icons.subdirectory_arrow_right,
                label: 'DEVOLUCIONES',
                isActive: currentPath == '/admin/returns',
                onTap: () {
                  context.pop();
                  context.go('/admin/returns');
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.settings_outlined, color: Colors.white24, size: 18),
            title: const Text('SISTEMA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1)),
            collapsedIconColor: Colors.white24,
            iconColor: Colors.white,
            childrenPadding: const EdgeInsets.only(left: 16),
            children: [
              _DrawerTile(
                icon: Icons.subdirectory_arrow_right,
                label: 'USUARIOS',
                isActive: currentPath == '/admin/users',
                onTap: () {
                  context.pop();
                  context.go('/admin/users');
                },
              ),
              _DrawerTile(
                icon: Icons.subdirectory_arrow_right,
                label: 'MARKETING',
                isActive: currentPath == '/admin/marketing',
                onTap: () {
                  context.pop();
                  context.go('/admin/marketing');
                },
              ),
            ],
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
            title: const Text(
              'CERRAR SESIÓN',
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1),
            ),
            onTap: () => context.go('/profile'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? Colors.white : Colors.white24,
        size: 18,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white24,
          fontWeight: FontWeight.w900,
          fontSize: 11,
          letterSpacing: 1,
        ),
      ),
      onTap: onTap,
      tileColor: isActive ? Colors.white.withValues(alpha: 0.03) : null,
    );
  }
}
