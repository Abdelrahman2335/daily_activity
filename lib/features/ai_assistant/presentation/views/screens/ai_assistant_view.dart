import 'package:daily_activity/features/ai_assistant/presentation/views/widgets/ai_assistant_view_body.dart';
import 'package:flutter/material.dart';

class AiAssistantView extends StatelessWidget {
  const AiAssistantView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const AiAssistantViewBody(),
    );
  }
}
