import 'package:flutter/material.dart';
import 'package:ai_flutter_lab/models/chat_message.dart';
import 'package:ai_flutter_lab/models/message_type.dart';
import 'package:intl/intl.dart';

/// A widget that displays a chat message as a bubble
class ChatBubble extends StatelessWidget {
  /// The message to display
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == MessageType.user;
    final isSystem = message.type == MessageType.system;

    // Format the timestamp
    final timeFormat = DateFormat('h:mm a');
    final formattedTime = timeFormat.format(message.timestamp);

    // Diplays system error messages as chat
    if (isSystem) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(message.text, style: TextStyle(color: Colors.black87)),
          ),
        ),
      );
    }

    // For user and bot messages
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(),
          const SizedBox(width: 8.0),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blue[400] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4.0,
                    left: 4.0,
                    right: 4.0,
                  ),
                  child: Text(
                    formattedTime,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 8.0),
          if (isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  /// Build the avatar for the AI
  Widget _buildAvatar() {
    return CircleAvatar(
      backgroundColor: Colors.purple[100],
      child: const Icon(Icons.smart_toy_rounded, color: Colors.deepPurple),
    );
  }

  /// Build the avatar for the user
  Widget _buildUserAvatar() {
    return CircleAvatar(
      backgroundColor: Colors.blue[100],
      child: const Icon(Icons.person, color: Colors.blue),
    );
  }
}
