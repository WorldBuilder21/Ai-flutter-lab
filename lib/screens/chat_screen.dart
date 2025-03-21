import 'package:ai_flutter_lab/services/gemini_ai_service.dart';
import 'package:ai_flutter_lab/widget/chat_bubble.dart';
import 'package:ai_flutter_lab/widget/chat_input.dart';
import 'package:ai_flutter_lab/widget/typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:ai_flutter_lab/models/chat_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/* 
- The message are stored in shared perference ( local storage )
- make it easier to view past message and revist convo's if needed
- it also always for a more cleaner look.

*/

/// The main chat screen of the application
class ChatScreen extends StatefulWidget {
  /// Constructor
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final GeminiService _geminiService = GeminiService();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  SharedPreferences? _prefs;
  bool _prefsInitialized = false;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    _geminiService.initialize();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _prefsInitialized = true;
    _loadMessages();
    _addWelcomeMessage();
  }

  void _loadMessages() {
    if (!_prefsInitialized || _prefs == null) return;

    final messagesJson = _prefs!.getStringList('chat_messages') ?? [];
    if (messagesJson.isNotEmpty) {
      setState(() {
        _messages.addAll(
          messagesJson
              .map((msg) => ChatMessage.fromJson(jsonDecode(msg)))
              .toList(),
        );
      });
    }
  }

  void _saveMessages() {
    if (!_prefsInitialized || _prefs == null) return;

    final messagesJson =
        _messages.map((msg) => jsonEncode(msg.toJson())).toList();
    _prefs!.setStringList('chat_messages', messagesJson);
  }

  void _addWelcomeMessage() {
    if (_messages.isEmpty) {
      setState(() {
        _messages.add(
          ChatMessage.fromBot(
            'Hello! I\'m your AI assistant. How can I help you today?',
          ),
        );
      });
      _saveMessages();
    }
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
    _saveMessages();
    _scrollToBottom();
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

  Future<void> _handleSendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage.fromUser(text);
    _addMessage(userMessage);

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    try {
      // Get response from Gemini API
      final response = await _geminiService.getChatResponse(text);

      // Add bot message
      final botMessage = ChatMessage.fromBot(response);
      _addMessage(botMessage);
    } catch (e) {
      print('Error: $e');
      _addMessage(
        ChatMessage.system('Sorry, I encountered an error. Please try again.'),
      );
    } finally {
      // Reset loading state
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chatbot'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _showClearChatDialog,
            tooltip: 'Clear chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 16.0),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return const TypingIndicator();
                }
                return ChatBubble(message: _messages[index]);
              },
            ),
          ),

          // Input field
          ChatInput(onSendMessage: _handleSendMessage, isLoading: _isLoading),
        ],
      ),
    );
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear chat history?'),
            content: const Text(
              'This will delete all messages. This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _messages.clear();
                    _addWelcomeMessage();
                  });
                  _geminiService.resetChat();
                  _saveMessages();
                },
                child: const Text('CLEAR'),
              ),
            ],
          ),
    );
  }
}
