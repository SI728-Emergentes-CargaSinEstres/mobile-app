import 'dart:convert';
import 'package:carga_sin_estres_flutter/data/models/customer.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:http/http.dart' as http;

class CustomerService {
  final String baseUrl = AppTheme.baseUrl;

  Future<Customer> getCustomerById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/customers/${id.toString()}'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("THIS IS CORRECT: + $responseBody");
      return Customer.fromJson(responseBody);
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("THIS IS not CORRECT: + $responseBody");
      final errorMessage = responseBody['message'] ?? 'Failed to get customer';
      throw errorMessage;
    }
  }
}
