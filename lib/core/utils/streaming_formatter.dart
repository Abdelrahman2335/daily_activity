/// Enhanced text formatter with state signals for streaming chat UI.
///
/// This formatter handles:
/// - State signals for typing animation control
/// - Markdown removal while preserving structure
/// - Real-time streaming with typing indicators
class StreamingFormatter {
  // State signal constants
  static const String typingStart = '[state:typing_start]';
  static const String typingStop = '[state:typing_stop]';

  /// Checks if text contains a state signal
  static bool isStateSignal(String text) {
    return text.trim() == typingStart || text.trim() == typingStop;
  }

  /// Extracts state from signal
  static StreamingState? parseState(String text) {
    final trimmed = text.trim();
    if (trimmed == typingStart) return StreamingState.typingStart;
    if (trimmed == typingStop) return StreamingState.typingStop;
    return null;
  }

  /// Removes state signals from text
  static String removeStateSignals(String text) {
    return text.replaceAll(typingStart, '').replaceAll(typingStop, '').trim();
  }

  /// Formats a chunk while preserving state signals
  static String formatChunkWithStates(String chunk) {
    // Don't format state signals
    if (isStateSignal(chunk)) return chunk;

    // Check if chunk contains state signals
    if (chunk.contains(typingStart) || chunk.contains(typingStop)) {
      // Split by state signals and format parts
      final parts = <String>[];
      var remaining = chunk;

      while (remaining.isNotEmpty) {
        final startIdx = remaining.indexOf('[state:');
        if (startIdx == -1) {
          // No more state signals, format the rest
          if (remaining.trim().isNotEmpty) {
            parts.add(_formatText(remaining));
          }
          break;
        }

        // Add text before signal
        if (startIdx > 0) {
          final before = remaining.substring(0, startIdx);
          if (before.trim().isNotEmpty) {
            parts.add(_formatText(before));
          }
        }

        // Find end of state signal
        final endIdx = remaining.indexOf(']', startIdx);
        if (endIdx != -1) {
          // Add the state signal unchanged
          parts.add(remaining.substring(startIdx, endIdx + 1));
          remaining = remaining.substring(endIdx + 1);
        } else {
          break;
        }
      }

      return parts.join('');
    }

    // No state signals, format normally
    return _formatText(chunk);
  }

  /// Internal text formatting without state signal handling
  static String _formatText(String text) {
    if (text.isEmpty) return text;

    String result = text;

    // Process complete headings
    result = result.replaceAllMapped(
      RegExp(r'##\s*(.+?)\n', multiLine: true),
      (match) {
        final heading = match.group(1)?.trim() ?? '';
        return '\n$heading\n';
      },
    );

    // Remove bold markers
    result = result.replaceAllMapped(
      RegExp(r'\*\*(.+?)\*\*'),
      (match) {
        final content = match.group(1) ?? '';
        return content;
      },
    );

    // Process bullet points
    result = result.replaceAllMapped(
      RegExp(r'^[\s]*[\*\-]\s+(.+)$', multiLine: true),
      (match) {
        final content = match.group(1)?.trim() ?? '';
        return '   $content';
      },
    );

    // Clean excessive blank lines
    result = result.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return result;
  }
}

/// Streaming state enum
enum StreamingState {
  typingStart,
  typingStop,
  content,
}

/// Accumulator for streaming responses with state management
class StreamingResponseAccumulator {
  final StringBuffer _buffer = StringBuffer();
  String _lastFormatted = '';
  StreamingState _currentState = StreamingState.content;
  bool _hasReceivedContent = false;

  /// Current streaming state
  StreamingState get currentState => _currentState;

  /// Whether content has started streaming
  bool get hasReceivedContent => _hasReceivedContent;

  /// Add a chunk and return the formatted result
  /// Returns null if the chunk was just a state signal
  String? addChunk(String chunk) {
    if (chunk.isEmpty) return null;

    // Check for state signals
    final state = StreamingFormatter.parseState(chunk);
    if (state != null) {
      _currentState = state;
      if (state == StreamingState.typingStop) {
        _hasReceivedContent = true;
      }
      return null; // State signals don't return text
    }

    // Add to buffer and format
    _buffer.write(chunk);
    final fullText = _buffer.toString();

    // Remove any state signals from the full text
    final cleanText = StreamingFormatter.removeStateSignals(fullText);

    // Format the clean text
    _lastFormatted = StreamingFormatter._formatText(cleanText);

    return _lastFormatted;
  }

  /// Get current formatted text
  String get current => _lastFormatted;

  /// Get raw accumulated text
  String get raw => _buffer.toString();

  /// Clear the accumulator
  void clear() {
    _buffer.clear();
    _lastFormatted = '';
    _currentState = StreamingState.content;
    _hasReceivedContent = false;
  }

  /// Reset for new message
  void reset() {
    clear();
  }
}

/// Extension for easy state checking
extension StreamingStateExtension on StreamingState {
  bool get isTyping => this == StreamingState.typingStart;
  bool get isContent =>
      this == StreamingState.content || this == StreamingState.typingStop;
}
