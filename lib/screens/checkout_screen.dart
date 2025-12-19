import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickshop_final/models/order.dart';
import 'package:quickshop_final/providers/cart_provider.dart';
import 'package:quickshop_final/utils/helpers.dart';
import 'package:quickshop_final/widgets/cart/checkout_summary.dart';
import 'package:quickshop_final/widgets/common/custom_appbar.dart';
import 'package:quickshop_final/widgets/common/primary_button.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();

  // Payment method controllers
  final _jazzCashNumberController = TextEditingController();
  final _easyPaisaNumberController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  String _paymentMethod = 'jazzcash';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill with dummy data for testing
    _nameController.text = 'Ahmed Ali';
    _emailController.text = 'ahmed@example.com';
    _phoneController.text = '+92 300 1234567';
    _addressController.text = 'House 123, Street 45, F-7';
    _cityController.text = 'Islamabad';
    _zipController.text = '44000';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _jazzCashNumberController.dispose();
    _easyPaisaNumberController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate payment method specific fields
    if (_paymentMethod == 'jazzcash' && _jazzCashNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter JazzCash number')),
      );
      return;
    }

    if (_paymentMethod == 'easypaisa' && _easyPaisaNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter EasyPaisa number')),
      );
      return;
    }

    if (_paymentMethod == 'credit_card') {
      if (_cardNumberController.text.isEmpty ||
          _cardHolderController.text.isEmpty ||
          _expiryDateController.text.isEmpty ||
          _cvvController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all card details')),
        );
        return;
      }
    }

    setState(() => _isProcessing = true);

    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Create order
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'user1',
      items: cartProvider.items,
      totalAmount: cartProvider.totalAmount + 150, // Rs. 150 shipping
      shippingAddress: '${_addressController.text}, ${_cityController.text}, ${_zipController.text}',
      status: 'Processing',
      orderDate: DateTime.now(),
      paymentMethod: _getPaymentMethodName(),
    );

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isProcessing = false);

    // Show success dialog
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle, color: Colors.green.shade700, size: 32),
              ),
              const SizedBox(width: 12),
              const Text('Order Placed!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your order has been placed successfully.'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Order ID:', style: TextStyle(fontWeight: FontWeight.w500)),
                        Text(order.id, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.w500)),
                        Text(
                          'Rs. ${order.totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF7C3AED),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Payment:', style: TextStyle(fontWeight: FontWeight.w500)),
                        Text(_getPaymentMethodName()),
                      ],
                    ),
                    const Divider(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery:', style: TextStyle(fontWeight: FontWeight.w500)),
                        Text('3-5 business days'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                cartProvider.clearCart();
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to home
              },
              child: const Text(
                'Continue Shopping',
                style: TextStyle(color: Color(0xFF7C3AED)),
              ),
            ),
          ],
        ),
      );
    }
  }

  String _getPaymentMethodName() {
    switch (_paymentMethod) {
      case 'jazzcash':
        return 'JazzCash';
      case 'easypaisa':
        return 'EasyPaisa';
      case 'credit_card':
        return 'Credit/Debit Card';
      default:
        return 'Unknown';
    }
  }

  Widget _buildPaymentMethodDetails() {
    switch (_paymentMethod) {
      case 'jazzcash':
        return Column(
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'JS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'JazzCash Payment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _jazzCashNumberController,
                    decoration: InputDecoration(
                      labelText: 'JazzCash Mobile Number',
                      hintText: '03XX XXXXXXX',
                      prefixIcon: const Icon(Icons.phone_android),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'You will receive a payment request on your JazzCash account.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        );

      case 'easypaisa':
        return Column(
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'EP',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'EasyPaisa Payment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _easyPaisaNumberController,
                    decoration: InputDecoration(
                      labelText: 'EasyPaisa Mobile Number',
                      hintText: '03XX XXXXXXX',
                      prefixIcon: const Icon(Icons.phone_android),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'You will receive a payment request on your EasyPaisa account.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        );

      case 'credit_card':
        return Column(
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.credit_card, color: Colors.blue.shade700, size: 28),
                      const SizedBox(width: 12),
                      const Text(
                        'Card Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cardNumberController,
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                      hintText: '1234 5678 9012 3456',
                      prefixIcon: const Icon(Icons.credit_card),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cardHolderController,
                    decoration: InputDecoration(
                      labelText: 'Card Holder Name',
                      hintText: 'AHMED ALI',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _expiryDateController,
                          decoration: InputDecoration(
                            labelText: 'Expiry Date',
                            hintText: 'MM/YY',
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: TextInputType.datetime,
                          maxLength: 5,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _cvvController,
                          decoration: InputDecoration(
                            labelText: 'CVV',
                            hintText: '123',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '🔒 Your card information is secure and encrypted.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Checkout',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shipping Information
              const Text(
                'Shipping Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        prefixIcon: const Icon(Icons.home),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            decoration: InputDecoration(
                              labelText: 'City',
                              prefixIcon: const Icon(Icons.location_city),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter city';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _zipController,
                            decoration: InputDecoration(
                              labelText: 'ZIP Code',
                              prefixIcon: const Icon(Icons.pin_drop),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter ZIP';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Payment Method
              const SizedBox(height: 32),
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // JazzCash Option
              InkWell(
                onTap: () => setState(() => _paymentMethod = 'jazzcash'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _paymentMethod == 'jazzcash'
                          ? const Color(0xFF7C3AED)
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'jazzcash',
                        groupValue: _paymentMethod,
                        onChanged: (value) => setState(() => _paymentMethod = value!),
                        activeColor: const Color(0xFF7C3AED),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'JS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'JazzCash',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Mobile wallet payment',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // EasyPaisa Option
              InkWell(
                onTap: () => setState(() => _paymentMethod = 'easypaisa'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _paymentMethod == 'easypaisa'
                          ? const Color(0xFF7C3AED)
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'easypaisa',
                        groupValue: _paymentMethod,
                        onChanged: (value) => setState(() => _paymentMethod = value!),
                        activeColor: const Color(0xFF7C3AED),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'EP',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EasyPaisa',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Mobile wallet payment',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Credit Card Option
              InkWell(
                onTap: () => setState(() => _paymentMethod = 'credit_card'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _paymentMethod == 'credit_card'
                          ? const Color(0xFF7C3AED)
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'credit_card',
                        groupValue: _paymentMethod,
                        onChanged: (value) => setState(() => _paymentMethod = value!),
                        activeColor: const Color(0xFF7C3AED),
                      ),
                      const Icon(Icons.credit_card, color: Colors.blue, size: 32),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Credit/Debit Card',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Visa, Mastercard, etc.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Payment Method Details
              _buildPaymentMethodDetails(),

              // Order Summary
              const SizedBox(height: 24),
              CheckoutSummary(
                subtotal: cartProvider.totalAmount,
                shipping: 150,
                total: cartProvider.totalAmount + 150,
              ),

              // Place Order Button
              const SizedBox(height: 24),
              PrimaryButton(
                onPressed: _isProcessing ? null : _placeOrder,
                text: _isProcessing ? 'Processing...' : 'Place Order',
                isLoading: _isProcessing,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}