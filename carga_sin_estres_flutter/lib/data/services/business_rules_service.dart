import 'dart:convert';

import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:http/http.dart' as http;

class BusinessRulesService {
  final String baseUrl = AppTheme.baseUrl;

  Future<void> createCompanyViolationService(
      int companyId, String reason) async {
    final response = await http.post(
      Uri.parse('$baseUrl/company-service-violation'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'companyId': companyId, 'reason': reason}),
    );
    if (response.statusCode != 201) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final errorMessage =
          responseBody['message'] ?? 'Failed to post company violation service';
      throw errorMessage;
    }
  }

  Future<int> getCompanyViolationServiceByCompanyIdAndYear(
      int companyId, int year) async {
    final response = await http.get(
      Uri.parse('$baseUrl/company-service-violation/$companyId/$year'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final errorMessage =
          responseBody['message'] ?? 'Failed to get company violation count';
      throw Exception(errorMessage);
    }
  }
}
