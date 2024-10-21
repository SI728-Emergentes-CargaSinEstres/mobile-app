import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4.0, bottom: 8.0),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: isUser ? AppTheme.secondaryBlack : Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(isUser ? 15.0 : 0),
              bottomRight: Radius.circular(isUser ? 0 : 15.0),
              topLeft: const Radius.circular(15.0),
              topRight: const Radius.circular(15.0),
            ),
            border: Border.all(
              color: isUser ? Colors.transparent : AppTheme.secondaryBlack,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isUser ? Colors.white : AppTheme.secondaryBlack,
              fontSize: 16,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isUser) const SizedBox(width: 4),
            Text(
              time,
              style:
                  const TextStyle(color: AppTheme.secondaryBlack, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
