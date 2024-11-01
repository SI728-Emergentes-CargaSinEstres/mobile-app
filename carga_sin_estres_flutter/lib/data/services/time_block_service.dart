import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carga_sin_estres_flutter/utils/theme.dart';

class TimeBlock {
  final int id;
  final String startTime;
  final String endTime;
  final int companyId;

  TimeBlock({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.companyId,
  });

  factory TimeBlock.fromJson(Map<String, dynamic> json) {
    return TimeBlock(
      id: json['id'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      companyId: json['companyId'],
    );
  }
}

class TimeBlockService {
  final String baseUrl = AppTheme.baseUrl;

  Future<TimeBlock?> getTimeBlockByCompanyId(int companyId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/timeblock/$companyId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      return TimeBlock.fromJson(responseBody);
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final errorMessage =
          responseBody['message'] ?? 'Failed to get time block';
      throw errorMessage;
    }
  }
}
