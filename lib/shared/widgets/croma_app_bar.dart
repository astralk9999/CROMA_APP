import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CromaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showCart;
  final bool showSearch;

  const CromaAppBar({super.key, this.showCart = true, this.showSearch = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () => context.go('/'),
        child: Image.asset(
          'assets/images/chromakopia_logo.png',
          height: 40,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      actions: [
        if (showSearch)
          IconButton(
            icon: const Icon(Icons.search, size: 24),
            onPressed: () => context.push('/search'),
          ),
        if (showCart)
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, size: 22),
            onPressed: () => context.push('/cart'),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
