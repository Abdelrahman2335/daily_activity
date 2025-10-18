part of 'ai_assistant_cubit.dart';

@immutable
class AiAssistantState {
  final List<ChatMessage> messages;
  final bool isStreaming;
  final Failure? error;

  const AiAssistantState({
    this.messages = const [],
    this.isStreaming = false,
    this.error,
  });

  AiAssistantState copyWith({
    List<ChatMessage>? messages,
    bool? isStreaming,
    Failure? error,
  }) {
    return AiAssistantState(
      messages: messages ?? this.messages,
      isStreaming: isStreaming ?? this.isStreaming,
      error: error,
    );
  }

  static AiAssistantState initial() => const AiAssistantState();
}
