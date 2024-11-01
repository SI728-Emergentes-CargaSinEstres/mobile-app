import 'dart:convert';
import 'package:carga_sin_estres_flutter/data/models/sign_up.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = AppTheme.baseUrl;

  Future<void> signUp(SignUp signUp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/customers'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(signUp.toJsonSignUp()),
    );
    if (response.statusCode == 201) {
      return;
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final errorMessage = responseBody['message'] ?? 'Failed to sign up';
      throw errorMessage;
    }
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final String encodedEmail = Uri.encodeQueryComponent(email);
    final String encodedPassword = Uri.encodeQueryComponent(password);

    final response = await http.get(
      Uri.parse(
          '$baseUrl/customers?email=$encodedEmail&password=$encodedPassword'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final int userId = responseBody['id'];

      await prefs.setString('userEmail', email);
      await prefs.setInt('userId', userId);
      return responseBody;
    } else if (response.statusCode == 404) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final errorMessage = responseBody['message'] ?? 'Login failed';
      throw errorMessage;
    } else {
      throw 'An unexpected error occurred';
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
    await prefs.remove('userId');
  }
}
