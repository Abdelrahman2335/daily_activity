import 'package:daily_activity/features/ai_assistant/presentation/manager/cubit/ai_assistant_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({
    super.key,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  late TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextField(
        controller: _textController,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              if (_textController.text != "") {
                context
                    .read<AiAssistantCubit>()
                    .sendMessage(userMessage: _textController.text);
                _textController.clear();
              }
            },
            icon: Icon(Iconsax.send_1),
          ),
          counterText: "", // Hides the character counter
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 21, vertical: 22),
          fillColor: Theme.of(context).colorScheme.surface,
          filled: true,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(19),
            borderSide: BorderSide.none,
          ),
          hintText: "Ask anything",
        ),
        minLines: 1,
        maxLines: 5,
        maxLength: 400,
      ),
    );
  }
}
