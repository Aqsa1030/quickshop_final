import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../models/order.dart';
import '../models/cart_item.dart';
import '../widgets/common/custom_appbar.dart';
import '../widgets/common/empty_state.dart';
import '../utils/helpers.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> _orders = [];
  bool _isLoading = true;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: 'user1') // or current user id
          .get();

      _orders = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Convert items list
        final itemsData = (data['items'] as List<dynamic>)
            .map((item) => CartItem(
          productId: item['productId'],
          productName: item['productName'],
          price: (item['price'] as num).toDouble(),
          imageUrl: item['imageUrl'],
          quantity: item['quantity'],
        ))
            .toList();

        return Order(
          id: data['id'],
          userId: data['userId'],
          items: itemsData,
          totalAmount: (data['totalAmount'] as num).toDouble(),
          shippingAddress: data['shippingAddress'],
          status: data['status'],
          orderDate: DateTime.parse(data['orderDate']),
          paymentMethod: data['paymentMethod'],
          trackingNumber: data['trackingNumber'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching orders: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    List<Order> filteredOrders = _orders;
    if (_selectedFilter != 'all') {
      filteredOrders = _orders
          .where((order) => order.status.toLowerCase() == _selectedFilter)
          .toList();
    }

    if (filteredOrders.isEmpty) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'My Orders',
          showBackButton: true,
        ),
        body: EmptyState(
          icon: Icons.receipt_long_outlined,
          title: 'No Orders Found',
          description: 'You haven\'t placed any orders yet',
          buttonText: 'Start Shopping',
          onButtonPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Orders',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Filter Chips
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _selectedFilter == 'all',
                  onSelected: (selected) {
                    setState(() => _selectedFilter = 'all');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Processing'),
                  selected: _selectedFilter == 'processing',
                  onSelected: (selected) {
                    setState(() => _selectedFilter = 'processing');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Shipped'),
                  selected: _selectedFilter == 'shipped',
                  onSelected: (selected) {
                    setState(() => _selectedFilter = 'shipped');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Delivered'),
                  selected: _selectedFilter == 'delivered',
                  onSelected: (selected) {
                    setState(() => _selectedFilter = 'delivered');
                  },
                ),
              ],
            ),
          ),
          // Orders List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.id,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Chip(
                              label: Text(
                                order.status,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              backgroundColor: _getStatusColor(order.status),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          Helpers.formatDate(order.orderDate),
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total: ${Helpers.formatPrice(order.totalAmount)}',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  // View order details
                                },
                                child: const Text('View Details'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (order.status.toLowerCase() == 'delivered')
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Reorder
                                  },
                                  child: const Text('Reorder'),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
