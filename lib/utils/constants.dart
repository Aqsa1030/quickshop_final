class AppConstants {
  // App Info
  static const String appName = 'QuickShop';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String categoriesCollection = 'categories';
  static const String ordersCollection = 'orders';
  static const String cartCollection = 'cart';

  // Shared Preferences Keys
  static const String isFirstLaunch = 'isFirstLaunch';
  static const String isLoggedIn = 'isLoggedIn';
  static const String userEmail = 'userEmail';
  static const String userName = 'userName';
  static const String themeMode = 'themeMode';

  // Animation Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration pageTransitionDuration = Duration(milliseconds: 500);

  // Assets Paths
  static const String logoPath = 'assets/logo.png';
  static const String placeholderImage = 'assets/placeholder.jpg';

  // API Constants
  static const int itemsPerPage = 20;
  static const int maxSearchResults = 50;

  // Validation Messages
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Please enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordMinLength = 'Password must be at least 6 characters';
  static const String nameRequired = 'Name is required';
  static const String phoneInvalid = 'Please enter a valid phone number';
  static const String addressRequired = 'Address is required';
}