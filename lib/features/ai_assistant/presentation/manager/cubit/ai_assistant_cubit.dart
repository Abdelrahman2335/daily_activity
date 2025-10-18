import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:daily_activity/core/error/failure.dart';
import 'package:daily_activity/core/error/dio_failure.dart';
import 'package:daily_activity/features/ai_assistant/data/repository/ai_assistant_repo.dart';
import 'package:daily_activity/features/ai_assistant/data/repository/ai_assistant_repo_impl.dart';
import 'package:daily_activity/features/ai_assistant/domain/models/chat_message.dart';
import 'package:meta/meta.dart';

part 'ai_assistant_state.dart';

class AiAssistantCubit extends Cubit<AiAssistantState> {
  AiAssistantCubit() : super(AiAssistantState.initial());

  final AiAssistantRepo _aiAssistantRepo = AiAssistantRepoImpl();

  StreamSubscription<String>? _streamSub;

  // Deprecated: keeping for compatibility if referenced elsewhere.
  // With Option A, the UI should read from state.messages instead.
  Stream<String> get geminiResponse => const Stream.empty();
  String get userMessage {
    // Return last user message if present
    final idx = state.messages.lastIndexWhere((m) => m.role == ChatRole.user);
    return idx == -1 ? '' : state.messages[idx].text;
  }

  void sendMessage({required String userMessage, String? contextSummary}) {
    // Cancel any existing streaming
    _streamSub?.cancel();

    // Build new messages list with user message and assistant placeholder
    final updated = List<ChatMessage>.from(state.messages)
      ..add(ChatMessage(role: ChatRole.user, text: userMessage))
      ..add(const ChatMessage(
          role: ChatRole.assistant, text: '', isStreaming: true));

    emit(state.copyWith(messages: updated, isStreaming: true, error: null));

    final response = _aiAssistantRepo.sendMessage(
      userMessage: userMessage,
      contextSummary: contextSummary,
    );

    response.fold(
      (failure) {
        // Mark last assistant message as not streaming and keep text as is
        final msgs = List<ChatMessage>.from(state.messages);
        final lastIdx =
            msgs.lastIndexWhere((m) => m.role == ChatRole.assistant);
        if (lastIdx != -1) {
          msgs[lastIdx] = msgs[lastIdx].copyWith(isStreaming: false);
        }
        emit(
            state.copyWith(messages: msgs, isStreaming: false, error: failure));
      },
      (stream) {
        _streamSub = stream.listen(
          (chunk) {
            final msgs = List<ChatMessage>.from(state.messages);
            final lastIdx =
                msgs.lastIndexWhere((m) => m.role == ChatRole.assistant);
            if (lastIdx != -1) {
              final current = msgs[lastIdx];
              msgs[lastIdx] = current.copyWith(
                  text: current.text + chunk, isStreaming: true);
              emit(state.copyWith(messages: msgs, isStreaming: true));
            }
          },
          onError: (e) {
            // If repository emits typed failures, use it; else wrap in ServerFailure
            final failure = e is Failure ? e : ServerFailure(e.toString());
            final msgs = List<ChatMessage>.from(state.messages);
            final lastIdx =
                msgs.lastIndexWhere((m) => m.role == ChatRole.assistant);
            if (lastIdx != -1) {
              msgs[lastIdx] = msgs[lastIdx].copyWith(isStreaming: false);
            }
            emit(state.copyWith(
                messages: msgs, isStreaming: false, error: failure));
          },
          onDone: () {
            final msgs = List<ChatMessage>.from(state.messages);
            final lastIdx =
                msgs.lastIndexWhere((m) => m.role == ChatRole.assistant);
            if (lastIdx != -1) {
              msgs[lastIdx] = msgs[lastIdx].copyWith(isStreaming: false);
            }
            emit(state.copyWith(messages: msgs, isStreaming: false));
          },
          
          cancelOnError: true,
        );
      },
    );
  }

  @override
  Future<void> close() async {
    await _streamSub?.cancel();
    return super.close();
  }
}
