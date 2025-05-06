// lib/models/product.dart
import 'package:flutter/material.dart'; // For Color

class ColorOption {
  final String name; // e.g., "Red", "Blue"
  final Color color; // The actual color value
  // You might also have a color code string if your API provides hex, e.g., "#FF0000"

  ColorOption({required this.name, required this.color});

  // Example: If API sends hex color string
  // factory ColorOption.fromHex(String name, String hexColor) {
  //   return ColorOption(name: name, color: Color(int.parse(hexColor.replaceFirst('#', '0xFF'))));
  // }
}

class Product {
  final int id;
  final String name;
  final String imageUrl; // Main image for lists
  final List<String> allImageUrls; // For image gallery on detail page
  final String imagePath; // Original path from DB
  final double price;
  final String category;
  final String description;
  final double rating; // e.g., 4.7
  final List<ColorOption> availableColors;
  // Add other fields like brand, stock_quantity if needed

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.allImageUrls = const [], // Default to empty list
    required this.imagePath,
    required this.price,
    required this.category,
    required this.description,
    this.rating = 0.0, // Default rating
    this.availableColors = const [], // Default to empty list
  });

  factory Product.fromJson(Map<String, dynamic> json, String baseImageUrl) {
    String imagePathFromApi = json['image'] ?? 'default_placeholder.png';
    double parsedPrice = 0.0;
    if (json['price'] != null) {
      if (json['price'] is String) {
        parsedPrice = double.tryParse(json['price']) ?? 0.0;
      } else if (json['price'] is num) {
        parsedPrice = (json['price'] as num).toDouble();
      }
    }

    String mainFullImageUrl = baseImageUrl;
    if (!baseImageUrl.endsWith('/')) mainFullImageUrl += '/';
    if (imagePathFromApi.startsWith('/')) {
      mainFullImageUrl += imagePathFromApi.substring(1);
    } else {
      mainFullImageUrl += imagePathFromApi;
    }

    // --- MOCKING/ASSUMING API STRUCTURE FOR NEW FIELDS ---
    // You'll need to adjust this based on your actual API response for these fields

    // For allImageUrls: Assuming API sends a list of relative paths in a field like 'gallery_images'
    List<String> galleryImageUrls = [
      mainFullImageUrl,
    ]; // Start with the main image
    if (json['gallery_images'] != null && json['gallery_images'] is List) {
      for (var relativePath in json['gallery_images']) {
        if (relativePath is String) {
          String galleryFullUrl = baseImageUrl;
          if (!baseImageUrl.endsWith('/')) galleryFullUrl += '/';
          if (relativePath.startsWith('/')) {
            galleryFullUrl += relativePath.substring(1);
          } else {
            galleryFullUrl += relativePath;
          }
          if (galleryFullUrl != mainFullImageUrl) {
            // Avoid duplicates if main is also in gallery
            galleryImageUrls.add(galleryFullUrl);
          }
        }
      }
    }
    // If no gallery_images, add some mock thumbnails based on main image for UI testing
    if (galleryImageUrls.length <= 1 && json['gallery_images'] == null) {
      galleryImageUrls.add(
        mainFullImageUrl.replaceAll('.', '_thumb1.'),
      ); // very basic mock
      galleryImageUrls.add(
        mainFullImageUrl.replaceAll('.', '_thumb2.'),
      ); // very basic mock
    }

    // For availableColors: Assuming API sends a list of objects like [{"name": "Red", "hex": "#FF0000"}]
    List<ColorOption> colors = [];
    if (json['available_colors'] != null && json['available_colors'] is List) {
      for (var colorData in json['available_colors']) {
        if (colorData is Map<String, dynamic> &&
            colorData['name'] != null &&
            colorData['hex'] != null) {
          try {
            colors.add(
              ColorOption(
                name: colorData['name'],
                color: Color(
                  int.parse(
                    (colorData['hex'] as String).replaceFirst('#', '0xFF'),
                  ),
                ),
              ),
            );
          } catch (e) {
            print("Error parsing color: ${colorData['hex']}");
          }
        }
      }
    }
    // If no colors from API, add mock colors for UI testing
    if (colors.isEmpty && json['available_colors'] == null) {
      colors.addAll([
        ColorOption(name: 'Red', color: Colors.red),
        ColorOption(name: 'Blue', color: Colors.purple),
        ColorOption(name: 'Gold', color: Colors.amber),
        ColorOption(name: 'White', color: Colors.white),
      ]);
    }
    // --- END MOCKING/ASSUMING ---

    print(
      'Product ID ${json['id']}: Main image: $mainFullImageUrl, Gallery: ${galleryImageUrls.length}, Colors: ${colors.length}',
    );

    return Product(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Unnamed Product',
      imagePath: imagePathFromApi,
      imageUrl: mainFullImageUrl,
      allImageUrls:
          galleryImageUrls.isNotEmpty ? galleryImageUrls : [mainFullImageUrl],
      price: parsedPrice,
      category: json['category'] as String? ?? 'Uncategorized',
      description:
          json['description'] as String? ?? 'No description available.',
      rating:
          (json['rating'] as num?)?.toDouble() ??
          4.7, // Default if not from API
      availableColors: colors,
    );
  }
}
