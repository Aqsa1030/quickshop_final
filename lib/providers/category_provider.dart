import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  Category? _selectedCategory;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Category> get categories => _categories;
  Category? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Firebase instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch all categories from Firestore
  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🔄 Fetching categories from Firestore...');

      final QuerySnapshot snapshot = await _firestore
          .collection('categories')
          .orderBy('name')
          .get();

      print('📦 Found ${snapshot.docs.length} categories');

      _categories = snapshot.docs.map((doc) {
        try {
          return Category.fromFirestore(doc);
        } catch (e) {
          print('❌ Error parsing category ${doc.id}: $e');
          rethrow;
        }
      }).toList();

      print('✅ Categories loaded successfully: ${_categories.length}');
      _error = null;
    } catch (e) {
      _error = 'Failed to load categories: $e';
      print('❌ Error fetching categories: $e');
      _categories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Select a category
  void selectCategory(Category? category) {
    _selectedCategory = category;
    print('📁 Category selected: ${category?.name ?? "None"}');
    notifyListeners();
  }

  /// Clear selected category
  void clearSelectedCategory() {
    _selectedCategory = null;
    print('🔄 Category selection cleared');
    notifyListeners();
  }

  /// Get category by ID
  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (_) {
      print('⚠️ Category not found: $id');
      return null;
    }
  }

  /// Add a new category
  Future<bool> addCategory(Category category) async {
    try {
      print('➕ Adding category: ${category.name}');

      await _firestore
          .collection('categories')
          .doc(category.id)
          .set(category.toJson());

      print('✅ Category added successfully');
      await fetchCategories();
      return true;
    } catch (e) {
      _error = 'Failed to add category: $e';
      print('❌ Error adding category: $e');
      notifyListeners();
      return false;
    }
  }

  /// Update an existing category
  Future<bool> updateCategory(Category category) async {
    try {
      print('🔄 Updating category: ${category.name}');

      await _firestore
          .collection('categories')
          .doc(category.id)
          .update(category.toJson());

      print('✅ Category updated successfully');
      await fetchCategories();
      return true;
    } catch (e) {
      _error = 'Failed to update category: $e';
      print('❌ Error updating category: $e');
      notifyListeners();
      return false;
    }
  }

  /// Delete a category
  Future<bool> deleteCategory(String categoryId) async {
    try {
      print('🗑️ Deleting category: $categoryId');

      await _firestore.collection('categories').doc(categoryId).delete();

      print('✅ Category deleted successfully');
      await fetchCategories();
      return true;
    } catch (e) {
      _error = 'Failed to delete category: $e';
      print('❌ Error deleting category: $e');
      notifyListeners();
      return false;
    }
  }

  /// Update product count for a category
  Future<void> updateProductCount(String categoryId, int count) async {
    try {
      await _firestore
          .collection('categories')
          .doc(categoryId)
          .update({'productCount': count});

      // Update local list
      final index = _categories.indexWhere((category) => category.id == categoryId);
      if (index != -1) {
        _categories[index] = _categories[index].copyWith(productCount: count);
        notifyListeners();
      }
    } catch (e) {
      print('❌ Error updating product count: $e');
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}