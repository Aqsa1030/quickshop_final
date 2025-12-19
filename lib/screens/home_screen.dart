import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:quickshop_final/models/product.dart';
import 'package:quickshop_final/providers/cart_provider.dart';
import 'package:quickshop_final/providers/product_provider.dart';
import 'package:quickshop_final/providers/category_provider.dart';
import 'package:quickshop_final/screens/product_detail_screen.dart';
import 'package:quickshop_final/widgets/common/app_drawer.dart';
import 'package:quickshop_final/widgets/home/banner_widget.dart';
import 'package:quickshop_final/widgets/home/product/product_grid.dart';
import 'package:quickshop_final/navigation/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> banners = [
    'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=1200',
    'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=1200',
    'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=1200',
  ];

  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  /// Load products when screen opens
  Future<void> _loadInitialData() async {
    if (_isInitialized) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

      print('🚀 Loading initial data...');

      // Fetch products and categories
      await Future.wait([
        productProvider.fetchProducts(),
        categoryProvider.fetchCategories(),
      ]);

      setState(() {
        _isInitialized = true;
      });

      print('✅ Initial data loaded');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.searchProducts(query);
    setState(() {
      _isSearching = query.isNotEmpty;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearch('');
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    // Determine which products to display
    List<Product> displayProducts = _isSearching
        ? productProvider.products
        : productProvider.featuredProducts;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text(
          'QuickShop',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF7C3AED),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.person,
                color: Color(0xFF7C3AED),
                size: 20,
              ),
            ),
            onPressed: () {
              AppRouter.navigateTo(context, AppRouter.profile);
            },
          ),
          const SizedBox(width: 8),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  AppRouter.navigateTo(context, AppRouter.cart);
                },
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      cartProvider.itemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          print('🔄 Refreshing data...');
          await Future.wait([
            productProvider.fetchProducts(),
            categoryProvider.fetchCategories(),
          ]);
          _clearSearch();
        },
        child: productProvider.isLoading && !_isInitialized
            ? const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF7C3AED),
          ),
        )
            : SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                      suffixIcon: _isSearching
                          ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey.shade500),
                        onPressed: _clearSearch,
                      )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: _onSearch,
                  ),
                ),
              ),

              // Banner (only show when not searching)
              if (!_isSearching)
                CarouselSlider.builder(
                  options: CarouselOptions(
                    height: 180,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    autoPlayInterval: const Duration(seconds: 3),
                  ),
                  itemCount: banners.length,
                  itemBuilder: (context, index, realIndex) {
                    return BannerWidget(imageUrl: banners[index]);
                  },
                ),

              // Categories (only show when not searching)
              if (!_isSearching)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          AppRouter.navigateTo(context, AppRouter.categories);
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),

              if (!_isSearching && categoryProvider.categories.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categoryProvider.categories.length,
                    itemBuilder: (context, index) {
                      final category = categoryProvider.categories[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () {
                            productProvider.filterByCategory(category.id);
                            setState(() {
                              _isSearching = true;
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: category.icon.isNotEmpty
                                      ? Image.network(
                                    category.icon,
                                    width: 30,
                                    height: 30,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.category);
                                    },
                                  )
                                      : const Icon(Icons.category),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                category.name,
                                style: const TextStyle(fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              // Products Section Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isSearching ? 'Products' : 'Featured Products',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    if (!_isSearching)
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          AppRouter.navigateTo(context, AppRouter.addProduct);
                        },
                        tooltip: 'Add Product',
                      ),
                  ],
                ),
              ),

              // Products Grid or Empty State
              if (productProvider.isLoading && _isInitialized)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF7C3AED),
                    ),
                  ),
                )
              else if (productProvider.error != null)
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.red.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading products',
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        productProvider.error!,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          productProvider.fetchProducts();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              else if (displayProducts.isNotEmpty)
                  ProductGrid(
                    products: displayProducts,
                    onProductTap: (product) {
                      AppRouter.navigateTo(
                        context,
                        AppRouter.productDetail,
                        arguments: product,
                      );
                    },
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(
                          _isSearching ? Icons.search_off : Icons.shopping_bag_outlined,
                          size: 60,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isSearching ? 'No products found' : 'No featured products',
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        if (_isSearching) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Try a different search term',
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                          ),
                        ],
                      ],
                    ),
                  ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}