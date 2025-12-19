import 'package:flutter/material.dart';
import 'package:quickshop_final/models/product.dart';
import 'package:quickshop_final/utils/responsive.dart';
import 'package:quickshop_final/widgets/home/product/product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductTap;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.responsiveGridColumns(context);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () => onProductTap(product),
        );
      },
    );
  }
}