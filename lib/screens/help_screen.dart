// lib/screens/help_screen.dart
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Contact Support Card
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.support_agent, color: const Color(0xFF7C3AED), size: 30),
                      const SizedBox(width: 10),
                      const Text(
                        'Contact Support',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildContactOption(
                    icon: Icons.email,
                    title: 'Email',
                    subtitle: 'support@quickshop.com',
                  ),
                  const SizedBox(height: 10),
                  _buildContactOption(
                    icon: Icons.phone,
                    title: 'Phone',
                    subtitle: '+92 XXX XXXXXXX',
                  ),
                  const SizedBox(height: 10),
                  _buildContactOption(
                    icon: Icons.chat,
                    title: 'Live Chat',
                    subtitle: 'Available 24/7',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // FAQ Section
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7C3AED),
            ),
          ),

          const SizedBox(height: 10),

          _buildFAQTile(
            question: 'How do I track my order?',
            answer: 'Go to "My Orders" section and click on any order to see tracking details.',
          ),

          _buildFAQTile(
            question: 'What is the return policy?',
            answer: 'You can return products within 7 days of delivery. Check our return policy for more details.',
          ),

          _buildFAQTile(
            question: 'How do I change my password?',
            answer: 'Go to Settings > Change Password to update your account password.',
          ),

          _buildFAQTile(
            question: 'How can I cancel my order?',
            answer: 'You can cancel orders before they are shipped. Go to "My Orders" and select cancel option.',
          ),

          _buildFAQTile(
            question: 'Are my payments secure?',
            answer: 'Yes, we use industry-standard encryption to protect all payment information.',
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFAQTile({required String question, required String answer}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}