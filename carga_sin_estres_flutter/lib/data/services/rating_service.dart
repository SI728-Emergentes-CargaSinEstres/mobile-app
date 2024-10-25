import 'dart:convert';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:http/http.dart' as http;

class RatingService {
  final String baseUrl = AppTheme.baseUrl;

  Future<void> postRatingByCompanyId(int companyId, int rating) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$companyId/ratings'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'stars': rating}),
    );
    if (response.statusCode != 201) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final errorMessage = responseBody['message'] ?? 'Failed to post rating';
      throw errorMessage;
    }
  }
}
