import 'package:daily_activity/features/ai_assistant/presentation/views/widgets/chat_input_field.dart';
import 'package:daily_activity/features/ai_assistant/presentation/views/widgets/custom_chat_card.dart';
import 'package:flutter/material.dart';

class AiAssistantViewBody extends StatefulWidget {
  const AiAssistantViewBody({super.key});

  @override
  State<AiAssistantViewBody> createState() => _AiAssistantViewBodyState();
}

class _AiAssistantViewBodyState extends State<AiAssistantViewBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomChatCard(
          isUser: true,
          text: "Hi there",
        ),
        const CustomChatCard(isUser: true, text: "This is a test message"),
        const CustomChatCard(
          isUser: false,
          text:
              "Hi! I'm your AI assistant. I can help you create projects, manage tasks, and organize your workflow. What would you like to work on today?",
        ),
        const ChatInputField(),
      ],
    );
  }
}
