import 'package:flowi/core/error/dio_failure.dart';
import 'package:flowi/core/error/failure.dart';
import 'package:flowi/core/services/gemini_service.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

void main() async {
  TestAiChat test = TestAiChat();
  final result =
      test.sendMessage(userMessage: "Can you explain to me what is Flutter?");

  result.fold(
    (failure) {
      print("Error occurred: ${failure.errorMessage}");
    },
    (stream) async {
      print("Response stream received, listening for data...");
      await for (String chunk in stream) {
        print("Response chunk: $chunk");
      }
      print("Stream completed.");
    },
  );
}

class TestAiChat {
  final GeminiService _geminiService = GeminiService();

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
}
