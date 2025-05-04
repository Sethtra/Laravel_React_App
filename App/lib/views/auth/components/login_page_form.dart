import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for TextInputType
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http; // Import http
import 'dart:convert'; // Import convert for json

import '../../../core/constants/constants.dart'; // Assuming these exist
import '../../../core/routes/app_routes.dart'; // Assuming these exist
import '../../../core/themes/app_themes.dart'; // Assuming these exist
import '../../../core/utils/validators.dart'; // Assuming these exist
// Removed LoginButton import, using ElevatedButton for simplicity

class LoginPageForm extends StatefulWidget {
  const LoginPageForm({
    super.key,
  });

  @override
  State<LoginPageForm> createState() => _LoginPageFormState();
}

class _LoginPageFormState extends State<LoginPageForm> {
  final _formKey = GlobalKey<FormState>(); // Renamed key for clarity
  // --- Added Controllers ---
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // --- End Added ---

  bool _obscurePassword = true; // Renamed for clarity
  bool _isLoading = false; // Added loading state

  // --- Toggle Password Visibility ---
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // --- Dispose Controllers ---
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- Login Logic ---
  Future<void> _login() async {
    // Validate the form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    // --- Replace with your actual Laravel Login API endpoint ---
    const String apiUrl =
        'http://10.0.2.2:8000/api/login'; // Example for Android Emulator
    // ---

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json', // Important for Laravel
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (!mounted) return; // Check if widget is still in the tree

      final responseBody = jsonDecode(response.body); // Decode JSON response

      if (response.statusCode == 200) {
        // --- Login Successful ---
        print('Login successful: ${response.body}'); // Log success data

        // TODO: Save authentication token and user info securely
        // Example: (Requires shared_preferences or flutter_secure_storage package)
        // final token = responseBody['token']; // Adjust key based on your API response
        // final user = responseBody['user']; // Adjust key
        // await SharedPreferences.getInstance().then((prefs) {
        //   prefs.setString('auth_token', token);
        //   prefs.setString('user_info', jsonEncode(user));
        // });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successful!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to the main part of the app
        Navigator.pushReplacementNamed(
            context, AppRoutes.entryPoint); // Use pushReplacementNamed
      } else {
        // --- Login Failed ---
        String errorMessage = 'Login failed.';
        // Try to get error message from Laravel response
        if (responseBody['message'] != null) {
          errorMessage = responseBody['message'];
        } else if (responseBody['errors'] != null &&
            responseBody['errors'] is Map) {
          // Handle potential validation errors if API returns them on login
          errorMessage = responseBody['errors'].values.first[0];
        } else {
          errorMessage =
              'Invalid credentials or server error (Code: ${response.statusCode})';
        }

        print('Login failed: ${response.body}'); // Log failure data

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // --- Network or other exceptions ---
      if (!mounted) return;
      print('Login exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error during login: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Hide loading indicator
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.defaultTheme.copyWith(
        inputDecorationTheme: AppTheme.secondaryInputDecorationTheme,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDefaults.padding),
        child: Form(
          key: _formKey, // Use the renamed key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Email Field ---
              const Text("Email"),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController, // Assign controller
                keyboardType: TextInputType.emailAddress, // Set keyboard type
                validator: Validators.email.call, // Use email validator
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(hintText: 'Enter your email'),
              ),
              // --- End Email Field ---

              const SizedBox(height: AppDefaults.padding),

              // --- Password Field ---
              const Text("Password"),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController, // Assign controller
                validator: Validators.password.call, // Use password validator
                onFieldSubmitted: (v) =>
                    _isLoading ? null : _login(), // Call _login on submit
                textInputAction: TextInputAction.done,
                obscureText: _obscurePassword, // Use state variable
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  suffixIcon: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed:
                          _togglePasswordVisibility, // Call toggle function
                      icon: SvgPicture.asset(
                        // Use correct icon based on state
                        _obscurePassword
                            ? AppIcons.eye
                            : AppIcons.eyeSlash, // Need eyeSlash icon
                        width: 24,
                      ),
                    ),
                  ),
                ),
              ),
              // --- End Password Field ---

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.forgotPassword);
                  },
                  child: const Text('Forget Password?'),
                ),
              ),

              const SizedBox(
                  height: AppDefaults.padding), // Add space before button

              // --- Login Button ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : _login, // Call _login, disable if loading
                  style: ElevatedButton.styleFrom(
                      // Add styling if needed
                      ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Login'),
                ),
              ),
              // --- End Login Button ---
            ],
          ),
        ),
      ),
    );
  }
}

// --- Placeholder for Icons ---
// Ensure you have these assets or replace paths
class AppIcons {
  static const String eye = 'assets/icons/eye.svg';
  static const String eyeSlash = 'assets/icons/eye_slash.svg';
}
