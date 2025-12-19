import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickshop_final/models/user.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Users Collection
  static final CollectionReference usersCollection =
  _firestore.collection('users');

  // Products Collection
  static final CollectionReference productsCollection =
  _firestore.collection('products');

  // Categories Collection
  static final CollectionReference categoriesCollection =
  _firestore.collection('categories');

  // Orders Collection
  static final CollectionReference ordersCollection =
  _firestore.collection('orders');

  // Cart Collection
  static final CollectionReference cartCollection =
  _firestore.collection('cart');

  // Save user to Firestore
  static Future<void> saveUserToFirestore(AppUser user) async {
    try {
      await usersCollection.doc(user.id).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  // Get user from Firestore
  static Future<AppUser?> getUserFromFirestore(String userId) async {
    try {
      final doc = await usersCollection.doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return AppUser(
          id: data['id'],
          name: data['name'],
          email: data['email'],
          phone: data['phone'],
          address: data['address'],
          profileImage: data['profileImage'],
          joinedAt: DateTime.parse(data['joinedAt']),
          wishlist: List<String>.from(data['wishlist'] ?? []),
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Get current user from Firestore
  static Future<AppUser?> getCurrentUserFromFirestore() async {
    final user = _auth.currentUser;
    if (user != null) {
      return getUserFromFirestore(user.uid);
    }
    return null;
  }

  // Get all products
  static Stream<QuerySnapshot> getProductsStream() {
    return productsCollection.snapshots();
  }

  // Get featured products
  static Stream<QuerySnapshot> getFeaturedProductsStream() {
    return productsCollection
        .where('isFeatured', isEqualTo: true)
        .limit(10)
        .snapshots();
  }

  // Get products by category
  static Stream<QuerySnapshot> getProductsByCategoryStream(String categoryId) {
    return productsCollection
        .where('categoryId', isEqualTo: categoryId)
        .snapshots();
  }

  // Get all categories
  static Stream<QuerySnapshot> getCategoriesStream() {
    return categoriesCollection.snapshots();
  }

  // Search products
  static Stream<QuerySnapshot> searchProductsStream(String query) {
    return productsCollection
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .snapshots();
  }

  // Add order to Firestore
  static Future<void> addOrder(Map<String, dynamic> orderData) async {
    try {
      await ordersCollection.add(orderData);
    } catch (e) {
      throw Exception('Failed to add order: $e');
    }
  }

  // Get user orders
  static Stream<QuerySnapshot> getUserOrdersStream(String userId) {
    return ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('orderDate', descending: true)
        .snapshots();
  }

  // Update user profile
  static Future<void> updateUserProfile(
      String userId, Map<String, dynamic> updates) async {
    try {
      await usersCollection.doc(userId).update(updates);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Add to user's cart
  static Future<void> addToUserCart(
      String userId, Map<String, dynamic> cartItem) async {
    try {
      await cartCollection
          .doc(userId)
          .collection('items')
          .add(cartItem);
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  // Get user's cart
  static Stream<QuerySnapshot> getUserCartStream(String userId) {
    return cartCollection
        .doc(userId)
        .collection('items')
        .snapshots();
  }

  // Remove from user's cart
  static Future<void> removeFromUserCart(String userId, String itemId) async {
    try {
      await cartCollection
          .doc(userId)
          .collection('items')
          .doc(itemId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
    }
  }

  // Clear user's cart
  static Future<void> clearUserCart(String userId) async {
    try {
      final items = await cartCollection
          .doc(userId)
          .collection('items')
          .get();

      for (final doc in items.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }
}