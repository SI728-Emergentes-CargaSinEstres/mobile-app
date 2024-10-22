import 'dart:convert';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = AppTheme.baseUrl;

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
      // Almacena el correo del usuario en shared_preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'userEmail', email); // Almacena el email para persistencia
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
    await prefs
        .remove('userEmail'); // Borra el estado del usuario al cerrar sesión
  }
}
