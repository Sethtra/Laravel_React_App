// lib/widgets/cart_item_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart' as ci;
import '../providers/cart_provider.dart';
import '../screens/product_detail_page.dart'; // For navigation

// Re-using color constants
const Color appAccentRed = Color.fromARGB(255, 23, 117, 36);
const Color appDarkText = Color(0xFF333333);
const Color appLightText = Color(0xFF757575);
// Define the pinkish background color for the delete button area
final Color deleteButtonAreaColor = Colors.pink.shade50; // Or Colors.red[50]

class CartItemWidget extends StatelessWidget {
  final ci.CartItem cartItem;

  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return InkWell(
      // Make the whole item tappable
      onTap: () {
        // Navigate to product detail page when item is tapped
        Navigator.of(
          context,
        ).pushNamed(ProductDetailPage.routeName, arguments: cartItem.product);
      },
      child: Container(
        color: Colors.white, // Ensure item background is white
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0),
        margin: const EdgeInsets.symmetric(
          vertical: 4.0,
        ), // Add some vertical spacing
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Image
            Padding(
              // Add padding to the left of the image
              padding: const EdgeInsets.only(
                left: 15.0,
              ), // Match CartPage horizontal padding
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  cartItem.product.imageUrl,
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (ctx, err, st) => Container(
                        height: 70,
                        width: 70,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[400],
                        ),
                      ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: appDarkText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${cartItem.product.price.toStringAsFixed(2)} x${cartItem.quantity}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: appAccentRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (cartItem.selectedColor != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Color: ',
                            style: TextStyle(fontSize: 12, color: appLightText),
                          ),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: cartItem.selectedColor!.color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            // Delete Button Area
            InkWell(
              // Make the delete area tappable
              onTap: () {
                // Show confirmation dialog before deleting
                showDialog(
                  context: context,
                  builder:
                      (ctx) => AlertDialog(
                        title: const Text('Remove Item'),
                        content: Text(
                          'Are you sure you want to remove ${cartItem.product.name} from your cart?',
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                          ),
                          TextButton(
                            child: const Text(
                              'Remove',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              cart.removeItemCompletely(cartItem.id);
                              Navigator.of(ctx).pop(); // Close dialog
                              ScaffoldMessenger.of(
                                context,
                              ).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${cartItem.product.name} removed from cart.',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                );
              },
              child: Container(
                width: 60, // Width of the pink area
                height:
                    70 +
                    2 * 4, // Match approximate item height + vertical margin
                margin: const EdgeInsets.only(
                  left: 10.0,
                ), // Space before delete area
                decoration: BoxDecoration(
                  color: deleteButtonAreaColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(
                      12,
                    ), // Rounded corners for the area
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red.shade700,
                    size: 26,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
