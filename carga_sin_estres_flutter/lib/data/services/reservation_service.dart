import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:carga_sin_estres_flutter/data/models/reservation_model.dart';

class ReservationService {
  final String baseUrl = AppTheme.baseUrl;

  Future<void> createReservation({
    required int customerId,
    required int companyId,
    required Reservation reservation,
  }) async {
    final url =
        '$baseUrl/reservations?customerId=$customerId&idCompany=$companyId';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reservation.toJson()),
    );

    // Aceptar códigos de estado 200 y 201 como éxito
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear la reserva: ${response.body}');
    }
  }
}
