import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/shop/presentation/screens/shop_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/product_detail/presentation/screens/product_detail_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/checkout/presentation/screens/checkout_screen.dart';
import '../../features/checkout/presentation/screens/success_screen.dart';
import '../../features/about/presentation/screens/about_screen.dart';
import '../../features/contact/presentation/screens/contact_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/orders_screen.dart';
import '../../features/profile/presentation/screens/order_details_screen.dart';
import '../../features/profile/presentation/screens/returns_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/presentation/screens/admin_products_screen.dart';
import '../../features/admin/presentation/screens/admin_orders_screen.dart';
import '../../features/admin/presentation/screens/admin_users_screen.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/shop',
      builder: (context, state) => const ShopScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: '/product/:slug',
      builder: (context, state) {
        final slug = state.pathParameters['slug']!;
        return ProductDetailScreen(slug: slug);
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/success',
      builder: (context, state) => const SuccessScreen(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      path: '/contact',
      builder: (context, state) => const ContactScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) => const OrdersScreen(),
    ),
    GoRoute(
      path: '/orders/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return OrderDetailsScreen(orderId: id);
      },
    ),
    GoRoute(
      path: '/returns',
      builder: (context, state) => const ReturnsScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
      routes: [
        GoRoute(
          path: 'products',
          builder: (context, state) => const AdminProductsScreen(),
        ),
        GoRoute(
          path: 'orders',
          builder: (context, state) => const AdminOrdersScreen(),
        ),
        GoRoute(
          path: 'users',
          builder: (context, state) => const AdminUsersScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
  ],
);
