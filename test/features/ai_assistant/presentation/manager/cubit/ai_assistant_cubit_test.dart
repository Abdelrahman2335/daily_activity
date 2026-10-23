import 'package:bloc_test/bloc_test.dart';
import 'package:flowi/core/error/failure.dart';
import 'package:flowi/features/ai_assistant/presentation/manager/cubit/ai_assistant_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('initial state is empty and not streaming', () {
    final cubit = AiAssistantCubit();
    expect(cubit.state.messages, isEmpty);
    expect(cubit.state.isStreaming, isFalse);
    expect(cubit.state.error, isNull);
    cubit.close();
  });

  blocTest<AiAssistantCubit, AiAssistantState>(
    'sendMessage emits optimistic streaming state then failure when service is uninitialized',
    build: () => AiAssistantCubit(),
    act: (cubit) => cubit.sendMessage(userMessage: 'hello'),
    wait: const Duration(milliseconds: 20),
    expect: () => [
      isA<AiAssistantState>()
          .having((s) => s.isStreaming, 'isStreaming', true)
          .having((s) => s.messages.length, 'message count', 2)
          .having((s) => s.error, 'error', isNull),
      isA<AiAssistantState>()
          .having((s) => s.isStreaming, 'isStreaming', false)
          .having((s) => s.messages.length, 'message count', 2)
          .having((s) => s.error, 'error type', isA<Failure>()),
    ],
  );

  blocTest<AiAssistantCubit, AiAssistantState>(
    'clearMessages resets conversation state',
    build: () => AiAssistantCubit(),
    act: (cubit) => cubit.clearMessages(),
    expect: () => [
      isA<AiAssistantState>()
          .having((s) => s.messages.isEmpty, 'messages empty', true)
          .having((s) => s.isStreaming, 'isStreaming', false),
    ],
  );

  blocTest<AiAssistantCubit, AiAssistantState>(
    'resetConversation clears state',
    build: () => AiAssistantCubit(),
    act: (cubit) => cubit.resetConversation(),
    expect: () => [
      isA<AiAssistantState>()
          .having((s) => s.messages.isEmpty, 'messages empty', true)
          .having((s) => s.isStreaming, 'isStreaming', false),
    ],
  );
}
