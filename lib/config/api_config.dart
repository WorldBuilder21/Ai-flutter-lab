import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration class for API-related settings
class ApiConfig {
  /// The API key for Google Gemini services
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  /// The Gemini model to use
  static const String geminiModel = 'gemini-1.5-pro';

  /// The maximum number of tokens to generate
  static const int maxTokens = 1024;

  static const double temperature = 0.7;

  /// Maximum number of input tokens (for context window)
  static const int maxInputTokens = 16384;
}
