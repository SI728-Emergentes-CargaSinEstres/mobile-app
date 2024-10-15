import 'dart:convert';
import 'package:carga_sin_estres_flutter/models/message.dart';
import 'package:http/http.dart' as http;

class ChatService {
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
}
