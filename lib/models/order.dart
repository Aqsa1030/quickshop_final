import 'cart_item.dart';

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final String shippingAddress;
  final String status;
  final DateTime orderDate;
  final String? paymentMethod;
  final String? trackingNumber;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    this.status = 'Processing',
    required this.orderDate,
    this.paymentMethod,
    this.trackingNumber,
  });
}