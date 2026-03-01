import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CromaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CromaAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56.0); // Thinner app bar

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 56.0,
      title: GestureDetector(
        onTap: () => context.go('/'),
        child: Image.asset(
          'assets/images/chromakopia_logo.png',
          height: 48, // Logo takes up most of the 56px height
          fit: BoxFit.contain,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.black,
    );
  }
}
