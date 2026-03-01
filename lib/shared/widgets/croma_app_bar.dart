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
          height: 60,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.black,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
