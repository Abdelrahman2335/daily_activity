# Text Formatter

A utility for cleaning and formatting Gemini API response chunks for display in chat interfaces.

## Overview

The `TextFormatter` class removes markdown symbols while preserving text hierarchy, line breaks, and spacing. It's designed to make AI assistant responses more readable in chat bubbles without modifying the actual content.

## Features

- ✅ Removes markdown formatting (`##`, `**`, `*`, `-`)
- ✅ Preserves content hierarchy and structure
- ✅ Handles streaming responses (partial chunks)
- ✅ Never modifies or summarizes text content
- ✅ Maintains proper indentation and spacing

## Usage

### Basic Formatting

Format complete markdown text:

```dart
import 'package:daily_activity/core/utils/text_formatter.dart';

final rawText = '''## Core AI Features:
**1. Smart Tasks:**
* Learning your habits
* Dynamic prioritization''';

final formatted = TextFormatter.format(rawText);
print(formatted);
```

**Output:**
```
Core AI Features:

1. Smart Tasks:

   Learning your habits
   Dynamic prioritization
```

### Streaming Chunks

For real-time streaming responses, use the `StreamingTextAccumulator`:

```dart
final accumulator = TextFormatter.createAccumulator();

stream.listen((chunk) {
  final formatted = accumulator.add(chunk);
  updateChatBubble(formatted);
});
```

### Single Chunk Formatting

Format individual chunks (useful for incomplete markdown):

```dart
final chunk = '## Heading\n';
final formatted = TextFormatter.formatChunk(chunk);
```

## Formatting Rules

| Markdown | Input Example | Output |
|----------|---------------|--------|
| **Heading** | `## Section Title` | `Section Title` (with spacing) |
| **Bold** | `**important**` | `important` |
| **Bullet** | `* Item text` | `   Item text` (3-space indent) |
| **Dash** | `- Item text` | `   Item text` (3-space indent) |

## Integration

The formatter is integrated into the chat interface via `CustomChatCard`:

```dart
// In custom_chat_card.dart
final displayText = isUser ? text : TextFormatter.format(text);
```

This automatically formats all AI assistant messages while leaving user messages unchanged.

## Examples

### Example 1: Complex Response

**Input:**
```markdown
## Smart Prioritization & Scheduling:

**Learning Your Habits:**
* AI observes completion patterns
* Suggests optimal task timing

**Dynamic Prioritization:**
* Context-aware importance ranking
* Automatic schedule adjustments
```

**Output:**
```
Smart Prioritization & Scheduling:

Learning Your Habits:

   AI observes completion patterns
   Suggests optimal task timing

Dynamic Prioritization:

   Context-aware importance ranking
   Automatic schedule adjustments
```

### Example 2: Streaming Response

```dart
final accumulator = TextFormatter.createAccumulator();

// Chunk 1: "## Features\n"
accumulator.add("## Features\n");
// Result: "Features\n"

// Chunk 2: "**1. Smart**"
accumulator.add("**1. Smart**");
// Result: "Features\n\n1. Smart"

// Chunk 3: " Tasks:**\n"
accumulator.add(" Tasks:**\n");
// Result: "Features\n\n1. Smart Tasks:\n"

// Chunk 4: "* Learning\n"
accumulator.add("* Learning\n");
// Final Result includes proper indentation
```

## API Reference

### `TextFormatter.format(String rawText)`
Formats complete markdown text. Best for non-streaming responses.

### `TextFormatter.formatChunk(String chunk)`
Formats partial chunks conservatively. Only processes complete markdown patterns.

### `TextFormatter.createAccumulator()`
Creates a `StreamingTextAccumulator` for progressive formatting.

### `StreamingTextAccumulator`

Methods:
- `add(String chunk)` - Adds chunk and returns formatted result
- `get current` - Returns current formatted text
- `get raw` - Returns raw accumulated text
- `clear()` - Resets the accumulator

## Testing

Run the test suite:

```bash
flutter test test/text_formatter_test.dart
```

## Notes

- The formatter **never** modifies or summarizes content
- It only removes markdown symbols and adjusts spacing
- Incomplete chunks are handled gracefully (no forced closures)
- Excessive blank lines (3+) are reduced to 2
