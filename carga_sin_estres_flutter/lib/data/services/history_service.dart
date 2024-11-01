import 'dart:convert';
import 'package:carga_sin_estres_flutter/data/models/reservation.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:http/http.dart' as http;

class HistoryService {
  final String baseUrl = AppTheme.baseUrl;

  Future<List<Reservation>> getReservationsByCustomerId(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/reservations/customer/${id.toString()}'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseBody = jsonDecode(response.body);
      return responseBody.map((json) => Reservation.fromJson(json)).toList();
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final errorMessage =
          responseBody['message'] ?? 'Failed to get customer reservations';
      throw errorMessage;
    }
  }

  Future<void> updateReservationStatus(int id, String status) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/reservations/$id/status?status=$status'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final errorMessage =
          responseBody['message'] ?? 'Failed to update reservation status';
      throw errorMessage;
    }
  }
}
