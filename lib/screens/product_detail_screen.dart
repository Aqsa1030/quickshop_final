import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:quickshop_final/models/product.dart';
import 'package:quickshop_final/providers/cart_provider.dart';
import 'package:quickshop_final/utils/helpers.dart';
import 'package:quickshop_final/widgets/common/primary_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isAddingToCart = false;
  Uint8List? _imageBytes;
  bool _isLoadingImage = true;
  String? _imageError;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    setState(() {
      _isLoadingImage = true;
      _imageError = null;
    });

    try {
      if (widget.product.imageBase64 == null ||
          widget.product.imageBase64!.isEmpty) {
        setState(() {
          _imageError = 'No image available';
          _isLoadingImage = false;
        });
        return;
      }

      String base64String = widget.product.imageBase64!;

      // Clean base64 string
      if (base64String.contains('data:image')) {
        base64String = base64String.split(',').last;
      }
      base64String = base64String.replaceAll(RegExp(r'\s+'), '');

      // Decode
      final bytes = await Future.microtask(() => base64Decode(base64String));

      if (mounted) {
        setState(() {
          _imageBytes = bytes;
          _isLoadingImage = false;
        });
      }
    } catch (e) {
      print('❌ Error loading product image: $e');
      if (mounted) {
        setState(() {
          _imageError = 'Failed to load image';
          _isLoadingImage = false;
        });
      }
    }
  }

  Widget _buildProductImage() {
    if (_isLoadingImage) {
      return Container(
        color: Colors.grey.shade200,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_imageError != null || _imageBytes == null) {
      return Container(
        color: Colors.grey.shade200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image,
                size: 80,
                color: Colors.grey.shade400,
              ),
              SizedBox(height: 8),
              Text(
                _imageError ?? 'No image',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Image.memory(
      _imageBytes!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      gaplessPlayback: true,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade200,
          child: Center(
            child: Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red.shade300,
            ),
          ),
        );
      },
    );
  }

  void _addToCart() async {
    setState(() => _isAddingToCart = true);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    await Future.delayed(Duration(milliseconds: 500));

    cartProvider.addToCart(
      productId: widget.product.id,
      productName: widget.product.name,
      price: widget.product.finalPrice,
      imageUrl: widget.product.imageBase64 ?? '',
      quantity: _quantity,
    );

    setState(() => _isAddingToCart = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.product.name} added to cart'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _buyNow() {
    _addToCart();
    Navigator.pushNamed(context, '/checkout');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProductImage(),
            ),
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.favorite_border, color: Colors.white),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added to favorites'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        Helpers.formatPrice(widget.product.finalPrice),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      if (widget.product.hasDiscount) ...[
                        const SizedBox(width: 12),
                        Text(
                          Helpers.formatPrice(widget.product.price),
                          style: TextStyle(
                            fontSize: 20,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${widget.product.discountPercentage.round()}% OFF',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: widget.product.rating,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20,
                        direction: Axis.horizontal,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.product.rating}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${widget.product.reviewCount} reviews)',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        widget.product.stock > 0
                            ? Icons.inventory
                            : Icons.error_outline,
                        color: widget.product.stock > 0
                            ? Colors.green
                            : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.product.stock > 0 ? 'In Stock' : 'Out of Stock',
                        style: TextStyle(
                          color: widget.product.stock > 0
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.product.stock > 0) ...[
                        const SizedBox(width: 4),
                        Text(
                          '(${widget.product.stock} items left)',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),

                  if (widget.product.stock > 0) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_quantity > 1) {
                                setState(() => _quantity--);
                              }
                            },
                            icon: Icon(Icons.remove),
                          ),
                          SizedBox(
                            width: 60,
                            child: Text(
                              _quantity.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (_quantity < widget.product.stock) {
                                setState(() => _quantity++);
                              }
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: widget.product.stock > 0
          ? Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isAddingToCart ? null : _addToCart,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: _isAddingToCart
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : Text('Add to Cart'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PrimaryButton(
                  onPressed: _isAddingToCart ? null : _buyNow,
                  text: 'Buy Now',
                  isLoading: _isAddingToCart,
                ),
              ),
            ],
          ),
        ),
      )
          : Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Out of Stock',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}