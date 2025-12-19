// lib/navigation/app_router.dart
import 'package:flutter/material.dart';
import 'package:quickshop_final/screens/auth/login_screen.dart';
import 'package:quickshop_final/screens/auth/signup_screen.dart';
import 'package:quickshop_final/screens/cart_screen.dart';
import 'package:quickshop_final/screens/categories_screen.dart';
import 'package:quickshop_final/screens/checkout_screen.dart';
import 'package:quickshop_final/screens/home_screen.dart';
import 'package:quickshop_final/screens/onboarding_screen.dart';
import 'package:quickshop_final/screens/orders_screen.dart';
import 'package:quickshop_final/screens/product_detail_screen.dart';
import 'package:quickshop_final/screens/profile_screen.dart';
import 'package:quickshop_final/screens/splash_screen.dart';
import 'package:quickshop_final/screens/add_product_screen.dart';
import 'package:quickshop_final/screens/wishlist_screen.dart';
import 'package:quickshop_final/screens/settings_screen.dart';
import 'package:quickshop_final/screens/help_screen.dart';
import 'package:quickshop_final/models/product.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String profile = '/profile';
  static const String orders = '/orders';
  static const String addProduct = '/add-product';
  static const String wishlist = '/wishlist';
  static const String settings = '/settings';
  static const String help = '/help';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen(), settings: settings);

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen(), settings: settings);

      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen(), settings: settings);

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen(), settings: settings);

      case categories:
        return MaterialPageRoute(builder: (_) => CategoriesScreen(), settings: settings);

      case addProduct:
        return MaterialPageRoute(builder: (_) => const AddProductScreen(), settings: settings);

      case wishlist:
        return MaterialPageRoute(builder: (_) => const WishlistScreen(), settings: settings);

      case AppRouter.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen(), settings: settings);

      case help:
        return MaterialPageRoute(builder: (_) => const HelpScreen(), settings: settings);

      case productDetail:
        final args = settings.arguments;
        if (args is Product) {
          return MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: args),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Product not found', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(_, home),
                    child: const Text('Go to Home'),
                  ),
                ],
              ),
            ),
          ),
        );

      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen(), settings: settings);

      case checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen(), settings: settings);

      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen(), settings: settings);

      case orders:
        return MaterialPageRoute(builder: (_) => const OrdersScreen(), settings: settings);

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text("Route not found: ${settings.name}"),
            ),
          ),
        );
    }
  }

  static Future<T?> navigateTo<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  static Future<T?> replaceWith<T, TO>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushReplacementNamed<T, TO>(context, routeName, arguments: arguments);
  }

  static Future<T?> navigateAndRemoveUntil<T>(
      BuildContext context, String routeName,
      {Object? arguments, bool Function(Route<dynamic>)? predicate}) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  static bool hasOnboardingScreen() => true;

  static String getInitialRoute({required bool isFirstLaunch, required bool isLoggedIn}) {
    if (isFirstLaunch && hasOnboardingScreen()) {
      return onboarding;
    } else if (isLoggedIn) {
      return home;
    } else {
      return login;
    }
  }
}