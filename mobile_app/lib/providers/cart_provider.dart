// lib/providers/cart_provider.dart
import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart'; // For Product and ColorOption

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items}; // Return a copy
  }

  List<CartItem> get cartItemsList {
    return _items.values.toList();
  }

  int get itemCount {
    // Returns the number of unique items (considering variants)
    return _items.length;
  }

  int get totalQuantityOfItems {
    // Returns the total number of physical items (sum of quantities)
    int total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.quantity;
    });
    return total;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  // Generates a unique ID for a cart item based on product ID and selected color
  String _generateCartItemId(int productId, ColorOption? selectedColor) {
    String id = productId.toString();
    if (selectedColor != null) {
      // Using color value for uniqueness as names might not be unique across products
      id += '_color${selectedColor.color.value}';
    }
    return id;
  }

  void addItem(
    Product product, {
    ColorOption? selectedColor,
    int quantity = 1,
  }) {
    if (quantity <= 0) return;

    final cartItemId = _generateCartItemId(product.id, selectedColor);

    if (_items.containsKey(cartItemId)) {
      _items.update(
        cartItemId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          product: existingCartItem.product,
          quantity: existingCartItem.quantity + quantity,
          selectedColor: existingCartItem.selectedColor,
        ),
      );
    } else {
      _items.putIfAbsent(
        cartItemId,
        () => CartItem(
          id: cartItemId,
          product: product,
          quantity: quantity,
          selectedColor: selectedColor,
        ),
      );
    }
    notifyListeners();
    print(
      "Item added/updated. Cart ID: $cartItemId. New total quantity: $totalQuantityOfItems",
    );
  }

  void removeSingleItem(String cartItemId) {
    // Decrements quantity or removes if 1
    if (!_items.containsKey(cartItemId)) {
      return;
    }
    if (_items[cartItemId]!.quantity > 1) {
      _items.update(
        cartItemId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          product: existingCartItem.product,
          quantity: existingCartItem.quantity - 1,
          selectedColor: existingCartItem.selectedColor,
        ),
      );
    } else {
      _items.remove(cartItemId);
    }
    notifyListeners();
  }

  void removeItemCompletely(String cartItemId) {
    // Removes the entire item regardless of quantity
    _items.remove(cartItemId);
    notifyListeners();
  }

  void updateItemQuantity(String cartItemId, int newQuantity) {
    if (!_items.containsKey(cartItemId)) {
      return;
    }
    if (newQuantity <= 0) {
      removeItemCompletely(cartItemId);
    } else {
      _items.update(
        cartItemId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          product: existingCartItem.product,
          quantity: newQuantity,
          selectedColor: existingCartItem.selectedColor,
        ),
      );
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
