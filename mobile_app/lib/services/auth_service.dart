import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Replace with your backend URL.
  // For Android Emulator, if backend is on localhost:8000, use http://10.0.2.2:8000
  // For iOS Simulator, if backend is on localhost:8000, use http://localhost:8000
  final String _baseUrl = "http://10.0.2.2:8000/api";

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    return _handleResponse(response, storeToken: true);
  }

  Future<Map<String, dynamic>> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      return {'success': true, 'message': 'Already logged out'};
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/logout'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    await prefs.remove('token');
    await prefs.remove('userName'); // Also remove user name if stored

    if (response.statusCode == 200 || response.statusCode == 204) {
      return {'success': true, 'message': 'Successfully logged out'};
    } else {
      // Even if API logout fails, clear local token
      return {
        'success': false,
        'message': 'Logout failed on server, but cleared locally.',
        'data': jsonDecode(response.body),
      };
    }
  }

  Map<String, dynamic> _handleResponse(
    http.Response response, {
    bool storeToken = false,
  }) {
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (storeToken && responseBody.containsKey('token')) {
        _storeTokenAndUserData(
          responseBody['token'],
          responseBody['user']?['name'],
        );
      }
      return {'success': true, 'data': responseBody};
    } else {
      return {
        'success': false,
        'message': responseBody['message'] ?? 'An error occurred',
        'errors': responseBody['errors'],
      };
    }
  }

  Future<void> _storeTokenAndUserData(String token, String? userName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    if (userName != null) {
      await prefs.setString('userName', userName);
    }
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  Future<void> clearToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userName');
  }
}
