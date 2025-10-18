# Text Formatter Quick Reference

## Import
```dart
import 'package:daily_activity/core/utils/text_formatter.dart';
```

## Basic Usage

### Format Complete Text
```dart
final cleaned = TextFormatter.format(rawMarkdown);
```

### Format Streaming Chunks
```dart
final accumulator = TextFormatter.createAccumulator();
stream.listen((chunk) {
  final formatted = accumulator.add(chunk);
  updateUI(formatted);
});
```

### Format Single Chunk
```dart
final cleaned = TextFormatter.formatChunk(partialChunk);
```

## Formatting Rules

| Input                | Output                  | Description           |
|---------------------|-------------------------|-----------------------|
| `## Heading`        | `Heading`               | Remove ## + spacing   |
| `**Bold**`          | `Bold`                  | Remove ** markers     |
| `* Bullet`          | `   Bullet`             | 3-space indent        |
| `- Item`            | `   Item`               | 3-space indent        |
| `\n\n\n\n`          | `\n\n`                  | Max 2 blank lines     |

## Integration Points

### Current Integration
- **Location**: `lib/features/ai_assistant/presentation/views/widgets/custom_chat_card.dart`
- **Line**: `final displayText = isUser ? text : TextFormatter.format(text);`
- **Effect**: All AI messages are automatically formatted

### Add to Other Widgets
```dart
// In any widget displaying Gemini responses
final formattedText = TextFormatter.format(rawText);
Text(formattedText);
```

## Testing

```bash
# Run all tests
flutter test test/text_formatter_test.dart

# Run examples
dart test/text_formatter_examples.dart
```

## Common Patterns

### Pattern 1: Format Before Display
```dart
Widget build(BuildContext context) {
  final displayText = TextFormatter.format(message.text);
  return Text(displayText);
}
```

### Pattern 2: Accumulate Stream
```dart
final accumulator = TextFormatter.createAccumulator();

void onNewChunk(String chunk) {
  setState(() {
    currentText = accumulator.add(chunk);
  });
}
```

### Pattern 3: Reset for New Message
```dart
void startNewMessage() {
  accumulator.clear();
}
```

## StreamingTextAccumulator API

```dart
// Create
final acc = TextFormatter.createAccumulator();

// Add chunk and get result
String result = acc.add(chunk);

// Get current formatted text
String current = acc.current;

// Get raw unformatted text
String raw = acc.raw;

// Clear/reset
acc.clear();
```

## Edge Cases Handled

✓ Empty input → Returns empty string
✓ No markdown → Returns text unchanged (just trimmed)
✓ Incomplete chunks → Processes only complete patterns
✓ Nested markdown → Handles properly (e.g., `**text** inside * bullet`)
✓ Mixed bullets → Both `*` and `-` work the same

## Performance

- **Time Complexity**: O(n) where n = text length
- **Space Complexity**: O(n) for result string
- **Streaming**: Minimal overhead per chunk
- **Suitable for**: Real-time chat, large responses, mobile devices

## Troubleshooting

### Issue: Text not formatting
**Solution**: Ensure markdown has complete patterns (e.g., both `**` for bold)

### Issue: Indentation missing
**Solution**: Check that bullets are at line start: `^[\s]*[\*\-]\s+`

### Issue: Streaming shows partial markdown
**Solution**: Use `StreamingTextAccumulator` instead of `formatChunk`

### Issue: Excessive spacing
**Solution**: This is intentional - headings get blank lines. Use `format()` not `formatChunk()`

## Documentation Files

- `lib/core/utils/TEXT_FORMATTER_README.md` - Full documentation
- `test/text_formatter_test.dart` - Test suite with examples
- `test/text_formatter_examples.dart` - 5 practical examples
- `FORMATTER_IMPLEMENTATION_SUMMARY.md` - Implementation details
- `FORMATTER_VISUAL_GUIDE.txt` - Visual before/after examples

## Support

For questions or issues, check the test files for examples or review the implementation in `lib/core/utils/text_formatter.dart`.
