import 'package:ai_flutter_lab/models/message_type.dart';

/// Model class for a chat message
/// With json serialization capabilities, makes it easier to handle incoming
/// and outgoing messages with the app
/// also provider better structure and is easier to debug
class ChatMessage {
  /// Unique identifier for the message
  final String id;

  /// The text content of the message
  final String text;

  /// The type of message (user, bot, system)
  final MessageType type;

  /// The timestamp when the message was created
  final DateTime timestamp;

  /// Constructor for creating a new chat message
  ChatMessage({
    required this.id,
    required this.text,
    required this.type,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Create a message from the user
  factory ChatMessage.fromUser(String text) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      type: MessageType.user,
    );
  }

  /// Create a message from the AI bot
  factory ChatMessage.fromBot(String text) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      type: MessageType.bot,
    );
  }

  /// Create a system message
  factory ChatMessage.system(String text) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      type: MessageType.system,
    );
  }

  /// Convert message to a map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Create a message from a map (for storage retrieval)
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    MessageType type;
    switch (json['type']) {
      case 'MessageType.user':
        type = MessageType.user;
        break;
      case 'MessageType.bot':
        type = MessageType.bot;
        break;
      default:
        type = MessageType.system;
    }

    return ChatMessage(
      id: json['id'],
      text: json['text'],
      type: type,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
