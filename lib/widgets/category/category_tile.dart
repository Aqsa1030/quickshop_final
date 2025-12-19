import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:quickshop_final/models/category.dart';

class CategoryTile extends StatefulWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  Uint8List? _imageBytes;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(CategoryTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category.id != widget.category.id) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (widget.category.imageBase64 == null ||
          widget.category.imageBase64!.isEmpty) {
        setState(() {
          _error = 'No image';
          _isLoading = false;
        });
        return;
      }

      String base64String = widget.category.imageBase64!;

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
      print('❌ Error loading category image for ${widget.category.name}: $e');
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildCategoryImage() {
    if (_isLoading) {
      return Container(
        color: Colors.grey.shade200,
        child: Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.grey.shade400,
              ),
            ),
          ),
        ),
      );
    }

    if (_error != null || _imageBytes == null) {
      return Container(
        color: Colors.grey.shade200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.category.icon.isNotEmpty
                    ? widget.category.icon
                    : '📁',
                style: const TextStyle(fontSize: 48),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'No image',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
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
            child: Text(
              widget.category.icon.isNotEmpty
                  ? widget.category.icon
                  : '❌',
              style: const TextStyle(fontSize: 48),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Category Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: _buildCategoryImage(),
              ),
            ),

            // Category Info
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Category name with icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.category.icon.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Text(
                            widget.category.icon,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      Flexible(
                        child: Text(
                          widget.category.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.category.productCount} product${widget.category.productCount != 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}