import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'cart_page.dart'; // For navigating to cart page

// Re-using color constants, ensure they are accessible or redefine them here
const Color appAccentRed = Color(0xFFFF6B6B);
const Color appDarkText = Color(0xFF333333);
const Color appLightText = Color(0xFF757575);
// const Color primaryUserColor = Color(0xFFDBCC8E); // Your previously defined color

class ProductDetailPage extends StatefulWidget {
  static const routeName = '/product-detail';
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late String _selectedImageUrl;
  ColorOption? _selectedColor;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _selectedImageUrl = widget.product.imageUrl; // Start with the main image
    if (widget.product.availableColors.isNotEmpty) {
      _selectedColor =
          widget.product.availableColors.first; // Default to first color
    }
  }

  void _selectImage(String imageUrl) {
    setState(() {
      _selectedImageUrl = imageUrl;
    });
  }

  void _selectColor(ColorOption color) {
    setState(() {
      _selectedColor = color;
    });
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _addToCart() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    cart.addItem(
      widget.product,
      selectedColor: _selectedColor,
      quantity: _quantity,
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide previous
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart!'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: () {
            Navigator.of(context).pushNamed(CartPage.routeName);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background for the page
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: screenHeight * 0.4, // Image takes up ~40% of height
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 1,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: appDarkText),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  children: [
                    Text(
                      widget.product.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: appDarkText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                  ],
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.product.id, // Same tag as in product list item
                child: Image.network(
                  _selectedImageUrl,
                  fit:
                      BoxFit
                          .contain, // Or BoxFit.cover depending on image aspect
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Image Thumbnails
                if (widget.product.allImageUrls.length > 1)
                  Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    color: Colors.white,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.product.allImageUrls.length,
                      itemBuilder: (ctx, index) {
                        final imageUrl = widget.product.allImageUrls[index];
                        return GestureDetector(
                          onTap: () => _selectImage(imageUrl),
                          child: Container(
                            width: 60,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color:
                                    _selectedImageUrl == imageUrl
                                        ? appAccentRed
                                        : Colors.grey.shade300,
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // Product Info Section
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.only(
                    top: 1.0,
                  ), // For slight separation
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      // Optional: if you want rounded corners if thumbnails are not present
                      // topLeft: Radius.circular(widget.product.allImageUrls.length > 1 ? 0 : 20),
                      // topRight: Radius.circular(widget.product.allImageUrls.length > 1 ? 0 : 20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.product.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: appDarkText,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.grey[400],
                            ), // TODO: Favorite state
                            onPressed: () {
                              // TODO: Implement favorite toggle
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.product.description,
                        style: TextStyle(
                          fontSize: 15,
                          color: appLightText,
                          height: 1.4,
                        ),
                        maxLines: 3, // Show limited lines initially
                        overflow: TextOverflow.ellipsis,
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Show full description in a dialog or new page
                          showDialog(
                            context: context,
                            builder:
                                (ctx) => AlertDialog(
                                  title: Text(widget.product.name),
                                  content: SingleChildScrollView(
                                    child: Text(widget.product.description),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('Close'),
                                      onPressed: () => Navigator.of(ctx).pop(),
                                    ),
                                  ],
                                ),
                          );
                        },
                        child: const Text(
                          'See More Detail >',
                          style: TextStyle(
                            color: appAccentRed,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Color Selection
                      if (widget.product.availableColors.isNotEmpty)
                        Row(
                          children: [
                            const Text(
                              'Color: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: appDarkText,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      widget.product.availableColors.length,
                                  itemBuilder: (ctx, index) {
                                    final colorOption =
                                        widget.product.availableColors[index];
                                    final isSelected =
                                        _selectedColor?.color.value ==
                                        colorOption.color.value;
                                    return GestureDetector(
                                      onTap: () => _selectColor(colorOption),
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: colorOption.color,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color:
                                                isSelected
                                                    ? appAccentRed
                                                    : Colors.transparent,
                                            width: 2.5,
                                          ),
                                          boxShadow: [
                                            if (colorOption.color ==
                                                    Colors.white ||
                                                colorOption.color.opacity < 1)
                                              BoxShadow(
                                                color: Colors.grey.shade300,
                                                spreadRadius: 1,
                                              ),
                                          ],
                                        ),
                                        child:
                                            isSelected &&
                                                    colorOption.color !=
                                                        Colors.white
                                                ? const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 18,
                                                )
                                                : (isSelected &&
                                                        colorOption.color ==
                                                            Colors.white
                                                    ? const Icon(
                                                      Icons.check,
                                                      color: Colors.black,
                                                      size: 18,
                                                    )
                                                    : null),
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (ctx, index) => const SizedBox(width: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomAddToCartBar(context),
    );
  }

  Widget _buildBottomAddToCartBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 15,
        bottom:
            MediaQuery.of(context).padding.bottom + 15, // Safe area for bottom
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Quantity Selector
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: appDarkText),
                  onPressed: _decrementQuantity,
                  iconSize: 20,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  constraints: const BoxConstraints(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '$_quantity',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: appDarkText,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: appDarkText),
                  onPressed: _incrementQuantity,
                  iconSize: 20,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Add to Cart Button
          Expanded(
            child: ElevatedButton(
              onPressed: _addToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: appAccentRed,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Add To Cart',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
