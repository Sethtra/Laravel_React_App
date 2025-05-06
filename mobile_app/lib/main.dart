// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/home_page.dart';
import 'screens/profile_page.dart';
import 'screens/product_detail_page.dart'; // We will create this
import 'screens/cart_page.dart'; // We will create this

import 'services/auth_service.dart';
import 'providers/cart_provider.dart'; // Import CartProvider
import 'models/product.dart'; // Import Product for onGenerateRoute

// Your color constants (consider moving to a theme file)
const Color appAccentRed = Color(0xFFFF6B6B); // Example, ensure this is defined

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  runApp(
    MultiProvider(
      // Wrap MyApp with MultiProvider
      providers: [
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        // You can add other global providers here
      ],
      child: MyApp(isLoggedIn: token != null),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter E-commerce App',
      theme: ThemeData(
        primarySwatch: Colors.orange, // Or your preferred swatch
        scaffoldBackgroundColor: Colors.grey[50], // Light background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0, // Flat app bars
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: appAccentRed, // Use your accent color
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Rounded buttons
            ),
          ),
        ),
        // Define other theme properties
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        CartPage.routeName: (context) => const CartPage(), // Add CartPage route
      },
      onGenerateRoute: (settings) {
        // For routes that need arguments, like ProductDetailPage
        if (settings.name == ProductDetailPage.routeName) {
          final product =
              settings.arguments as Product; // Expect a Product object
          return MaterialPageRoute(
            builder: (context) {
              return ProductDetailPage(product: product);
            },
          );
        }
        // Handle /home auth check if still needed here, or manage with a root wrapper
        if (settings.name == '/home' && !isLoggedIn) {
          return MaterialPageRoute(builder: (_) => const LoginPage());
        }
        // Add other dynamic routes here if necessary
        return null; // Let routes map handle others or return an error page
      },
    );
  }
}
