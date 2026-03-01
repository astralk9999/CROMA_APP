import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CromaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CromaAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80.0,
      title: GestureDetector(
        onTap: () => context.go('/'),
        child: Image.asset(
          'assets/images/chromakopia_logo.png',
          height: 60, // Much larger logo
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.black,
    );
  }
}
