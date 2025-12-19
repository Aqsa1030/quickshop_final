import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickshop_final/navigation/app_router.dart';
import 'package:quickshop_final/providers/auth_provider.dart';
import 'package:quickshop_final/widgets/common/custom_appbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Profile',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.name ?? 'Guest User',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user?.email ?? 'guest@example.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              '12',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              'Orders',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '3',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              'Wishlist',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '2',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              'Reviews',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Menu Items
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.shopping_bag_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: const Text('My Orders'),
                    subtitle: const Text('View your order history'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.orders);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      Icons.favorite_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: const Text('Wishlist'),
                    subtitle: const Text('Your saved items'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to wishlist
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      Icons.location_on_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: const Text('Addresses'),
                    subtitle: const Text('Manage shipping addresses'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to addresses
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      Icons.payment_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: const Text('Payment Methods'),
                    subtitle: const Text('Manage your payment options'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to payment methods
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      Icons.notifications_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: const Text('Notifications'),
                    subtitle: const Text('Manage your notifications'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to notifications
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      Icons.help_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: const Text('Help & Support'),
                    subtitle: const Text('FAQs and contact support'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to help
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Account Actions
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await authProvider.logout();
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRouter.login,
                                      (route) => false,
                                );
                              },
                              child: const Text(
                                'Logout',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // App Info
            Text(
              'QuickShop v1.0.0',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '© 2024 QuickShop. All rights reserved.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}