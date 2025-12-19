import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickshop_final/providers/category_provider.dart';
import 'package:quickshop_final/providers/product_provider.dart';
import 'package:quickshop_final/widgets/home/product/product_card.dart';
import 'package:quickshop_final/screens/product_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Fetch categories and products when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
        final productProvider = Provider.of<ProductProvider>(context, listen: false);

        print('🔄 Loading categories and products...');
        await Future.wait([
          categoryProvider.fetchCategories(),
          productProvider.fetchProducts(),
        ]);
        print('✅ Data loading complete');
      } catch (e) {
        print('❌ Error loading data: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    // Debug: Check categories
    if (!categoryProvider.isLoading && categoryProvider.categories.isEmpty) {
      print('⚠️ No categories available in provider');
      if (categoryProvider.error != null) {
        print('❌ Error from provider: ${categoryProvider.error}');
      }
    } else {
      print('📊 Categories count: ${categoryProvider.categories.length}');
    }

    // Filter products based on selected category
    final filteredProducts = _selectedCategoryId == null
        ? productProvider.allProducts
        : productProvider.allProducts
        .where((product) => product.categoryId == _selectedCategoryId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
      ),
      body: categoryProvider.isLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading categories...'),
          ],
        ),
      )
          : categoryProvider.categories.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No categories available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            if (categoryProvider.error != null) ...[
              const SizedBox(height: 8),
              Text(
                categoryProvider.error!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : Column(
        children: [
          // Category Filter Chips
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              itemCount: categoryProvider.categories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // "All" chip
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: const Text('All'),
                      selected: _selectedCategoryId == null,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategoryId = null;
                          productProvider.clearCategoryFilter();
                        });
                      },
                      backgroundColor: Colors.grey.shade100,
                      selectedColor: Theme.of(context)
                          .primaryColor
                          .withOpacity(0.2),
                      checkmarkColor: Theme.of(context).primaryColor,
                      labelStyle: TextStyle(
                        color: _selectedCategoryId == null
                            ? Theme.of(context).primaryColor
                            : Colors.black87,
                        fontWeight: _selectedCategoryId == null
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                }

                final category = categoryProvider.categories[index - 1];
                final isSelected = _selectedCategoryId == category.id;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (category.icon.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              category.icon,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        Text(category.name),
                        if (category.productCount > 0)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              '(${category.productCount})',
                              style: TextStyle(
                                fontSize: 11,
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategoryId = selected ? category.id : null;
                        if (selected) {
                          productProvider.filterByCategory(category.id);
                        } else {
                          productProvider.clearCategoryFilter();
                        }
                      });
                    },
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: Theme.of(context)
                        .primaryColor
                        .withOpacity(0.2),
                    checkmarkColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          // Products Grid
          Expanded(
            child: productProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredProducts.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _selectedCategoryId == null
                        ? 'No products available'
                        : 'No products in this category',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (_selectedCategoryId != null) ...[
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedCategoryId = null;
                          productProvider.clearCategoryFilter();
                        });
                      },
                      child: const Text('View all products'),
                    ),
                  ],
                ],
              ),
            )
                : RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  categoryProvider.fetchCategories(),
                  productProvider.fetchProducts(),
                ]);
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ProductCard(
                    product: product,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailScreen(
                                product: product,
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}