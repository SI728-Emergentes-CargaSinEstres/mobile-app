import 'dart:convert';
import 'package:carga_sin_estres_flutter/data/models/sign_up.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:http/http.dart' as http;

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
}
