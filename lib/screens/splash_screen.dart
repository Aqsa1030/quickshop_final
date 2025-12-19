import 'package:flutter/material.dart';
import 'package:quickshop_final/navigation/app_router.dart';
import 'package:quickshop_final/services/shared_pref_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();

    // Start navigation check with a slight delay
    Future.delayed(const Duration(seconds: 1), () {
      _checkInitialRoute();
    });
  }

  Future<void> _checkInitialRoute() async {
    try {
      // Check if it's first launch
      final isFirstLaunch = await SharedPrefService.isFirstLaunch();

      // Check if user is logged in
      final isLoggedIn = await SharedPrefService.isLoggedIn();

      // Navigate based on status
      String route;
      if (isFirstLaunch) {
        route = AppRouter.onboarding;
      } else if (isLoggedIn) {
        route = AppRouter.home;
      } else {
        route = AppRouter.login;
      }

      // Navigate if we haven't already
      if (!_hasNavigated && mounted) {
        _hasNavigated = true;
        await Future.delayed(const Duration(milliseconds: 500)); // Small delay for smooth transition

        if (mounted) {
          Navigator.pushReplacementNamed(context, route);
        }
      }
    } catch (e) {
      // If any error, go to login screen
      if (!_hasNavigated && mounted) {
        _hasNavigated = true;
        Navigator.pushReplacementNamed(context, AppRouter.login);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF7C3AED),
              Color(0xFFEC4899),
            ],
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_bag,
                    size: 60,
                    color: Color(0xFF7C3AED),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'QuickShop',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Shop Smart, Shop Fast',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}