// lib/screens/home_page.dart

import 'dart:math'; // For Random() if you still have mock data generation
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider

// Your custom class imports
import '../models/product.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';
import '../providers/cart_provider.dart'; // Import CartProvider
import 'product_detail_page.dart'; // Import ProductDetailPage
import 'cart_page.dart'; // Import CartPage

// --- Color Constants ---
const Color appPurple = Color(0xFF5E35B1);
const Color appAccentRed = Color(0xFFFF6B6B);
const Color lightPeachBackground = Color(0xFFFFE0B2);
const Color searchBarBackground = Color(0xFFF5F5F5);
const Color appDarkText = Color(0xFF333333);
const Color appLightText = Color(0xFF757575);

// --- Mock Data Models (if still used for other sections) ---
class CategoryItem {
  final String name;
  final IconData icon;
  CategoryItem({required this.name, required this.icon});
}

class SpecialCategory {
  final String title;
  final String subtitle;
  final String imageUrl;
  SpecialCategory({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final ProductService _productService = ProductService();

  String? _userName;
  bool _isLoadingUserData = true;
  int _currentBottomNavIndex = 0;

  final List<CategoryItem> _mainCategories = [
    CategoryItem(name: "Flash Deal", icon: Icons.flash_on_outlined),
    CategoryItem(name: "Bill", icon: Icons.receipt_long_outlined),
    CategoryItem(name: "Game", icon: Icons.gamepad_outlined),
    CategoryItem(name: "Daily Gift", icon: Icons.card_giftcard_outlined),
    CategoryItem(name: "More", icon: Icons.apps_outlined),
  ];

  final List<SpecialCategory> _specialCategories = List.generate(
    2,
    (index) => SpecialCategory(
      title: index == 0 ? "Smartphone" : "Fashion",
      subtitle: "${Random().nextInt(15) + 10} Brands",
      imageUrl:
          index == 0
              ? 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aGVhZHBob25lc3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60'
              : 'https://images.unsplash.com/photo-1445205170230-053b83016050?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8ZmFzaGlvbnxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60',
    ),
  );

  List<Product> _popularProducts = [];
  bool _isLoadingProducts = true;
  String? _productsError;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadPopularProducts();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoadingUserData = true);
    final name = await _authService.getUserName();
    if (mounted) {
      setState(() {
        _userName = name ?? 'User';
        _isLoadingUserData = false;
      });
    }
  }

  Future<void> _loadPopularProducts() async {
    setState(() {
      _isLoadingProducts = true;
      _productsError = null;
    });
    try {
      final products = await _productService.fetchPopularProducts();
      if (mounted) {
        setState(() {
          _popularProducts = products;
          _isLoadingProducts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _productsError = e.toString();
          _isLoadingProducts = false;
          _popularProducts = [];
        });
      }
      print("HomePage: Error loading products: $e");
    }
  }

  // _logout method is removed from here as it's handled in ProfilePage

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    // Added context
    // Access CartProvider to get item count for the badge
    final cartItemCount = Provider.of<CartProvider>(context).itemCount;

    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 16.0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: searchBarBackground,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search product',
              hintStyle: TextStyle(color: appLightText, fontSize: 14),
              prefixIcon: Icon(Icons.search, color: appLightText, size: 20),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 0,
              ),
            ),
          ),
        ),
        actions: [
          // Cart Icon with Badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: appDarkText,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartPage.routeName);
                },
              ),
              if (cartItemCount > 0)
                Positioned(
                  top: 8, // Adjust position as needed
                  right: 8, // Adjust position as needed
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: appAccentRed, // Use your accent color for badge
                      borderRadius: BorderRadius.circular(
                        8,
                      ), // Make it circular
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$cartItemCount',
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
          // Notification Icon (remains the same)
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: appDarkText,
                ),
                onPressed: () {
                  /* TODO: Navigate to notifications */
                },
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(color: Colors.white, fontSize: 8),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    /* ... remains the same ... */
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: appPurple,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "A Summer Surprise",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            "Cashback 20%",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(CategoryItem item) {
    /* ... remains the same ... */
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: lightPeachBackground,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Icon(item.icon, color: appAccentRed, size: 28),
        ),
        const SizedBox(height: 6),
        Text(
          item.name,
          style: const TextStyle(fontSize: 12, color: appDarkText),
        ),
      ],
    );
  }

  Widget _buildMainCategories() {
    /* ... remains the same ... */
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            _mainCategories
                .map((item) => Expanded(child: _buildCategoryIcon(item)))
                .toList(),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeMore) {
    /* ... remains the same ... */
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: appDarkText,
            ),
          ),
          TextButton(
            onPressed: onSeeMore,
            child: const Text(
              "See more",
              style: TextStyle(color: appLightText, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialCategoryCard(SpecialCategory category) {
    /* ... remains the same ... */
    return Container(
      width: 180, // Adjusted width
      margin: const EdgeInsets.only(right: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        image: DecorationImage(
          image: NetworkImage(category.imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              category.subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialForYou() {
    /* ... remains the same ... */
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Special for you", () {
          /* TODO: Navigate */
        }),
        SizedBox(
          height: 130, // Adjusted height
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16.0),
            itemCount: _specialCategories.length,
            itemBuilder: (context, index) {
              return _buildSpecialCategoryCard(_specialCategories[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    // Added context
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ProductDetailPage.routeName,
          arguments: product, // Pass the product object
        );
      },
      child: Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Hero(
                // Added Hero widget
                tag: product.id.toString(), // Unique tag for the Hero animation
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10.0),
                  ),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (
                      BuildContext context,
                      Widget child,
                      ImageChunkEvent? loadingProgress,
                    ) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                          strokeWidth: 2.0,
                          color: appAccentRed,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print(
                        "Image.network error for ${product.imageUrl}: $error, StackTrace: $stackTrace",
                      );
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 13,
                        color: appDarkText,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: appAccentRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularProducts(BuildContext context) {
    // Added context
    if (_isLoadingProducts) {
      /* ... remains the same ... */
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(color: appAccentRed),
        ),
      );
    }
    if (_productsError != null) {
      /* ... remains the same ... */
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 10),
              const Text(
                "Failed to load products",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                _productsError!,
                style: const TextStyle(fontSize: 12, color: appLightText),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _loadPopularProducts,
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }
    if (_popularProducts.isEmpty) {
      /* ... remains the same ... */
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text("No popular products found."),
        ),
      );
    }
    return Column(
      children: [
        _buildSectionHeader("Popular Products", () {
          /* TODO: Navigate */
        }),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: 0.68,
          ),
          itemCount: _popularProducts.length,
          itemBuilder: (ctx, index) {
            // Use ctx from builder
            return _buildProductCard(
              ctx,
              _popularProducts[index],
            ); // Pass context
          },
        ),
      ],
    );
  }

  void _onBottomNavItemTapped(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });
    switch (index) {
      case 0:
        break; // Home
      case 1: /* TODO: Navigate to Wishlist */
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wishlist (Not Implemented)')),
        );
        break;
      case 2: /* TODO: Navigate to Chat */
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Chat (Not Implemented)')));
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break; // Profile
    }
  }

  // _showLogoutConfirmationDialog is removed as it's in ProfilePage

  @override
  Widget build(BuildContext context) {
    // It's good practice to call Provider.of here if _buildAppBar needs it for the initial build.
    // However, since _buildAppBar is called within this build method, context is available.
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context), // Pass context
      body:
          _isLoadingUserData
              ? const Center(
                child: CircularProgressIndicator(color: appAccentRed),
              )
              : RefreshIndicator(
                onRefresh: () async {
                  await _loadUserData();
                  await _loadPopularProducts();
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPromoBanner(),
                      _buildMainCategories(),
                      _buildSpecialForYou(),
                      _buildPopularProducts(context), // Pass context
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: appAccentRed,
        unselectedItemColor: appLightText,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
