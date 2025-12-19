import 'package:flutter/material.dart';
import 'package:quickshop_final/models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.total);

  void addToCart({
    required String productId,
    required String productName,
    required double price,
    required String imageUrl,
    int quantity = 1,
  }) {
    final existingIndex = _items.indexWhere((item) => item.productId == productId);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        productId: productId,
        productName: productName,
        price: price,
        imageUrl: imageUrl,
        quantity: quantity,
      ));
    }

    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(String productId) {
    return _items.any((item) => item.productId == productId);
  }

  int getProductQuantity(String productId) {
    final item = _items.firstWhere(
          (item) => item.productId == productId,
      orElse: () => CartItem(
        productId: '',
        productName: '',
        price: 0,
        imageUrl: '',
        quantity: 0,
      ),
    );
    return item.quantity;
  }
}