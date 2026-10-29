import 'package:flowi/core/error/dio_failure.dart';
import 'package:flowi/features/ai_assistant/presentation/manager/cubit/ai_assistant_cubit.dart';
import 'package:flowi/features/ai_assistant/presentation/views/widgets/ai_assistant_view_body.dart';
import 'package:flowi/features/ai_assistant/presentation/views/widgets/chat_input_field.dart';
import 'package:flowi/features/ai_assistant/presentation/views/widgets/custom_chat_card.dart';
import 'package:flowi/features/ai_assistant/presentation/views/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fakes.dart';
import 'support/widget_test_harness.dart';

void main() {
  setUpAll(() async {
    registerTestFallbacks();
    await TestFonts.load();
  });

  Widget buildAi(AiAssistantState state) {
    return BlocProvider<AiAssistantCubit>(
      create: (_) {
        final cubit = SeedableAiCubit();
        cubit.seed(state);
        return cubit;
      },
      child: const Scaffold(body: AiAssistantViewBody()),
    );
  }

  group('AiAssistantViewBody', () {
    testWidgets('empty state renders prompt copy and input field',
        (tester) async {
      await pumpScreen(tester, buildAi(const AiAssistantState()));

      expect(
        find.text("Let's build something together!"),
        findsOneWidget,
      );
      expect(find.byType(ChatInputField), findsOneWidget);
    });

    testWidgets('populated state renders user and assistant chat cards',
        (tester) async {
      await pumpScreen(
        tester,
        buildAi(AiAssistantState(messages: conversation())),
        settle: false,
      );
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CustomChatCard), findsNWidgets(2));
      expect(find.text('How am I doing this week?'), findsOneWidget);
      expect(
        find.textContaining('Here is what I found'),
        findsOneWidget,
      );
    });

    testWidgets('streaming message renders LoadingIndicator wave dots',
        (tester) async {
      await pumpScreen(
        tester,
        buildAi(
          AiAssistantState(
            messages: conversation(assistantText: '', streaming: true),
            isStreaming: true,
          ),
        ),
        settle: false,
      );

      expect(find.byType(LoadingIndicator), findsOneWidget);
    });

    testWidgets(
        'error state is silently ignored and renders no error message or retry (known defect)',
        (tester) async {
      await pumpScreen(
        tester,
        buildAi(
          AiAssistantState(
            messages: conversation(assistantText: ''),
            error: ServerFailure('network is down'),
          ),
        ),
        settle: false,
      );

      expect(find.textContaining('network is down'), findsNothing);
      expect(find.textContaining('Retry'), findsNothing);
    });

    testWidgets('survives the 8-point visual matrix in empty and populated states',
        (tester) async {
      await expectNoLayoutDefects(tester, buildAi(const AiAssistantState()));
      await expectNoLayoutDefects(
        tester,
        buildAi(AiAssistantState(messages: conversation())),
        settle: false,
      );
    });
  });
}
