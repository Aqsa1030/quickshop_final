import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final String icon;
  final String? imageBase64;
  final int productCount;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    this.imageBase64,
    this.productCount = 0,
  });

  // Create Category from Firestore Document
  factory Category.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Handle productCount which might be string or number
    int parseProductCount(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is num) return value.toInt();
      return 0;
    }

    return Category(
      id: doc.id,
      name: data['name']?.toString() ?? '',
      icon: data['icon']?.toString() ?? '',
      imageBase64: data['imageBase64']?.toString(),
      productCount: parseProductCount(data['productCount']),
    );
  }

  // Create Category from Map
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      imageBase64: json['imageBase64']?.toString(),
      productCount: (json['productCount'] as num?)?.toInt() ?? 0,
    );
  }

  // Convert Category to Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'imageBase64': imageBase64,
      'productCount': productCount,
    };
  }

  // Create a copy with updated fields
  Category copyWith({
    String? id,
    String? name,
    String? icon,
    String? imageBase64,
    int? productCount,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      imageBase64: imageBase64 ?? this.imageBase64,
      productCount: productCount ?? this.productCount,
    );
  }
}