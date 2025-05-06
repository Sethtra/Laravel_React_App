// lib/models/cart_item.dart
import './product.dart'; // Assuming product.dart is in the same models folder

class CartItem {
  final String
  id; // Unique ID for the cart item (e.g., product.id + selectedColor.name)
  final Product product;
  int quantity;
  final ColorOption? selectedColor; // Optional: if product has color variants

  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
    this.selectedColor,
  });

  double get itemPrice => product.price * quantity;
}
