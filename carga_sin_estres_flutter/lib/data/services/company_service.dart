import 'dart:convert';
import 'package:carga_sin_estres_flutter/data/models/company.dart';
import 'package:carga_sin_estres_flutter/data/models/services.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:http/http.dart' as http;

class CompanyService {
  final String baseUrl = AppTheme.baseUrl;

  Future<List<Company>> getCompanies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/companies'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseBody = jsonDecode(response.body);
      return responseBody.map((company) => Company.fromJson(company)).toList();
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final errorMessage = responseBody['message'] ?? 'Failed to get companies';
      throw errorMessage;
    }
  }

  Future<List<Services>> getServices() async {
    final response = await http.get(
      Uri.parse('$baseUrl/services'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseBody = jsonDecode(response.body);
      return responseBody.map((company) => Services.fromJson(company)).toList();
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final errorMessage = responseBody['message'] ?? 'Failed to get services';
      throw errorMessage;
    }
  }

  Future<Company> getCompanyByName(String name) async {
    // Construct the URI with the name query parameter
    final uri = Uri.parse('$baseUrl/companiesByName')
        .replace(queryParameters: {'name': name});

    // Log the URI for debugging
    print('Request URI: $uri');

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Parse the JSON response and return the Company object
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      return Company.fromJson(responseBody);
    } else {
      // Handle errors
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final errorMessage = responseBody['message'] ?? 'Failed to get company';
      throw Exception(errorMessage);
    }
  }
}
