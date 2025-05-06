// lib/services/product_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart'; // Import your Product model

class ProductService {
  // IMPORTANT: Replace with your backend URL.
  // For Android Emulator (if backend is on localhost:8000): "http://10.0.2.2:8000"
  // For iOS Simulator (if backend is on localhost:8000): "http://localhost:8000"
  // For physical device: "http://YOUR_COMPUTER_IP:8000"
  final String _apiDomain ="http://10.0.2.2:8000";
  // API endpoint for products
  final String _productsEndpoint = "/api/products";

  // Base URL for your images (points to Laravel's public/storage directory)
  // It should be _apiDomain + "/storage/"
  String get baseImageUrl => "$_apiDomain/storage/"; // Ensures it's derived

  Future<List<Product>> fetchPopularProducts() async {
    final String apiUrl = "$_apiDomain$_productsEndpoint";
    print('Fetching products from: $apiUrl');

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          // Add any other headers like Authorization if needed
        },
      );

      if (response.statusCode == 200) {
        // Check if your API wraps the list in a 'data' key
        // List<dynamic> body = jsonDecode(response.body)['data'];
        // If it's a direct list:
        List<dynamic> body = jsonDecode(response.body);

        if (body is List) {
          List<Product> products =
              body
                  .map(
                    (dynamic item) => Product.fromJson(
                      item as Map<String, dynamic>,
                      baseImageUrl,
                    ),
                  )
                  .toList();
          print('Successfully fetched ${products.length} products.');
          return products;
        } else {
          print('Products API response is not a list: $body');
          throw Exception(
            'Products API response is not in the expected format.',
          );
        }
      } else {
        print('Failed to load products. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
          'Failed to load products (Status code: ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Error fetching products: $e');
    }
  }
}
