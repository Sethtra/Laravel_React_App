// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/home_page.dart';
import 'screens/profile_page.dart';
import 'screens/product_detail_page.dart';
import 'screens/cart_page.dart';
import 'screens/checkout_page.dart'; // Make sure this import is present

import 'services/auth_service.dart';
import 'providers/cart_provider.dart';
import 'models/product.dart';

// Your color constants
const Color appAccentRed = Color(0xFFFF6B6B);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (ctx) => CartProvider())],
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
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: appAccentRed,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        CartPage.routeName: (context) => const CartPage(),
        CheckoutPage.routeName:
            (context) => const CheckoutPage(), // <-- ADD THIS LINE
      },
      onGenerateRoute: (settings) {
        if (settings.name == ProductDetailPage.routeName) {
          final product = settings.arguments as Product;
          return MaterialPageRoute(
            builder: (context) {
              return ProductDetailPage(product: product);
            },
          );
        }
        if (settings.name == '/home' && !isLoggedIn) {
          return MaterialPageRoute(builder: (_) => const LoginPage());
        }
        return null;
      },
    );
  }
}
