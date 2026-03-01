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
    // Map existing screen indices to the new order if needed.
    // Given the routes above: 0=Home, 1=Shop, 2=Cart, 3=Favs, 4=Profile.
    final favCount = ref.watch(favoritesProvider).length;
    final cartState = ref.watch(cartNotifierProvider);
    final cartCount = cartState.whenOrNull(
      data: (items) => items.fold<int>(0, (sum, i) => sum + i.quantity),
    ) ?? 0;

    return Container(
      color: Colors.transparent,
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background with animated notch
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 60,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: currentIndex.toDouble(), end: currentIndex.toDouble()),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutBack,
              builder: (context, value, child) {
                return CustomPaint(
                  painter: _CurvedBarPainter(
                    currentIndex: value,
                    itemCount: 5,
                    color: Colors.white,
                    shadowColor: Colors.black12,
                  ),
                );
              },
            ),
          ),

          // Icons
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 60,
            child: Row(
              children: List.generate(5, (index) {
                final isSelected = currentIndex == index;
                IconData icon;
                switch (index) {
                  case 0:
                    icon = Icons.home_rounded;
                    break;
                  case 1:
                    icon = Icons.search_rounded; // Replaced shop/grid with search
                    break;
                  case 2:
                    icon = Icons.shopping_cart_rounded; // Cart
                    break;
                  case 3:
                    icon = Icons.favorite_rounded; // Favorites
                    break;
                  case 4:
                    icon = Icons.person_rounded; // Profile
                    break;
                  default:
                    icon = Icons.circle;
                }

                // Calculate Badge
                int badge = 0;
                if (index == 2) badge = cartCount;
                if (index == 3) badge = favCount;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (currentIndex != index) {
                        context.go(_routes[index]);
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // Inactive icon
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isSelected ? 0.0 : 1.0,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(icon, color: Colors.grey[400], size: 28),
                              if (badge > 0)
                                Positioned(
                                  top: -4,
                                  right: -6,
                                  child: _buildBadge(badge, false),
                                ),
                            ],
                          ),
                        ),
                        // Small dot below when inactive? (The design has a dot below the *active* item if the circle goes up, or we can just keep it clean)
                        if (isSelected)
                          Positioned(
                            bottom: 8,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2E7D32), // Green accent
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          // The floating active circle
          TweenAnimationBuilder<double>(
            tween: Tween(begin: currentIndex.toDouble(), end: currentIndex.toDouble()),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutBack,
            builder: (context, value, child) {
              final double itemWidth = MediaQuery.of(context).size.width / 5;
              final double circleLeft = (itemWidth * value) + (itemWidth / 2) - 28;

              return Positioned(
                left: circleLeft,
                top: 0,
                child: child!,
              );
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFF2E7D32), // Green from the design
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Builder(
                builder: (context) {
                  IconData icon;
                  switch (currentIndex) {
                    case 0:
                      icon = Icons.home_rounded;
                      break;
                    case 1:
                      icon = Icons.search_rounded;
                      break;
                    case 2:
                      icon = Icons.shopping_cart_rounded;
                      break;
                    case 3:
                      icon = Icons.favorite_rounded;
                      break;
                    case 4:
                      icon = Icons.person_rounded;
                      break;
                    default:
                      icon = Icons.circle;
                  }
                  
                  int badge = 0;
                  if (currentIndex == 2) badge = cartCount;
                  if (currentIndex == 3) badge = favCount;

                  return Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Icon(icon, color: Colors.white, size: 28),
                      if (badge > 0)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: _buildBadge(badge, true),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(int count, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : const Color(0xFF2E7D32),
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      child: Text(
        count > 9 ? '9+' : '$count',
        style: TextStyle(
          color: isActive ? const Color(0xFF2E7D32) : Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _CurvedBarPainter extends CustomPainter {
  final double currentIndex;
  final int itemCount;
  final Color color;
  final Color shadowColor;

  _CurvedBarPainter({
    required this.currentIndex,
    required this.itemCount,
    required this.color,
    required this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    final shadowPaint = Paint()
      ..color = shadowColor
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final path = Path();
    final itemWidth = size.width / itemCount;
    final centerPointX = (itemWidth * currentIndex) + (itemWidth / 2);

    // Notch parameters
    final notchRadius = 36.0;
    const topMargin = 0.0;
    final curveDepth = notchRadius * 0.9;

    path.moveTo(0, topMargin);

    // Calculate start and end points of the notch
    final startX = centerPointX - notchRadius * 1.5;
    final endX = centerPointX + notchRadius * 1.5;

    // Draw line to start of notch
    path.lineTo(startX, topMargin);

    // Draw the smooth bezier notch
    path.cubicTo(
      startX + notchRadius / 2, topMargin,
      centerPointX - notchRadius, curveDepth,
      centerPointX, curveDepth,
    );
    path.cubicTo(
      centerPointX + notchRadius, curveDepth,
      endX - notchRadius / 2, topMargin,
      endX, topMargin,
    );

    // Finish the shape
    path.lineTo(size.width, topMargin);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Draw shadow then shape
    canvas.drawPath(path.shift(const Offset(0, -2)), shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CurvedBarPainter oldDelegate) {
    return oldDelegate.currentIndex != currentIndex;
  }
}
