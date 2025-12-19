import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final String? imageBase64; // CHANGED: from imageUrl to imageBase64
  final String categoryId;
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final int stock;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    this.imageBase64, // CHANGED: made nullable
    required this.categoryId,
    this.rating = 0,
    this.reviewCount = 0,
    this.isFeatured = false,
    this.stock = 0,
    required this.createdAt,
  });

  double get finalPrice {
    return discountPrice != null && discountPrice! > 0
        ? discountPrice!
        : price;
  }

  bool get hasDiscount {
    return discountPrice != null &&
        discountPrice! > 0 &&
        discountPrice! < price;
  }

  double get discountPercentage {
    if (discountPrice == null || discountPrice == 0) return 0;
    return ((price - discountPrice!) / price) * 100;
  }

  // Convert Product to Firestore Map
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'discountPrice': discountPrice,
    'imageBase64': imageBase64, // CHANGED
    'categoryId': categoryId,
    'rating': rating,
    'reviewCount': reviewCount,
    'isFeatured': isFeatured,
    'stock': stock,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  // Create Product from Firestore Document
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Product(
      id: doc.id, // Use Firestore document ID
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: data['discountPrice'] != null
          ? (data['discountPrice'] as num).toDouble()
          : null,
      imageBase64: data['imageBase64'] as String?, // CHANGED
      categoryId: data['categoryId'] ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (data['reviewCount'] as num?)?.toInt() ?? 0,
      isFeatured: data['isFeatured'] ?? false,
      stock: (data['stock'] as num?)?.toInt() ?? 0,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // Create Product from Map (backward compatibility)
  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
    discountPrice: json['discountPrice'] != null
        ? (json['discountPrice'] as num).toDouble()
        : null,
    imageBase64: json['imageBase64'] as String?, // CHANGED
    categoryId: json['categoryId'] ?? '',
    rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
    isFeatured: json['isFeatured'] ?? false,
    stock: (json['stock'] as num?)?.toInt() ?? 0,
    createdAt: json['createdAt'] is Timestamp
        ? (json['createdAt'] as Timestamp).toDate()
        : DateTime.now(),
  );

  // Create a copy with updated fields
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? discountPrice,
    String? imageBase64, // CHANGED
    String? categoryId,
    double? rating,
    int? reviewCount,
    bool? isFeatured,
    int? stock,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      imageBase64: imageBase64 ?? this.imageBase64, // CHANGED
      categoryId: categoryId ?? this.categoryId,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFeatured: isFeatured ?? this.isFeatured,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}