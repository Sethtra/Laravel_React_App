import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../widgets/cart_item_widget.dart';
import 'checkout_page.dart'; // Import CheckoutPage for routeName

// Re-using color constants, ensure they are accessible or redefine them here
const Color appAccentRed = Color(0xFFFF6B6B);
const Color appDarkText = Color(0xFF333333);
const Color appLightText = Color(0xFF757575);

class CartPage extends StatelessWidget {
  static const routeName = '/cart';

  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.cartItemsList;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Your Cart'),
            if (cart.itemCount > 0)
              Text(
                '${cart.itemCount} ${cart.itemCount == 1 ? 'item' : 'items'}',
                style: const TextStyle(fontSize: 12, color: appLightText),
              ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body:
          cartItems.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.remove_shopping_cart_outlined,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your Cart is Empty',
                      style: TextStyle(fontSize: 20, color: appLightText),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appAccentRed,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Go Shopping'),
                    ),
                  ],
                ),
              )
              : ListView.builder(
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
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 15,
        bottom: MediaQuery.of(context).padding.bottom + 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
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
                child: Text(
                  'Add voucher code',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Navigator.of(
                    context,
                  ).pushNamed(CheckoutPage.routeName); // Corrected line
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
