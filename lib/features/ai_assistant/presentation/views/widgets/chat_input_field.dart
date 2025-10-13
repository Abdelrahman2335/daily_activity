
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextField(
        onTapUpOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {},
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
          hintText: "Ask me to create a new project",
        ),
        maxLines: 1,
        maxLength: 400,
      ),
    );
  }
}
