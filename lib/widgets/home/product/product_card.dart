import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:quickshop_final/models/product.dart';
import 'package:quickshop_final/utils/helpers.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Uint8List? _imageBytes;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(ProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.id != widget.product.id) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (widget.product.imageBase64 == null ||
          widget.product.imageBase64!.isEmpty) {
        setState(() {
          _error = 'No image data';
          _isLoading = false;
        });
        return;
      }

      String base64String = widget.product.imageBase64!;

      // Remove data URL prefix if present
      if (base64String.contains('data:image')) {
        base64String = base64String.split(',').last;
      }

      // Remove whitespace
      base64String = base64String.replaceAll(RegExp(r'\s+'), '');

      // Decode in background
      final bytes = await Future.microtask(() => base64Decode(base64String));

      if (mounted) {
        setState(() {
          _imageBytes = bytes;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading image for ${widget.product.name}: $e');
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildImageWidget() {
    if (_isLoading) {
      return Container(
        color: Colors.grey.shade200,
        height: 120,
        width: double.infinity,
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade400),
            ),
          ),
        ),
      );
    }

    if (_error != null || _imageBytes == null) {
      return Container(
        color: Colors.grey.shade200,
        height: 120,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image,
              color: Colors.grey.shade400,
              size: 40,
            ),
            SizedBox(height: 4),
            Text(
              'No Image',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Image.memory(
      _imageBytes!,
      height: 120,
      width: double.infinity,
      fit: BoxFit.cover,
      gaplessPlayback: true,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade200,
          height: 120,
          child: Icon(
            Icons.error_outline,
            color: Colors.red.shade300,
            size: 40,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 156,
      height: 240,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: _buildImageWidget(),
                  ),
                  if (widget.product.hasDiscount)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${widget.product.discountPercentage.round()}% OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Product Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Text(
                            Helpers.formatPrice(widget.product.finalPrice),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          if (widget.product.hasDiscount) ...[
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                Helpers.formatPrice(widget.product.price),
                                style: TextStyle(
                                  fontSize: 10,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            widget.product.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '(${widget.product.reviewCount})',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}