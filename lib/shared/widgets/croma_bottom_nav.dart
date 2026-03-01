import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/favorites/data/favorites_provider.dart';
import '../../features/cart/providers/cart_provider.dart';

class CromaBottomNav extends ConsumerWidget {
  final int currentIndex;

  const CromaBottomNav({super.key, required this.currentIndex});

  static const _routes = ['/', '/shop', '/cart', '/favorites', '/profile'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favCount = ref.watch(favoritesProvider).length;
    final cartState = ref.watch(cartNotifierProvider);
    final cartCount = cartState.whenOrNull(
      data: (items) => items.fold<int>(0, (sum, i) => sum + i.quantity),
    ) ?? 0;

    return Padding(
      // We keep it floating a bit above the screen bottom like a modern pill
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: SizedBox(
        height: 100, // accommodate the floating button
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // The Grey Bar
            Positioned(
              left: 0, right: 0, bottom: 0,
              height: 70, // 70px bar height
              child: CustomPaint(
                // Very light grey to match the provided image
                painter: _FixedCurvedBarPainter(color: const Color(0xFFE2E2E2)), 
              ),
            ),

            // The Icons
            Positioned(
              left: 0, right: 0, bottom: 0, height: 70,
              child: Row(
                children: [
                  _buildNavItem(context, 0, Icons.home_rounded, Icons.home_outlined, 'Home', currentIndex),
                  _buildNavItem(context, 1, Icons.search_rounded, Icons.search_outlined, 'Shop', currentIndex),
                  const Expanded(child: SizedBox()), // Center gap for the floating button
                  _buildNavItem(context, 3, Icons.favorite_rounded, Icons.favorite_outline_rounded, 'Favs', currentIndex, badge: favCount),
                  _buildNavItem(context, 4, Icons.person_rounded, Icons.person_outline_rounded, 'Perfil', currentIndex),
                ],
              ),
            ),

            // The Center Button (Cart)
            Positioned(
              bottom: 35, // Elevates the 64px button so its center sits exactly on the top edge of the 70px grey bar
              child: GestureDetector(
                onTap: () => context.go('/cart'),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFF262626), // Dark solid grey/black matching the image's center button
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                    ]
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 28),
                      if (cartCount > 0)
                        Positioned(
                          top: 10, right: 10,
                          child: _buildBadge(cartCount, true),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData activeIcon, IconData inactiveIcon, String label, int currentIndex, {int badge = 0}) {
    final isSelected = currentIndex == index;
    final color = isSelected ? Colors.black : Colors.black54; // Inactive icons are a softer grey
    final icon = isSelected ? activeIcon : inactiveIcon;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (currentIndex != index) {
            context.go(_routes[index]);
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 26),
                if (badge > 0)
                  Positioned(
                    top: -4, right: -6,
                    child: _buildBadge(badge, false),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(int count, bool isDarkBg) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDarkBg ? Colors.white : Colors.red,
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      child: Text(
        count > 9 ? '9+' : '$count',
        style: TextStyle(
          color: isDarkBg ? Colors.black : Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _FixedCurvedBarPainter extends CustomPainter {
  final Color color;
  _FixedCurvedBarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    
    final host = Rect.fromLTWH(0, 0, size.width, size.height);
    // Button width is 64. We leave a 10px circular gap margin on each side -> guest width 84
    // The guest rect center is x = width/2, y = 0
    final guest = Rect.fromCenter(center: Offset(size.width / 2, 0), width: 84, height: 84);
    
    final path = const CircularNotchedRectangle().getOuterPath(host, guest);
    
    // Add nice rounded corners to the whole bottom bar for that premium floating look
    final rrect = RRect.fromRectAndCorners(
      host,
      topLeft: const Radius.circular(28),
      topRight: const Radius.circular(28),
      bottomLeft: const Radius.circular(28),
      bottomRight: const Radius.circular(28),
    );
    
    // Intersect the notch path with the rounded rectangle
    final finalPath = Path.combine(PathOperation.intersect, Path()..addRRect(rrect), path);
    
    // Draw subtle shadow and the shape
    canvas.drawShadow(finalPath, Colors.black12, 10, true);
    canvas.drawPath(finalPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
