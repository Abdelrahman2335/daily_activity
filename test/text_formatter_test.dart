import 'package:daily_activity/core/utils/text_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextFormatter', () {
    test('formats headings correctly', () {
      const input = '## Core AI Enhancements and Features:';
      final result = TextFormatter.format(input);

      expect(result, contains('Core AI Enhancements and Features:'));
      expect(result, isNot(contains('##')));
    });

    test('removes bold markers', () {
      const input = '**Smart Prioritization**';
      final result = TextFormatter.format(input);

      expect(result, 'Smart Prioritization');
      expect(result, isNot(contains('**')));
    });

    test('formats bullet points with indentation', () {
      const input = '* Learning Your Habits: AI could observe';
      final result = TextFormatter.format(input);

      expect(result, contains('   Learning Your Habits: AI could observe'));
      expect(result, isNot(contains('*')));
    });

    test('formats complex markdown example', () {
      const input = '''## Core AI Enhancements and Features:

**1. Smart Prioritization & Scheduling:**
* **Learning Your Habits:** AI could observe when you typically complete certain types of tasks...
* **Dynamic Prioritization:** Instead of just "high/medium/low," AI could suggest...''';

      final result = TextFormatter.format(input);

      // Check that markdown is removed
      expect(result, isNot(contains('##')));
      expect(result, isNot(contains('**')));
      expect(result, isNot(contains('* ')));

      // Check that content is preserved
      expect(result, contains('Core AI Enhancements and Features:'));
      expect(result, contains('1. Smart Prioritization & Scheduling:'));
      expect(result, contains('Learning Your Habits:'));
      expect(result, contains('Dynamic Prioritization:'));
    });

    test('formats hyphen bullets', () {
      const input = '- First item\n- Second item';
      final result = TextFormatter.format(input);

      expect(result, contains('   First item'));
      expect(result, contains('   Second item'));
      expect(result, isNot(contains('-')));
    });

    test('handles empty input', () {
      const input = '';
      final result = TextFormatter.format(input);

      expect(result, isEmpty);
    });

    test('cleans excessive blank lines', () {
      const input = 'Line 1\n\n\n\n\nLine 2';
      final result = TextFormatter.format(input);

      expect(result, 'Line 1\n\nLine 2');
    });

    test('formatChunk handles incomplete markdown', () {
      const chunk = '## Start of heading';
      final result = TextFormatter.formatChunk(chunk);

      // Should not format incomplete heading
      expect(result, contains('##'));
    });

    test('formatChunk handles complete markdown', () {
      const chunk = '## Complete Heading\nSome text';
      final result = TextFormatter.formatChunk(chunk);

      expect(result, isNot(contains('##')));
      expect(result, contains('Complete Heading'));
    });
  });

  group('StreamingTextAccumulator', () {
    test('accumulates and formats progressively', () {
      final accumulator = TextFormatter.createAccumulator();

      accumulator.add('## ');
      accumulator.add('Heading\n');
      final result = accumulator.add('**Bold text**');

      expect(result, contains('Heading'));
      expect(result, contains('Bold text'));
      expect(result, isNot(contains('##')));
      expect(result, isNot(contains('**')));
    });

    test('maintains state across chunks', () {
      final accumulator = TextFormatter.createAccumulator();

      accumulator.add('First chunk ');
      accumulator.add('second chunk');

      expect(accumulator.current, 'First chunk second chunk');
    });

    test('clear resets accumulator', () {
      final accumulator = TextFormatter.createAccumulator();

      accumulator.add('Some text');
      accumulator.clear();

      expect(accumulator.current, isEmpty);
      expect(accumulator.raw, isEmpty);
    });

    test('handles real-time streaming scenario', () {
      final accumulator = TextFormatter.createAccumulator();

      // Simulate streaming chunks
      final chunks = [
        '## Core Features',
        '\n\n**1. Smart',
        ' Tasks:**\n',
        '* Learning',
        ' habits\n',
        '* Dynamic prioritization',
      ];

      String lastResult = '';
      for (var chunk in chunks) {
        lastResult = accumulator.add(chunk);
      }

      // Final result should be properly formatted
      expect(lastResult, contains('Core Features'));
      expect(lastResult, contains('1. Smart Tasks:'));
      expect(lastResult, contains('   Learning habits'));
      expect(lastResult, contains('   Dynamic prioritization'));
      expect(lastResult, isNot(contains('##')));
      expect(lastResult, isNot(contains('**')));
    });
  });

  group('Full Example Tests', () {
    test('formats complete example from requirements', () {
      const input = '''## Core AI Enhancements and Features:

**1. Smart Prioritization & Scheduling:**
* **Learning Your Habits:** AI could observe when you typically complete certain types of tasks...
* **Dynamic Prioritization:** Instead of just "high/medium/low," AI could suggest...''';

      final result = TextFormatter.format(input);

      // Split into lines for detailed checking
      final lines = result.split('\n');

      // Should have heading with spacing
      expect(lines[0], 'Core AI Enhancements and Features:');

      // Should have bold text without markers
      expect(result, contains('1. Smart Prioritization & Scheduling:'));

      // Should have indented bullet points
      expect(result, contains('   Learning Your Habits:'));
      expect(result, contains('   Dynamic Prioritization:'));

      // Content should be preserved
      expect(
          result,
          contains(
              'AI could observe when you typically complete certain types of tasks'));
      expect(result,
          contains('Instead of just "high/medium/low," AI could suggest'));
    });

    test('preserves natural paragraph spacing', () {
      const input = '''## Section 1

Some content here.

## Section 2

More content.''';

      final result = TextFormatter.format(input);

      // Should have proper spacing between sections
      expect(result.contains('Section 1\n\nSome content here'), isTrue);
      expect(result.contains('Section 2\n\nMore content'), isTrue);
    });
  });
}
