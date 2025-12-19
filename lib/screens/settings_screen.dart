// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:quickshop_final/navigation/app_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;
  bool darkMode = false;
  bool emailUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),

          // Account Section
          _buildSectionTitle('Account'),
          _buildListTile(
            icon: Icons.person,
            title: 'Edit Profile',
            onTap: () {
              Navigator.pushNamed(context, AppRouter.profile);
            },
          ),
          _buildListTile(
            icon: Icons.lock,
            title: 'Change Password',
            onTap: () {
              _showChangePasswordDialog();
            },
          ),

          const Divider(),

          // Notifications Section
          _buildSectionTitle('Notifications'),
          _buildSwitchTile(
            icon: Icons.notifications,
            title: 'Push Notifications',
            value: notifications,
            onChanged: (value) {
              setState(() => notifications = value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value
                      ? 'Notifications enabled'
                      : 'Notifications disabled'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          _buildSwitchTile(
            icon: Icons.email,
            title: 'Email Updates',
            value: emailUpdates,
            onChanged: (value) {
              setState(() => emailUpdates = value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value
                      ? 'Email updates enabled'
                      : 'Email updates disabled'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),

          const Divider(),

          // Appearance Section
          _buildSectionTitle('Appearance'),
          _buildSwitchTile(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            value: darkMode,
            onChanged: (value) {
              setState(() => darkMode = value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value
                      ? 'Dark mode enabled (Coming soon)'
                      : 'Light mode enabled'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),

          const Divider(),

          // Other Section
          _buildSectionTitle('Other'),
          _buildListTile(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            onTap: () {
              _showInfoDialog(
                'Privacy Policy',
                'Your privacy is important to us. We collect and use your data responsibly.',
              );
            },
          ),
          _buildListTile(
            icon: Icons.description,
            title: 'Terms & Conditions',
            onTap: () {
              _showInfoDialog(
                'Terms & Conditions',
                'By using QuickShop, you agree to our terms and conditions.',
              );
            },
          ),
          _buildListTile(
            icon: Icons.info,
            title: 'About',
            onTap: () {
              _showAboutDialog();
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF7C3AED),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF7C3AED)),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF7C3AED)),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF7C3AED),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About QuickShop'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version: 1.0.0',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('QuickShop - Your one-stop shopping solution'),
            SizedBox(height: 10),
            Text(
              '© 2024 QuickShop. All rights reserved.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password changed successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
            ),
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }
}