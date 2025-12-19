import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickshop_final/navigation/app_router.dart';
import 'package:quickshop_final/providers/auth_provider.dart';
import 'package:quickshop_final/providers/cart_provider.dart';
import 'package:quickshop_final/providers/product_provider.dart';
import 'package:quickshop_final/providers/theme_provider.dart';

class QuickShopApp extends StatelessWidget {
  const QuickShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // Initialize auth status
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            authProvider.checkAuthStatus();
          });

          return MaterialApp(
            title: 'QuickShop',
            theme: ThemeData(
              primaryColor: const Color(0xFF7C3AED),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF7C3AED),
                primary: const Color(0xFF7C3AED),
                secondary: const Color(0xFFEC4899),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              useMaterial3: true,
            ),
            initialRoute: AppRouter.splash,
            onGenerateRoute: AppRouter.generateRoute,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}