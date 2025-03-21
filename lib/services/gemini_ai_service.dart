import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:ai_flutter_lab/config/api_config.dart';

/// Service class for interacting with the Google Gemini API
class GeminiService {
  /// The Gemini model instance
  GenerativeModel? _model;
  
  /// Chat session instance
  ChatSession? _chatSession;

  /// Initialize the Gemini service
  void initialize() {
    if (ApiConfig.geminiApiKey.isEmpty) {
      print('Warning: Gemini API key not set');
      return;
    }

    try {
      final model = GenerativeModel(
        model: ApiConfig.geminiModel,
        apiKey: ApiConfig.geminiApiKey,
        generationConfig: GenerationConfig(
          temperature: ApiConfig.temperature,
          maxOutputTokens: ApiConfig.maxTokens,
        ),
      );
      
      _model = model;
      _chatSession = model.startChat();
      
      print('Gemini service initialized successfully');
    } catch (e) {
      print('Error initializing Gemini service: $e');
    }
  }

  /// Get a response from the Gemini API based on user input
  Future<String> getChatResponse(String userInput) async {
    try {
      // Check if API key is configured and model is initialized
      if (ApiConfig.geminiApiKey.isEmpty) {
        return "Please set your Gemini API key in the .env file. Create a file named .env in the project root with GEMINI_API_KEY=your_key_here";
      }
      
      if (_model == null) {
        initialize();
      }
      
      if (_chatSession == null) {
        return "Could not initialize chat session. Please check your API key and internet connection.";
      }

      // Send message and get response
      final response = await _chatSession!.sendMessage(
        Content.text(userInput),
      );
      
      // Get the text from the response
      final responseText = response.text ?? 'No response generated';
      return responseText;
    } catch (e) {
      print('Error getting chat response: $e');
      return 'Sorry, something went wrong. Please try again later. Error: ${e.toString()}';
    }
  }

  /// Reset the chat session
  void resetChat() {
    if (_model != null) {
      _chatSession = _model!.startChat();
    }
  }

}