import 'dart:convert';
import 'package:carga_sin_estres_flutter/data/models/message.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:http/http.dart' as http;

class ChatService {
  final String baseUrl = AppTheme.baseUrl;

  /*
  Future<List<Message>> getResponses(String message) async {
    // Simular un pequeño retraso para imitar una respuesta de red
    await Future.delayed(const Duration(seconds: 1));
    return [
      Message(
          content: 'Respuesta a: $message',
          time: _formatCurrentTime(),
          isUser: false),
    ];
  }
  

  static String _formatCurrentTime() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
  }
  */

  //get messages by reservation id
  Future<List<Message>> getMessagesByReservationId(int reservationId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/messages/$reservationId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseBody = jsonDecode(response.body);
      return responseBody.map((message) => Message.fromJson(message)).toList();
    } else {
      throw Exception('Failed to get messages: ${response.statusCode}');
    }
  }
}
