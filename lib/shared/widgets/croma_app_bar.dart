import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CromaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;

  const CromaAppBar({
    super.key,
    this.title,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56.0); // Thinner app bar

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 56.0,
      title: title ?? GestureDetector(
        onTap: () => context.go('/'),
        child: OverflowBox(
          minHeight: 0,
          maxHeight: 120, // Allow the logo to be oversized and stay centered
          child: Image.asset(
            'assets/images/chromakopia_logo.png',
            height: 80, // Oversized logo
            fit: BoxFit.contain,
            color: Colors.white, // Ensure visibility on dark app bar
          ),
        ),
      ),
      actions: actions,
      centerTitle: true,
      elevation: 0,
      backgroundColor: const Color(0xFF202020),
    );
  }
}
