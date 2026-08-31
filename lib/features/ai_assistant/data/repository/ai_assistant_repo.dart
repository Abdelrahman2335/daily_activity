import 'package:flowi/core/error/failure.dart';
import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/features/ai_assistant/data/model/chat_message.dart';
import 'package:dartz/dartz.dart';

abstract class AiAssistantRepo {
  /// Sends a message to the AI assistant and returns the assistant’s reply.
  ///
  /// [userMessage] - the user’s input text.
  /// [conversationHistory] - list of previous messages to maintain context.
  /// [contextSummary] - optional summary of prior context (e.g., user goals or
  /// ongoing project details) to keep requests lightweight.
  Either<Failure, Stream<String>> sendMessage({
    required String userMessage,
    List<ChatMessage> conversationHistory = const [],
    String? contextSummary,
  });

  /// Generates a new project suggestion based on user input or the current context.
  ///
  /// Should return a [ProjectModel] instance ready to be stored or edited in-app.
  /// Example usage: asking the AI “Create a new Work project for marketing tasks.”
  Either<Failure, Future<ProjectModel>> generateProject({
    required String category, // e.g. "Work", "Personal", "Study"
    required String userPrompt,
  });

  /// Clears or resets any cached conversation state, if your implementation
  /// stores local AI context (e.g., for Gemini sessions).
  Future<void> resetConversation();
}
