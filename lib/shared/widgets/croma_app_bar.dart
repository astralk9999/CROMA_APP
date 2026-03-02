import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Size get preferredSize => const Size.fromHeight(80.0); // Taller for premium feel

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80.0,
      title: title ?? GestureDetector(
        onTap: () => context.go('/'),
        child: Image.asset(
          'assets/images/chromakopia_logo.png',
          height: 60, // Much larger logo
          fit: BoxFit.contain,
        ),
      ),
      actions: actions,
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: const IconThemeData(color: Colors.black),
      shape: const Border(
        bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1.0),
      ),
    );
  }
}
