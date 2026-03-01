import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CromaBottomNav extends StatelessWidget {
  final int currentIndex;

  const CromaBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: Theme.of(
        context,
      ).textTheme.labelSmall?.copyWith(color: Colors.black, fontSize: 10),
      unselectedLabelStyle: Theme.of(
        context,
      ).textTheme.labelSmall?.copyWith(color: Colors.grey, fontSize: 10),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'HOME',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_outlined),
          activeIcon: Icon(Icons.grid_view),
          label: 'SHOP',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          activeIcon: Icon(Icons.shopping_bag),
          label: 'CART',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'ABOUT',
        ),
      ],
      onTap: (index) {
        if (index == currentIndex) return;

        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/shop');
            break;
          case 2:
            context.go('/cart');
            break;
          case 3:
            context.go('/about');
            break;
        }
      },
    );
  }
}
