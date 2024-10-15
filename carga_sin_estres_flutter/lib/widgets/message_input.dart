import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  final TextEditingController controller;
  final bool hasText;
  final Function(String) onSend;
  final Function(String) onTextChanged;

  const MessageInput({
    super.key,
    required this.controller,
    required this.hasText,
    required this.onSend,
    required this.onTextChanged,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: 'Mensaje...',
                hintStyle: const TextStyle(color: AppTheme.secondaryBlack),
                filled: true,
                fillColor: const Color.fromARGB(255, 225, 226, 227),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                widget.onTextChanged(value);
                setState(() {});
              },
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  widget.onSend(value);
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: const BoxDecoration(
              color: AppTheme.secondaryBlack,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                if (widget.controller.text.isNotEmpty) {
                  // Si hay texto, envíalo
                  widget.onSend(widget.controller.text);
                  widget.controller.clear();
                  setState(() {});
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
