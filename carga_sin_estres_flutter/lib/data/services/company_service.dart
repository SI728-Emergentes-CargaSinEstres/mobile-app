import 'dart:convert';
import 'package:carga_sin_estres_flutter/data/models/company.dart';
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
      print('SUCCESS responseBody: $responseBody');
      return responseBody.map((company) => Company.fromJson(company)).toList();
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      print('AWFUL responseBody: $responseBody');
      final errorMessage = responseBody['message'] ?? 'Failed to get companies';
      throw errorMessage;
    }
  }
}
