import 'package:flutter/material.dart';

class Helpers {
  // Price formatter - Changed from $ to Rs.
  static String formatPrice(double price) {
    return 'Rs. ${price.toStringAsFixed(0)}';
  }

  // Date formatter
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Rating stars
  static Widget buildRatingStars(double rating, {double size = 20}) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: size,
        );
      }),
    );
  }

  // Show snackbar
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Calculate discount percentage
  static double calculateDiscount(double original, double discount) {
    return ((original - discount) / original * 100).roundToDouble();
  }

  // Validate email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate phone
  static bool isValidPhone(String phone) {
    return RegExp(r'^[+]?[\d\s\-\(\)]{10,}$').hasMatch(phone);
  }
}