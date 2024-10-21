import 'package:carga_sin_estres_flutter/data/models/message.dart';
import 'package:carga_sin_estres_flutter/data/services/chat_service.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/chat_bubble.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/custom_bottom_navigation_bar.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/message_input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  bool _hasText = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    setState(() {
      _hasText = text.isNotEmpty;
    });
  }

  void _sendMessage(String message) {
    if (message.isEmpty) return;

    // Agregar el mensaje del usuario
    _addMessageToList(message, true);

    // Llamar al servicio de chat para recibir una respuesta automatica
    _chatService.getResponses(message).then((responses) {
      for (var response in responses) {
        _addMessageToList(response.content, response.isUser);
      }
    });

    _controller.clear();
  }

  void _addMessageToList(String message, bool isUser) {
    setState(() {
      _messages.add(Message(
        content: message,
        time: _formatCurrentTime(),
        isUser: isUser,
      ));
      _scrollToBottom();
    });
  }

  String _formatCurrentTime() {
    final now = DateTime.now().toLocal();
    return DateFormat.jm().format(now);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Chat',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.secondaryBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final messageData = _messages[index];
                return ChatBubble(
                  message: messageData.content,
                  time: messageData.time,
                  isUser: messageData.isUser,
                );
              },
            ),
          ),
          MessageInput(
            controller: _controller,
            hasText: _hasText,
            onSend: _sendMessage,
            onTextChanged: _onTextChanged,
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
