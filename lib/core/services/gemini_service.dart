import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  GeminiService._internal();
  static final GeminiService instance = GeminiService._internal();

  factory GeminiService() => instance;

  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:streamGenerateContent';

  late final Dio _dio;

  /// Initialize the service with API key from environment variables
  void initialize() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in .env file. '
          'Please create a .env file with your API key.');
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: Duration(seconds: 40),
        receiveTimeout: Duration(seconds: 60),
        contentType: Headers.jsonContentType,
        headers: {
          "x-goog-api-key": apiKey,
        },
      ),
    );

    log("GeminiService initialized with API key from environment");
  }

  Stream<String> post({required Map<String, dynamic> body}) async* {
    try {
      final response = await _dio.post(
        _baseUrl,
        data: body,
        onSendProgress: (count, total) {
          log("Sending progress${(count / total * 100).toStringAsFixed(0)}");
        },
      );

      // Handle Gemini API streaming response (returned as List<dynamic>)
      if (response.data is List) {
        final List<dynamic> dataList = response.data;
        for (var item in dataList) {
          if (item is Map<String, dynamic>) {
            final text =
                item['candidates']?[0]?['content']?['parts']?[0]?['text'];
            if (text != null) {
              yield text.toString();
              log("Response chunk: $text");
            }
          }
        }
      } else if (response.data is Map<String, dynamic>) {
        // Handle single response
        final Map<String, dynamic> data = response.data;
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        if (text != null) {
          yield text.toString();
          log("Response: $text");
        }
      }
    } catch (e) {
      log("Error in post method: $e");
      rethrow;
    }
  }
}
