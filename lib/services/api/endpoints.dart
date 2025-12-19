class Endpoints {
  // Authentication
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // Users
  static const String users = '/users';
  static const String userProfile = '/users/profile';
  static const String updatePassword = '/users/update-password';

  // Products
  static const String products = '/products';
  static const String featuredProducts = '/products/featured';
  static const String onSaleProducts = '/products/on-sale';
  static const String newArrivals = '/products/new-arrivals';
  static const String trendingProducts = '/products/trending';
  static const String bestSellers = '/products/best-sellers';

  // Categories
  static const String categories = '/categories';
  static const String featuredCategories = '/categories/featured';

  // Cart
  static const String cart = '/cart';

  // Orders
  static const String orders = '/orders';
  static const String orderHistory = '/orders/history';
  static const String trackOrder = '/orders/track';

  // Favorites/Wishlist
  static const String favorites = '/favorites';
  static const String wishlist = '/wishlist';

  // Reviews & Ratings
  static const String reviews = '/reviews';
  static const String productReviews = '/products/:id/reviews';
  static const String userReviews = '/users/:id/reviews';

  // Search
  static const String search = '/search';
  static const String searchSuggestions = '/search/suggestions';

  // Payment
  static const String payment = '/payment';
  static const String paymentMethods = '/payment/methods';
  static const String paymentHistory = '/payment/history';

  // Shipping
  static const String shipping = '/shipping';
  static const String shippingRates = '/shipping/rates';
  static const String shippingAddresses = '/shipping/addresses';

  // Notifications
  static const String notifications = '/notifications';
  static const String notificationSettings = '/notifications/settings';

  // Analytics & Statistics
  static const String stats = '/stats';
  static const String analytics = '/analytics';
  static const String dashboard = '/dashboard';

  // Settings
  static const String settings = '/settings';
  static const String appSettings = '/settings/app';
  static const String userSettings = '/settings/user';

  // Content Management
  static const String banners = '/banners';
  static const String featuredBanners = '/banners/featured';
  static const String promotions = '/promotions';
  static const String coupons = '/coupons';
  static const String validateCoupon = '/coupons/validate';

  // Feedback & Support
  static const String feedback = '/feedback';
  static const String contact = '/contact';
  static const String support = '/support';
  static const String faq = '/faq';
  static const String help = '/help';

  // Upload
  static const String upload = '/upload';
  static const String uploadImage = '/upload/image';
  static const String uploadFile = '/upload/file';

  // Version & Updates
  static const String version = '/version';
  static const String checkUpdate = '/version/check';
  static const String changelog = '/version/changelog';

  // Social & Sharing
  static const String social = '/social';
  static const String share = '/share';
  static const String referral = '/referral';

  // Location Services
  static const String location = '/location';
  static const String nearbyStores = '/location/stores';
  static const String deliveryAreas = '/location/delivery-areas';

  // Helper methods
  static String productDetail(String productId) => '/products/$productId';
  static String categoryProducts(String categoryId) => '/categories/$categoryId/products';
  static String userOrders(String userId) => '/users/$userId/orders';
  static String orderDetail(String orderId) => '/orders/$orderId';
  static String userAddresses(String userId) => '/users/$userId/addresses';
  static String addressDetail(String addressId) => '/addresses/$addressId';
  static String reviewDetail(String reviewId) => '/reviews/$reviewId';

  // Admin endpoints (if needed)
  static const String admin = '/admin';
  static const String adminUsers = '/admin/users';
  static const String adminProducts = '/admin/products';
  static const String adminOrders = '/admin/orders';
  static const String adminCategories = '/admin/categories';
  static const String adminStats = '/admin/stats';
  static const String adminDashboard = '/admin/dashboard';

  // Webhook endpoints
  static const String webhook = '/webhook';
  static const String paymentWebhook = '/webhook/payment';
  static const String shippingWebhook = '/webhook/shipping';
  static const String notificationWebhook = '/webhook/notification';

  // Utility endpoints
  static const String health = '/health';
  static const String ping = '/ping';
  static const String status = '/status';
  static const String time = '/time';
  static const String config = '/config';
}