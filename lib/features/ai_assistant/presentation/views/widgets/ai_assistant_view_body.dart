import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/features/ai_assistant/presentation/manager/cubit/ai_assistant_cubit.dart';
import 'package:daily_activity/features/ai_assistant/presentation/views/widgets/chat_input_field.dart';
import 'package:daily_activity/features/ai_assistant/presentation/views/widgets/custom_chat_card.dart';
import 'package:daily_activity/features/ai_assistant/presentation/views/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:daily_activity/features/ai_assistant/domain/models/chat_message.dart';

class AiAssistantViewBody extends StatefulWidget {
  const AiAssistantViewBody({super.key});

  @override
  State<AiAssistantViewBody> createState() => _AiAssistantViewBodyState();
}

class _AiAssistantViewBodyState extends State<AiAssistantViewBody> {
  late final ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose;
    super.dispose();
  }

  // Scroll down by a specific amount (e.g., 200 pixels)
  void _scrollDown({double pixels = 200.0}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_controller.hasClients) return;
      final currentPosition = _controller.position.pixels;
      final maxScroll = _controller.position.maxScrollExtent;
      final targetPosition = (currentPosition + pixels).clamp(0.0, maxScroll);

      _controller.animateTo(
        targetPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AiAssistantCubit, AiAssistantState>(
      listener: (context, state) {
        // scroll when new message arrives (user or AI)
        if (state.messages.isNotEmpty) {
          _scrollDown(); // Scroll down just a bit instead of all the way
          // Or use: _scrollToBottom(); to scroll all the way to bottom
        }
      },
      builder: (context, state) {
        if (!state.messages.isNotEmpty) {
          return Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Let's build something together!",
                  style: AppTextStyles.textStyle16,
                ),
              ),
              const ChatInputField(),
            ],
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: ListView.builder(
                    controller: _controller,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      return message.isStreaming
                          ? const LoadingIndicator()
                          : CustomChatCard(
                              isUser: message.role == ChatRole.user,
                              text: message.text,
                            );
                    },
                  ),
                ),
              ),
              if (state.isStreaming) const SizedBox(height: 8),
              const ChatInputField(),
            ],
          );
        }
      },
    );
  }
}
