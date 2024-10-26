import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String time;
  final String userType;

  const ChatBubble({
    super.key,
    required this.message,
    required this.time,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUserMessage = userType == 'customer';

    return Column(
      crossAxisAlignment:
          isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4.0, bottom: 8.0),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: isUserMessage ? AppTheme.secondaryBlack : Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(isUserMessage ? 15.0 : 0),
              bottomRight: Radius.circular(isUserMessage ? 0 : 15.0),
              topLeft: const Radius.circular(15.0),
              topRight: const Radius.circular(15.0),
            ),
            border: Border.all(
              color:
                  isUserMessage ? Colors.transparent : AppTheme.secondaryBlack,
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
              color: isUserMessage ? Colors.white : AppTheme.secondaryBlack,
              fontSize: 16,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isUserMessage) const SizedBox(width: 4),
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
