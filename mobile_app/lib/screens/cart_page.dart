import 'package:flutter/material.dart'; // <-- MOST IMPORTANT: ADD THIS
import 'package:provider/provider.dart'; // <-- ADD THIS

import '../providers/cart_provider.dart';
// import '../models/cart_item.dart' as ci; // Already imported by CartItemWidget
import '../widgets/cart_item_widget.dart';

// Re-using color constants, ensure they are accessible or redefine them here
const Color appAccentRed = Color(0xFFFF6B6B);
const Color appDarkText = Color(0xFF333333);
const Color appLightText = Color(0xFF757575);

class CartPage extends StatelessWidget {
  // This should be fine now
  static const routeName = '/cart';

  const CartPage({super.key}); // This should be fine now

  @override
  Widget build(BuildContext context) {
    // Widget and BuildContext should be fine
    final cart = Provider.of<CartProvider>(
      context,
    ); // Provider and CartProvider should be fine
    final cartItems = cart.cartItemsList;

    return Scaffold(
      // Scaffold should be fine
      backgroundColor: Colors.white, // Colors should be fine
      appBar: AppBar(
        // AppBar should be fine
        title: Column(
          // Column should be fine
          children: [
            const Text('Your Cart'), // Text should be fine
            if (cart.itemCount > 0)
              Text(
                '${cart.itemCount} ${cart.itemCount == 1 ? 'item' : 'items'}',
                style: const TextStyle(
                  fontSize: 12,
                  color: appLightText,
                ), // TextStyle should be fine
              ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          // IconButton should be fine
          icon: const Icon(
            Icons.arrow_back_ios,
          ), // Icon and Icons should be fine
          onPressed:
              () => Navigator.of(context).pop(), // Navigator should be fine
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body:
          cartItems.isEmpty
              ? Center(
                // Center should be fine
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center, // MainAxisAlignment should be fine
                  children: [
                    Icon(
                      Icons.remove_shopping_cart_outlined,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 20), // SizedBox should be fine
                    const Text(
                      'Your Cart is Empty',
                      style: TextStyle(fontSize: 20, color: appLightText),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      // ElevatedButton should be fine
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        // ElevatedButton.styleFrom should be fine
                        backgroundColor: appAccentRed,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ), // EdgeInsets should be fine
                      ),
                      child: const Text('Go Shopping'),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                // ListView.builder should be fine
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 10.0,
                ),
                itemCount: cartItems.length,
                itemBuilder: (ctx, i) => CartItemWidget(cartItem: cartItems[i]),
              ),
      bottomNavigationBar:
          cartItems.isEmpty ? null : _buildCheckoutSection(context, cart),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, CartProvider cart) {
    // Widget, BuildContext, CartProvider should be fine
    return Container(
      // Container should be fine
      padding: EdgeInsets.only(
        // EdgeInsets should be fine
        left: 20,
        right: 20,
        top: 15,
        bottom:
            MediaQuery.of(context).padding.bottom +
            15, // MediaQuery should be fine
      ),
      decoration: BoxDecoration(
        // BoxDecoration should be fine
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // BoxShadow should be fine
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, -3), // Offset should be fine
          ),
        ],
        borderRadius: const BorderRadius.only(
          // BorderRadius should be fine
          topLeft: Radius.circular(24), // Radius should be fine
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // MainAxisSize should be fine
        children: [
          Row(
            // Row should be fine
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.local_offer_outlined,
                  color: appAccentRed,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                // Expanded should be fine
                child: Text(
                  'Add voucher code',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ), // FontWeight should be fine
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: appLightText,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    // ScaffoldMessenger and SnackBar should be fine
                    const SnackBar(content: Text('Add voucher tapped!')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start, // CrossAxisAlignment should be fine
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 15, color: appLightText),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: appDarkText,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Checkout tapped!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                ),
                child: const Text('Check Out'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
