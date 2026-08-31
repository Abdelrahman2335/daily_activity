import 'package:flowi/features/ai_assistant/presentation/views/widgets/ai_assistant_view_body.dart';
import 'package:flutter/material.dart';

// import '../widgets/ai_app_bar.dart';

class AiAssistantView extends StatelessWidget {
  const AiAssistantView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AiAppBar(),
      body: const AiAssistantViewBody(),
    );
  }
}
