import 'dart:developer';

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
      // Determine if this is the first message (no conversation history)
      final bool isFirstMessage = conversationHistory.length == 1;
      final List<Map<String, dynamic>> contents = [];
      log("isFirstMessage: $isFirstMessage");

      if (isFirstMessage) {
        // Add system prompt
        contents.add({
          "parts": [
            {
              "text":
                  '''You are a personal productivity assistant for a daily activity tracking app.

Your role:
- Help users understand their activity data and patterns
- Answer questions about their tracked tasks, habits, and progress
- Suggest ways to improve their productivity based on their data
- Explain app features when asked

Critical constraints:
- Only answer based on data explicitly provided to you in this conversation
- If you don't have the information needed to answer, say: "I don't have access to that data yet. Please share your [specific data type] so I can help."
- Never invent or assume user data (tasks, completion rates, dates, etc.)
- Never hallucinate features the app doesn't have

Response style:
- Be concise and actionable
- Use bullet points for lists
- Focus on insights, not generic advice

When you don't know something, say so immediately. Accuracy over helpfulness.'''
            },
          ],
          'role': 'system',
        });
      } else {
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
      log("Body sent is: $body");
      return Right(response);
    } on DioException catch (dioException) {
      return Left(ServerFailure.fromDioException(dioException));
    } catch (error) {
      return Left(ServerFailure("Unexpected error {error.toString()}"));
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
