import 'package:daily_activity/core/error/dio_failure.dart';
import 'package:daily_activity/core/error/failure.dart';
import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/services/gemini_service.dart';
import 'package:daily_activity/features/ai_assistant/data/model/chat_message.dart';
import 'package:daily_activity/features/ai_assistant/data/repository/ai_assistant_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AiAssistantRepoImpl implements AiAssistantRepo {
  final GeminiService _geminiService = GeminiService();

  @override
  Either<Failure, Stream<String>> sendMessage({
    required String userMessage,
    List<ChatMessage> conversationHistory = const [],
    String? contextSummary,
  }) {
    try {
      // Build contents array from conversation history
      final List<Map<String, dynamic>> contents = [];

      // Add conversation history (excluding streaming placeholders)
      for (final msg in conversationHistory) {
        if (msg.text.isEmpty) continue; // Skip empty messages

        contents.add({
          "parts": [
            {"text": msg.text},
          ],
          "role": msg.role == ChatRole.user ? "user" : "model",
        });
      }

      // Add the new user message
      contents.add({
        "parts": [
          {"text": userMessage},
        ],
        "role": "user",
      });

      final Map<String, dynamic> body = {
        "contents": contents,
        "generationConfig": {
          "thinkingConfig": {"thinkingBudget": 0},
          "maxOutputTokens": 300,
        },
      };

      final response = _geminiService.post(body: body);

      return Right(response);
    } on DioException catch (dioException) {
      return Left(ServerFailure.fromDioException(dioException));
    } catch (error) {
      return Left(ServerFailure("Unexpected error ${error.toString()}"));
    }
  }

  @override
  Either<Failure, Future<ProjectModel>> generateProject(
      {required String category, required String userPrompt}) {
    // TODO: implement generateProject
    throw UnimplementedError();
  }

  @override
  Future<void> resetConversation() async {
    // Currently no persistent state to reset
    // This can be expanded if we add caching or session management
    return;
  }
}
