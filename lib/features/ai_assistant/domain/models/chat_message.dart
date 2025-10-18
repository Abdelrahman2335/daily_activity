enum ChatRole { user, assistant }

class ChatMessage {
  final ChatRole role;
  final String text;
  final bool isStreaming;

  const ChatMessage({
    required this.role,
    required this.text,
    this.isStreaming = false,
  });

  ChatMessage copyWith({ChatRole? role, String? text, bool? isStreaming}) {
    return ChatMessage(
      role: role ?? this.role,
      text: text ?? this.text,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }
}
