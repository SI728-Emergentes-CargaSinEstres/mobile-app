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
      return Customer.fromJson(responseBody);
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final errorMessage = responseBody['message'] ?? 'Failed to get customer';
      throw errorMessage;
    }
  }

  Future<Customer> updateCustomerById(int id, Customer customer) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/customers/${id.toString()}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(customer.toJson()),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      return Customer.fromJson(responseBody);
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final errorMessage =
          responseBody['message'] ?? 'Failed to update customer';
      throw errorMessage;
    }
  }
}
