import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../core/constants/constants.dart'; // Assuming these exist
import '../../../core/utils/validators.dart'; // Assuming these exist
import 'already_have_accout.dart'; // Assuming this exists

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  // --- State Variables ---
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // --- Added Confirm Password Controller ---
  final _confirmPasswordController = TextEditingController();
  // --- End Added ---
  bool _obscurePassword = true;
  // --- Added state for confirm password visibility ---
  bool _obscureConfirmPassword = true;
  // --- End Added ---
  bool _isLoading = false;

  // --- Dispose Controllers ---
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose(); // Dispose the new controller
    super.dispose();
  }

  // --- Sign Up Logic (Backend call remains the same) ---
  Future<void> _signUp() async {
    // Validate the form (this will now include confirm password validation)
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    const String apiUrl =
        'http://10.0.2.2:8000/api/register'; // <-- CHANGE THIS

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        // Backend expects 'password' and 'password_confirmation'
        body: jsonEncode(<String, String>{
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'password_confirmation': _confirmPasswordController
              .text, // Send confirm password value here
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign up successful!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigator.of(context).pushReplacementNamed('/login');
      } else {
        String errorMessage = 'An error occurred during sign up.';
        try {
          final responseBody = jsonDecode(response.body);
          if (responseBody['errors'] != null && responseBody['errors'] is Map) {
            // If Laravel returns validation errors for password confirmation, handle it
            if (responseBody['errors']['password'] != null) {
              errorMessage = responseBody['errors']['password'][0];
            } else {
              // Otherwise, take the first available error
              errorMessage = responseBody['errors'].values.first[0];
            }
          } else if (responseBody['message'] != null) {
            errorMessage = responseBody['message'];
          }
        } catch (e) {
          errorMessage = 'Sign up failed (Code: ${response.statusCode})';
          print('Error parsing response: $e');
          print('Response body: ${response.body}');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      print('Sign up exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Network error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDefaults.margin),
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppDefaults.boxShadow,
        borderRadius: AppDefaults.borderRadius,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Full Name"), // Changed label slightly
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              validator: Validators.requiredWithFieldName('Full Name').call,
              textInputAction: TextInputAction.next,
              decoration:
                  const InputDecoration(hintText: 'Enter your full name'),
            ),

            const SizedBox(height: AppDefaults.padding),

            const Text("Email"),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              validator: Validators.email.call,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Enter your email'),
            ),

            const SizedBox(height: AppDefaults.padding),

            const Text("Password"),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              validator:
                  Validators.password.call, // Use your password validator
              textInputAction: TextInputAction.next, // Change to next
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                suffixIcon: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: SvgPicture.asset(
                      _obscurePassword ? AppIcons.eye : AppIcons.eyeSlash,
                      width: 24,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(
                height: AppDefaults.padding), // Space before confirm password

            // --- Added Confirm Password Field ---
            const Text("Confirm Password"),
            const SizedBox(height: 8),
            TextFormField(
              controller: _confirmPasswordController,
              // Validator to check if it matches the password field
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null; // Return null if validation passes
              },
              textInputAction:
                  TextInputAction.done, // Now this is the last field
              obscureText:
                  _obscureConfirmPassword, // Use separate state variable
              decoration: InputDecoration(
                hintText: 'Re-enter your password',
                suffixIcon: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    icon: SvgPicture.asset(
                      _obscureConfirmPassword
                          ? AppIcons.eye
                          : AppIcons.eyeSlash,
                      width: 24,
                    ),
                  ),
                ),
              ),
              onFieldSubmitted: (_) =>
                  _isLoading ? null : _signUp(), // Submit on done
            ),
            // --- End Added Confirm Password Field ---

            const SizedBox(height: AppDefaults.padding * 2),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
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
                    : const Text('Sign Up'),
              ),
            ),

            const SizedBox(height: AppDefaults.padding),
            const AlreadyHaveAnAccount(),
            const SizedBox(height: AppDefaults.padding),
          ],
        ),
      ),
    );
  }
}

// --- Placeholder for Icons ---
class AppIcons {
  static const String eye = 'assets/icons/eye.svg';
  static const String eyeSlash = 'assets/icons/eye_slash.svg';
}