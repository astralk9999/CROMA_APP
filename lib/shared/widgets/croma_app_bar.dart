import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:croma_app/config/theme.dart';
import 'package:croma_app/features/cart/providers/cart_provider.dart';
import 'package:croma_app/features/auth/providers/auth_provider.dart';

class CromaAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  const CromaAppBar({super.key, this.bottom});

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItemCount = ref.watch(cartItemCountProvider);

    return AppBar(
      backgroundColor: AppTheme.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppTheme.black),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      title: Image.asset(
        'assets/images/chromakopia_logo.png',
        height: 45,
        fit: BoxFit.contain,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, size: 28, color: AppTheme.black),
          onPressed: () => context.push('/search'),
        ),
        IconButton(
          icon: const Icon(
            Icons.person_outline,
            size: 28,
            color: AppTheme.black,
          ),
          onPressed: () {
            final isLoggedIn = ref.read(isAuthenticatedProvider);
            if (isLoggedIn) {
              context.push('/account');
            } else {
              context.push('/login');
            }
          },
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.shopping_bag_outlined,
                size: 28,
                color: AppTheme.black,
              ),
              onPressed: () => context.push('/cart'),
            ),
            if (cartItemCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.black,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$cartItemCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 8),
      ],
      bottom: bottom,
    );
  }
}
