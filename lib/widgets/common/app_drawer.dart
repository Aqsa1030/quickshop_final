import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickshop_final/navigation/app_router.dart';
import 'package:quickshop_final/providers/auth_provider.dart';
import 'package:quickshop_final/providers/cart_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final user = authProvider.user;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          UserAccountsDrawerHeader(
            accountName: Text(
              user?.name ?? 'Guest User',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              user?.email ?? 'guest@example.com',
              style: const TextStyle(fontSize: 14),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  const Color(0xFFEC4899),
                ],
              ),
            ),
          ),

          // Home
          ListTile(
            leading: const Icon(Icons.home, color: Color(0xFF7C3AED)),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRouter.home);
            },
          ),

          // Profile
          ListTile(
            leading: const Icon(Icons.person, color: Color(0xFF7C3AED)),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.profile);
            },
          ),

          // Orders
          ListTile(
            leading: const Icon(Icons.shopping_bag, color: Color(0xFF7C3AED)),
            title: const Text('My Orders'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '12',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.orders);
            },
          ),

          // Wishlist
          ListTile(
            leading: const Icon(Icons.favorite, color: Color(0xFF7C3AED)),
            title: const Text('Wishlist'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '3',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.wishlist); // ✅ FIXED
            },
          ),

          // Cart
          ListTile(
            leading: const Icon(Icons.shopping_cart, color: Color(0xFF7C3AED)),
            title: const Text('Cart'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                cartProvider.itemCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.cart);
            },
          ),

          const Divider(),

          // Settings
          ListTile(
            leading: const Icon(Icons.settings, color: Color(0xFF7C3AED)),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.settings); // ✅ FIXED
            },
          ),

          // Help & Support
          ListTile(
            leading: const Icon(Icons.help, color: Color(0xFF7C3AED)),
            title: const Text('Help & Support'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.help); // ✅ FIXED
            },
          ),

          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isLoading = false;

            return AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                if (!isLoading)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                    setState(() => isLoading = true);
                    try {
                      await authProvider.logout();
                      Navigator.pop(context); // Close dialog
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRouter.login,
                            (route) => false,
                      );
                    } catch (e) {
                      Navigator.pop(context); // Close dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Logout failed: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.red,
                    ),
                  )
                      : const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}