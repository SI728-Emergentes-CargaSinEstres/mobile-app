import 'dart:convert';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = AppTheme.baseUrl;

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    // Codifica los parámetros para evitar problemas con caracteres especiales
    final String encodedEmail = Uri.encodeQueryComponent(email);
    final String encodedPassword = Uri.encodeQueryComponent(password);

    final response = await http.get(
      Uri.parse(
          '$baseUrl/customers?email=$encodedEmail&password=$encodedPassword'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      return responseBody; // Devolvemos el cuerpo de la respuesta si es exitoso.
    } else if (response.statusCode == 404) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final errorMessage = responseBody['message'] ?? 'Login failed';
      throw errorMessage; // Lanza un error en caso de que el login falle.
    } else {
      throw 'An unexpected error occurred';
    }
  }
}
