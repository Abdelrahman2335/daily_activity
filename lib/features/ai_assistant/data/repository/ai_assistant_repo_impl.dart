import 'package:daily_activity/core/error/dio_failure.dart';
import 'package:daily_activity/core/error/failure.dart';
import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/services/gemini_service.dart';
import 'package:daily_activity/features/ai_assistant/data/repository/ai_assistant_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AiAssistantRepoImpl implements AiAssistantRepo {
  final GeminiService _geminiService = GeminiService();

  @override
  Either<Failure, Stream<String>> sendMessage(
      {required String userMessage, String? contextSummary}) {
    try {
      final Map<String, dynamic> body = {
        "contents": [
          {
            "parts": [
              {"text": userMessage},
            ],
          },
        ],
        "generationConfig": {
          "thinkingConfig": {"thinkingBudget": 0},
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
  Future<void> resetConversation() {
    // TODO: implement resetConversation
    throw UnimplementedError();
  }
}
