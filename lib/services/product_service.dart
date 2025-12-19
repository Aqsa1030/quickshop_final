// lib/services/product_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  final CollectionReference _productsRef =
  FirebaseFirestore.instance.collection('products');

  // Add product
  Future<void> addProduct(Product product) async {
    await _productsRef.doc(product.id).set(product.toJson());
  }

  // Update product
  Future<void> updateProduct(Product product) async {
    await _productsRef.doc(product.id).update(product.toJson());
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    await _productsRef.doc(productId).delete();
  }

  // Get all products
  Future<List<Product>> getProducts() async {
    final snapshot = await _productsRef.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Product.fromJson(data);
    }).toList();
  }

  // Get product by ID
  Future<Product?> getProductById(String productId) async {
    final doc = await _productsRef.doc(productId).get();
    if (doc.exists) {
      return Product.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}
