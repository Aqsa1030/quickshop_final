import 'dart:io';
import 'dart:convert'; // ADDED for base64
import 'dart:typed_data'; // ADDED for Uint8List
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// REMOVED: import 'package:firebase_storage/firebase_storage.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<Product> _featuredProducts = [];
  Product? _selectedProduct;
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String _selectedCategoryId = '';
  String _sortBy = 'featured';

  // Getters
  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _products;
  List<Product> get featuredProducts => _featuredProducts;
  Product? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedCategoryId => _selectedCategoryId;
  String get sortBy => _sortBy;

  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // REMOVED: final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Convert image file to base64 string
  Future<String?> convertImageToBase64(File imageFile) async {
    try {
      print('📤 Converting image to base64...');

      final bytes = await imageFile.readAsBytes();
      final sizeInMB = bytes.length / (1024 * 1024);

      print('📊 Image size: ${sizeInMB.toStringAsFixed(2)} MB');

      if (sizeInMB > 0.9) {
        _error = 'Image too large! Please use image smaller than 900KB';
        print('❌ Image size exceeds limit: ${sizeInMB.toStringAsFixed(2)} MB');
        notifyListeners();
        return null;
      }

      final base64String = base64Encode(bytes);
      print('✅ Image converted to base64 successfully');
      return base64String;
    } catch (e) {
      print('❌ Error converting image: $e');
      _error = 'Failed to convert image: $e';
      notifyListeners();
      return null;
    }
  }

  /// Convert bytes to base64 (for web)
  String? convertBytesToBase64(Uint8List bytes) {
    try {
      print('📤 Converting bytes to base64...');

      final sizeInMB = bytes.length / (1024 * 1024);
      print('📊 Image size: ${sizeInMB.toStringAsFixed(2)} MB');

      if (sizeInMB > 0.9) {
        _error = 'Image too large! Please use image smaller than 900KB';
        print('❌ Image size exceeds limit');
        notifyListeners();
        return null;
      }

      final base64String = base64Encode(bytes);
      print('✅ Bytes converted to base64 successfully');
      return base64String;
    } catch (e) {
      print('❌ Error converting bytes: $e');
      _error = 'Failed to convert image: $e';
      notifyListeners();
      return null;
    }
  }

  // REMOVED: uploadProductImage method
  // REMOVED: deleteProductImage method

  /// Fetch all products from Firestore
  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🔄 Fetching products from Firestore...');

      final QuerySnapshot snapshot = await _firestore
          .collection('products')
          .orderBy('createdAt', descending: true)
          .get();

      print('📦 Found ${snapshot.docs.length} products in Firestore');

      _products = snapshot.docs.map((doc) {
        try {
          return Product.fromFirestore(doc);
        } catch (e) {
          print('❌ Error parsing product ${doc.id}: $e');
          rethrow;
        }
      }).toList();

      // Update featured products
      _featuredProducts = _products.where((p) => p.isFeatured).toList();
      print('⭐ Featured products: ${_featuredProducts.length}');

      // Apply current filters
      _filteredProducts = _products;
      _applyFilters();

      _error = null;
    } catch (e) {
      _error = 'Failed to load products: $e';
      print('❌ Error fetching products: $e');
      _products = [];
      _filteredProducts = [];
      _featuredProducts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch only featured products
  Future<void> fetchFeaturedProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🔄 Fetching featured products from Firestore...');

      final QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('isFeatured', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      print('⭐ Found ${snapshot.docs.length} featured products');

      _featuredProducts = snapshot.docs.map((doc) {
        return Product.fromFirestore(doc);
      }).toList();

      _error = null;
    } catch (e) {
      _error = 'Failed to load featured products: $e';
      print('❌ Error fetching featured products: $e');
      _featuredProducts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Apply filters to products list
  void _applyFilters() {
    var filtered = List<Product>.from(_products);

    if (_selectedCategoryId.isNotEmpty) {
      filtered = filtered.where((p) => p.categoryId == _selectedCategoryId).toList();
      print('🔍 Filtered by category: ${filtered.length} products');
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) =>
      p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
      print('🔍 Filtered by search "$_searchQuery": ${filtered.length} products');
    }

    switch (_sortBy) {
      case 'price_low_to_high':
        filtered.sort((a, b) => a.finalPrice.compareTo(b.finalPrice));
        break;
      case 'price_high_to_low':
        filtered.sort((a, b) => b.finalPrice.compareTo(a.finalPrice));
        break;
      case 'rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'newest':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'featured':
        filtered = filtered.where((p) => p.isFeatured).toList();
        break;
      default:
        break;
    }

    _filteredProducts = filtered;
    print('✅ Final filtered products: ${_filteredProducts.length}');
  }

  void searchProducts(String query) {
    _searchQuery = query;
    print('🔍 Searching for: "$query"');
    _applyFilters();
    notifyListeners();
  }

  void filterByCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    print('📁 Filtering by category: $categoryId');
    _applyFilters();
    notifyListeners();
  }

  void clearCategoryFilter() {
    _selectedCategoryId = '';
    print('🔄 Category filter cleared');
    _applyFilters();
    notifyListeners();
  }

  void sortProducts(String sortBy) {
    _sortBy = sortBy;
    print('🔀 Sorting by: $sortBy');
    _applyFilters();
    notifyListeners();
  }

  void selectProduct(Product product) {
    _selectedProduct = product;
    notifyListeners();
  }

  void clearSelectedProduct() {
    _selectedProduct = null;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategoryId = '';
    _sortBy = 'featured';
    _applyFilters();
    notifyListeners();
  }

  /// Add a new product with base64 image (UPDATED)
  Future<bool> addProduct(Product product, {File? imageFile, String? base64Image}) async {
    try {
      print('➕ Adding new product: ${product.name}');

      String? imageBase64 = base64Image ?? product.imageBase64;

      // Convert image file to base64 if provided
      if (imageFile != null) {
        final converted = await convertImageToBase64(imageFile);
        if (converted != null) {
          imageBase64 = converted;
        } else {
          throw Exception('Failed to convert image');
        }
      }

      // Create product with base64 image
      final productWithImage = product.copyWith(imageBase64: imageBase64);

      await _firestore
          .collection('products')
          .doc(product.id)
          .set(productWithImage.toJson());

      print('✅ Product added successfully');
      await fetchProducts();
      return true;
    } catch (e) {
      _error = 'Failed to add product: $e';
      print('❌ Error adding product: $e');
      notifyListeners();
      return false;
    }
  }

  /// Update an existing product (UPDATED)
  Future<bool> updateProduct(Product product, {File? newImageFile, String? newBase64Image}) async {
    try {
      print('🔄 Updating product: ${product.name}');

      String? imageBase64 = product.imageBase64;

      // Convert new image file to base64 if provided
      if (newImageFile != null) {
        final converted = await convertImageToBase64(newImageFile);
        if (converted != null) {
          imageBase64 = converted;
        }
      } else if (newBase64Image != null) {
        imageBase64 = newBase64Image;
      }

      final productWithImage = product.copyWith(imageBase64: imageBase64);

      await _firestore
          .collection('products')
          .doc(product.id)
          .update(productWithImage.toJson());

      print('✅ Product updated successfully');
      await fetchProducts();
      return true;
    } catch (e) {
      _error = 'Failed to update product: $e';
      print('❌ Error updating product: $e');
      notifyListeners();
      return false;
    }
  }

  /// Delete a product (SIMPLIFIED - no image deletion needed)
  Future<bool> deleteProduct(String productId) async {
    try {
      print('🗑️ Deleting product: $productId');

      // No need to delete image from storage anymore
      // Just delete product from Firestore
      await _firestore.collection('products').doc(productId).delete();

      print('✅ Product deleted successfully');
      await fetchProducts();
      return true;
    } catch (e) {
      _error = 'Failed to delete product: $e';
      print('❌ Error deleting product: $e');
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
}