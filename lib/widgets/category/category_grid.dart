import 'package:flutter/material.dart';
import 'package:quickshop_final/models/category.dart';

import 'category_tile.dart';

class CategoryGrid extends StatelessWidget {
  final List<Category> categories;
  final Function(Category) onCategoryTap;

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryTile(
          category: category,
          onTap: () => onCategoryTap(category),
        );
      },
    );
  }
}