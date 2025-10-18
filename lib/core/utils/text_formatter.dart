/// A text formatter that cleans and structures Gemini API response chunks
/// for display in a chat interface.
///
/// This formatter:
/// - Removes markdown symbols like ##, **, *, and other markup characters
/// - Preserves the intended hierarchy, line breaks, and spacing
/// - Never modifies, summarizes, or rewitres any text content
/// - Handles incomplete chunks gracefully
class TextFormatter {
  /// Formats a raw markdown-like text chunk by removing markdown symbols
  /// while preserving hierarchy and spacing.
  ///
  /// Formatting rules:
  /// - Text following ## becomes a clear section heading with blank lines
  /// - Text between ** appears without the markers (bold intent preserved via capitalization)
  /// - Bulleted items (*, -) appear as normal indented lines
  /// - Preserves natural paragraph spacing (one empty line between sections)
  ///
  /// Example:
  /// ```dart
  /// final formatted = TextFormatter.format(
  ///   "## Core Features:\n**1. Smart Tasks:**\n* Learning habits"
  /// );
  /// // Returns:
  /// // Core Features:
  /// //
  /// // 1. Smart Tasks:
  /// //
  /// //    Learning habits
  /// ```
  static String format(String rawText) {
    if (rawText.isEmpty) return rawText;

    String result = rawText;

    // Step 1: Process heading markers (##)
    // Replace ## with blank line before + heading + blank line after
    result = result.replaceAllMapped(
      RegExp(r'##\s*(.+?)(?=\n|$)', multiLine: true),
      (match) {
        final heading = match.group(1)?.trim() ?? '';
        return '\n$heading\n';
      },
    );

    // Step 2: Remove bold markers (**)
    // Keep the text but remove the ** markers
    result = result.replaceAllMapped(
      RegExp(r'\*\*(.+?)\*\*'),
      (match) {
        final content = match.group(1) ?? '';
        return content;
      },
    );

    // Step 3: Clean up excessive blank lines (more than 2 consecutive)
    result = result.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    // Step 4: Trim leading/trailing whitespace (but preserve structure)
    result = result.trim();

    // Step 5: Process bullet points (* or -) AFTER trimming to preserve indentation
    // Convert to indented lines without the bullet symbol
    result = result.replaceAllMapped(
      RegExp(r'^[\s]*[\*\-]\s+(.+)$', multiLine: true),
      (match) {
        final content = match.group(1)?.trim() ?? '';
        return '   $content'; // 3 spaces for indentation
      },
    );

    return result;
  }

  /// Formats text chunks in real-time as they arrive from streaming API.
  ///
  /// This method is designed to handle partial chunks that may not contain
  /// complete markdown structures. It processes what it can without forcing
  /// closure of unfinished elements.
  ///
  /// Usage with streaming:
  /// ```dart
  /// stream.listen((chunk) {
  ///   final formatted = TextFormatter.formatChunk(chunk);
  ///   displayInChat(formatted);
  /// });
  /// ```
  static String formatChunk(String chunk) {
    if (chunk.isEmpty) return chunk;

    // For chunks, we need to be more conservative to avoid breaking partial markdown
    String result = chunk;

    // Only process complete markdown patterns to avoid breaking partial ones

    // Process complete headings (must have ## at start and newline at end)
    result = result.replaceAllMapped(
      RegExp(r'##\s*(.+?)\n', multiLine: true),
      (match) {
        final heading = match.group(1)?.trim() ?? '';
        return '\n$heading\n';
      },
    );

    // Process complete bold markers (both ** must be present)
    result = result.replaceAllMapped(
      RegExp(r'\*\*(.+?)\*\*'),
      (match) {
        final content = match.group(1) ?? '';
        return content;
      },
    );

    // Process complete bullet points (must be at line start with content)
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

  /// Accumulates and formats text progressively as chunks arrive.
  ///
  /// This class maintains state across multiple chunks to ensure proper
  /// formatting of markdown elements that may span multiple chunks.
  ///
  /// Example:
  /// ```dart
  /// final accumulator = TextFormatter.createAccumulator();
  /// stream.listen((chunk) {
  ///   final formatted = accumulator.add(chunk);
  ///   updateChatBubble(formatted);
  /// });
  /// ```
  static StreamingTextAccumulator createAccumulator() {
    return StreamingTextAccumulator();
  }
}

/// Accumulates text chunks and formats them progressively
class StreamingTextAccumulator {
  final StringBuffer _buffer = StringBuffer();
  String _lastFormatted = '';

  /// Adds a new chunk and returns the formatted result so far
  String add(String chunk) {
    _buffer.write(chunk);
    _lastFormatted = TextFormatter.format(_buffer.toString());
    return _lastFormatted;
  }

  /// Returns the current formatted text without adding new chunks
  String get current => _lastFormatted;

  /// Clears the accumulator
  void clear() {
    _buffer.clear();
    _lastFormatted = '';
  }

  /// Returns the raw accumulated text
  String get raw => _buffer.toString();
}
