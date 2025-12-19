class CartItem {
  final String productId;
  final String productName;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  double get total => price * quantity;
}