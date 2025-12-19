import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload product image
  static Future<String> uploadProductImage(
      String imagePath,
      String productId,
      ) async {
    try {
      final ref = _storage
          .ref()
          .child('products')
          .child(productId)
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      await ref.putFile(imagePath as dynamic);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Upload user profile image
  static Future<String> uploadProfileImage(
      String imagePath,
      String userId,
      ) async {
    try {
      final ref = _storage
          .ref()
          .child('profiles')
          .child(userId)
          .child('profile.jpg');

      await ref.putFile(imagePath as dynamic);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  // Delete image
  static Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  // Get product image URL
  static Future<String> getProductImageUrl(String productId) async {
    try {
      final ref = _storage.ref().child('products').child(productId);
      final list = await ref.listAll();

      if (list.items.isNotEmpty) {
        return await list.items.first.getDownloadURL();
      }
      return '';
    } catch (e) {
      throw Exception('Failed to get image URL: $e');
    }
  }

  // Get user profile image URL
  static Future<String> getUserProfileImageUrl(String userId) async {
    try {
      final ref = _storage
          .ref()
          .child('profiles')
          .child(userId)
          .child('profile.jpg');

      return await ref.getDownloadURL();
    } catch (e) {
      return '';
    }
  }
}