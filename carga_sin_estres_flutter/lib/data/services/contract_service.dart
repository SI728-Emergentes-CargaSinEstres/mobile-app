import 'dart:convert';
import 'package:carga_sin_estres_flutter/data/models/contract.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:http/http.dart' as http;

class ContractService {
  final String baseUrl = AppTheme.baseUrl;

  Future<Contract> getContractByReservationId(int reservationId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/contracts/${reservationId.toString()}'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      return Contract.fromJson(responseBody);
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final errorMessage = responseBody['message'] ?? 'Failed to get contract';
      throw errorMessage;
    }
  }

  Future<void> createContract(int reservationId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/contracts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'reservationId': reservationId}),
    );
    if (response.statusCode != 201) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final errorMessage = responseBody['message'] ?? 'Failed to post contract';
      throw errorMessage;
    }
  }
}
