import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/favorites/data/favorites_provider.dart';
import '../../features/cart/providers/cart_provider.dart';

class CromaBottomNav extends ConsumerWidget {
  final int currentIndex;

  const CromaBottomNav({super.key, required this.currentIndex});

  static const _routes = ['/', '/shop', '/favorites', '/cart', '/profile'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favCount = ref.watch(favoritesProvider).length;
    final cartState = ref.watch(cartNotifierProvider);
    final cartCount = cartState.whenOrNull(
      data: (items) => items.fold<int>(0, (sum, i) => sum + i.quantity),
    ) ?? 0;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Color(0xFF333333), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(5, (index) {
              return Expanded(
                child: _NavItem(
                  icon: _iconForIndex(index, false),
                  activeIcon: _iconForIndex(index, true),
                  label: _labelForIndex(index),
                  isActive: currentIndex == index,
                  badge: index == 2 ? favCount : (index == 3 ? cartCount : 0),
                  onTap: () {
                    if (currentIndex == index) return;
                    context.go(_routes[index]);
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  IconData _iconForIndex(int index, bool active) {
    switch (index) {
      case 0:
        return active ? Icons.home_filled : Icons.home_outlined;
      case 1:
        return active ? Icons.grid_view : Icons.grid_view_outlined;
      case 2:
        return active ? Icons.favorite : Icons.favorite_border;
      case 3:
        return active ? Icons.shopping_bag : Icons.shopping_bag_outlined;
      case 4:
        return active ? Icons.person : Icons.person_outline;
      default:
        return Icons.circle;
    }
  }

  String _labelForIndex(int index) {
    switch (index) {
      case 0: return 'HOME';
      case 1: return 'SHOP';
      case 2: return 'FAVS';
      case 3: return 'CART';
      case 4: return 'PERFIL';
      default: return '';
    }
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final int badge;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Active indicator line
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 2,
            width: isActive ? 24 : 0,
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          // Icon with badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                size: 22,
                color: isActive ? Colors.white : const Color(0xFF888888),
              ),
              if (badge > 0)
                Positioned(
                  right: -8,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      badge > 9 ? '9+' : '$badge',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF888888),
              fontSize: 9,
              fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
