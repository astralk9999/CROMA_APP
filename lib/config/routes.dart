import 'package:go_router/go_router.dart';
import 'package:croma_app/features/home/screens/home_screen.dart';
import 'package:croma_app/features/products/screens/product_detail_screen.dart';
import 'package:croma_app/features/cart/screens/cart_screen.dart';
import 'package:croma_app/features/products/screens/catalog_screen.dart';
import 'package:croma_app/features/auth/screens/login_screen.dart';
import 'package:croma_app/features/auth/screens/register_screen.dart';
import 'package:croma_app/features/account/screens/account_screen.dart';
import 'package:croma_app/features/products/screens/favorites_screen.dart';
import 'package:croma_app/features/products/screens/search_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/product/:slug',
      builder: (context, state) {
        final slug = state.pathParameters['slug']!;
        return ProductDetailScreen(slug: slug);
      },
    ),
    GoRoute(
      path: '/catalog/:slug',
      builder: (context, state) {
        final slug = state.pathParameters['slug'] ?? 'all';
        return CatalogScreen(categorySlug: slug);
      },
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
    GoRoute(
      path: '/catalog',
      builder: (context, state) => const CatalogScreen(categorySlug: 'all'),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/account',
      builder: (context, state) => const AccountScreen(),
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
  ],
);
