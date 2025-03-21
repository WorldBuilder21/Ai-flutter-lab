import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

/// A widget that shows a typing indicator when the AI is "thinking"
class TypingIndicator extends StatelessWidget {
  /// Constructor
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Bot avatar
          CircleAvatar(
            backgroundColor: Colors.purple[100],
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(width: 8.0),

          // Animated typing indicator
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText(
                  'Thinking...',
                  textStyle: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                  ),
                  speed: const Duration(milliseconds: 200),
                ),
              ],
              isRepeatingAnimation: true,
              repeatForever: true,
            ),
          ),
        ],
      ),
    );
  }
}
