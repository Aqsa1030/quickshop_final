import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import 'package:uuid/uuid.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = '/add-product';

  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryIdController = TextEditingController();
  final _stockController = TextEditingController();
  // REMOVED: _discountPriceController

  bool _isLoading = false;
  bool _isFeatured = true;
  double _uploadProgress = 0.0;
  String _uploadStatus = '';

  // For mobile/desktop
  File? _selectedImageFile;
  // For web
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  String? _base64Image;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryIdController.dispose();
    _stockController.dispose();
    // REMOVED: _discountPriceController.dispose();
    super.dispose();
  }

  /// Pick image - works on Web, Android, Windows
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();

        // Check file size
        final sizeInMB = bytes.length / (1024 * 1024);
        print('📊 Image size: ${sizeInMB.toStringAsFixed(2)} MB');

        if (sizeInMB > 0.9) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image too large! Please select smaller image (max 900KB)'),
                backgroundColor: Colors.orange,
              ),
            );
          }
          return;
        }

        // Convert to base64
        final base64String = base64Encode(bytes);

        if (kIsWeb) {
          setState(() {
            _selectedImageBytes = bytes;
            _selectedImageName = pickedFile.name;
            _selectedImageFile = null;
            _base64Image = base64String;
          });
          print('✅ Image selected for Web: ${pickedFile.name}');
        } else {
          setState(() {
            _selectedImageFile = File(pickedFile.path);
            _selectedImageBytes = bytes;
            _selectedImageName = null;
            _base64Image = base64String;
          });
          print('✅ Image selected for Mobile: ${pickedFile.path}');
        }

        print('✅ Image converted to base64');
      }
    } catch (e) {
      print('❌ Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting image: $e')),
        );
      }
    }
  }

  /// Show dialog to choose image source
  void _showImageSourceDialog() {
    if (kIsWeb) {
      _pickImage(ImageSource.gallery);
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Image Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF7C3AED)),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF7C3AED)),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    // Check authentication
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in first')),
      );
      return;
    }

    // Check base64 image
    if (_base64Image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a product image')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _uploadStatus = 'Saving product...';
      _uploadProgress = 0.0;
    });

    try {
      final productId = const Uuid().v4();
      print('🆔 Generated product ID: $productId');

      setState(() {
        _uploadStatus = 'Preparing data...';
        _uploadProgress = 0.3;
      });

      // Create product data with base64 image
      // REMOVED: discountPrice calculation
      final productData = {
        'id': productId,
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        // REMOVED: 'discountPrice'
        'imageBase64': _base64Image,
        'categoryId': _categoryIdController.text.trim(),
        'stock': int.parse(_stockController.text.trim()),
        'isFeatured': _isFeatured,
        'createdAt': FieldValue.serverTimestamp(),
      };

      setState(() {
        _uploadStatus = 'Saving to database...';
        _uploadProgress = 0.6;
      });

      print('💾 Saving product to Firestore...');

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .set(productData);

      print('✅ Product saved successfully!');

      setState(() {
        _uploadProgress = 1.0;
        _uploadStatus = 'Complete!';
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully! 🎉'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);

    } catch (e) {
      print('❌ Error adding product: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildImagePreview() {
    if (_selectedImageBytes != null) {
      return Image.memory(
        _selectedImageBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImage = _base64Image != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF7C3AED),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Color(0xFF7C3AED),
                strokeWidth: 3,
              ),
              const SizedBox(height: 24),
              Text(
                _uploadStatus,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _uploadProgress,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF7C3AED),
                  ),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${(_uploadProgress * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Picker Section
              const Text(
                'Product Image *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select images under 900KB for best performance',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: hasImage
                          ? Colors.green.shade300
                          : Colors.red.shade300,
                      width: 2,
                    ),
                  ),
                  child: hasImage
                      ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _buildImagePreview(),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedImageFile = null;
                                _selectedImageBytes = null;
                                _selectedImageName = null;
                                _base64Image = null;
                              });
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '✅ Ready to save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 60,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        kIsWeb
                            ? 'Click to select image'
                            : 'Tap to select image',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Required (max 900KB)',
                        style: TextStyle(
                          color: Colors.red.shade400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Product Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name *',
                  prefixIcon: const Icon(Icons.shopping_bag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description *',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Category ID
              TextFormField(
                controller: _categoryIdController,
                decoration: InputDecoration(
                  labelText: 'Category ID *',
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  helperText: 'Example: electronics, fashion, etc.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter category ID';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Price Field Only
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Price (Rs.) *',
                  prefixIcon: const Icon(Icons.money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Stock
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stock Quantity *',
                  prefixIcon: const Icon(Icons.inventory),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter stock quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Enter valid number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Featured Switch
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: _isFeatured
                              ? const Color(0xFF7C3AED)
                              : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Featured Product',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _isFeatured,
                      onChanged: (value) {
                        setState(() => _isFeatured = value);
                      },
                      activeColor: const Color(0xFF7C3AED),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Add Product Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _addProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add Product',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}