import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickshop_final/navigation/app_router.dart';
import 'package:quickshop_final/providers/cart_provider.dart';
import 'package:quickshop_final/utils/helpers.dart';
import 'package:quickshop_final/widgets/cart/cart_item_tile.dart';
import 'package:quickshop_final/widgets/common/custom_appbar.dart';
import 'package:quickshop_final/widgets/common/empty_state.dart';
import 'package:quickshop_final/widgets/common/primary_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    if (cartProvider.items.isEmpty) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Shopping Cart',
          showBackButton: true,
        ),
        body: EmptyState(
          icon: Icons.shopping_cart_outlined,
          title: 'Your cart is empty',
          description: 'Add items to your cart to see them here',
          buttonText: 'Start Shopping',
          onButtonPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Shopping Cart',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear Cart'),
                  content: const Text('Are you sure you want to clear your cart?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        cartProvider.clearCart();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Cart Items List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final item = cartProvider.items[index];
                return CartItemTile(
                  item: item,
                  onRemove: () {
                    cartProvider.removeFromCart(item.productId);
                  },
                  onQuantityChanged: (quantity) {
                    cartProvider.updateQuantity(item.productId, quantity);
                  },
                );
              },
            ),
          ),

          // Checkout Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      Helpers.formatPrice(cartProvider.totalAmount),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Shipping',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '\$5.99',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      Helpers.formatPrice(cartProvider.totalAmount + 5.99),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.checkout);
                  },
                  text: 'Proceed to Checkout',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}