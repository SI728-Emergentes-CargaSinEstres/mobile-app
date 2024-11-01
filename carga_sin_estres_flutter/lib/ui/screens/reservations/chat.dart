import 'package:carga_sin_estres_flutter/data/models/message.dart';
import 'package:carga_sin_estres_flutter/data/models/reservation.dart';
import 'package:carga_sin_estres_flutter/data/services/chat_service.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/chat_bubble.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/custom_bottom_navigation_bar.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/message_input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final Reservation reservation;

  const ChatScreen({super.key, required this.reservation});

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
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    try {
      final messages =
          await _chatService.getMessagesByReservationId(widget.reservation.id);
      setState(() {
        _messages.addAll(messages);
      });
    } catch (error) {
      print('Error loading messages: $error');
    }
  }

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

  void _sendMessage(String message) async {
    if (message.isEmpty) return;

    try {
      Message newMessage = await _chatService.postMessageByReservationId(
          widget.reservation.id, message);

      _addMessageToList(newMessage);

      _controller.clear();
    } catch (error) {
      print('Error sending message: $error');
    }
  }

  void _addMessageToList(Message message) {
    setState(() {
      _messages.add(message);
      _scrollToBottom();
    });
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
                  time: DateFormat.jm().format(messageData.messageDate),
                  userType: messageData.userType,
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
