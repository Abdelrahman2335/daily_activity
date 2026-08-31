import 'package:flowi/core/utils/text_formatter.dart';

/// Example demonstrations of TextFormatter usage
void main() {
  print('=' * 80);
  print('TEXT FORMATTER EXAMPLES');
  print('=' * 80);
  print('');

  // Example 1: Basic Heading Format
  example1();

  // Example 2: Bold Text Removal
  example2();

  // Example 3: Bullet Points
  example3();

  // Example 4: Complex Mixed Content
  example4();

  // Example 5: Streaming Simulation
  example5();
}

void example1() {
  print('EXAMPLE 1: Basic Heading Format');
  print('-' * 40);

  const input = '## Core AI Enhancements and Features:';
  final output = TextFormatter.format(input);

  print('Input:');
  print('  "$input"');
  print('');
  print('Output:');
  print('  "$output"');
  print('');
}

void example2() {
  print('EXAMPLE 2: Bold Text Removal');
  print('-' * 40);

  const input = '**Smart Prioritization** and **Dynamic Scheduling**';
  final output = TextFormatter.format(input);

  print('Input:');
  print('  "$input"');
  print('');
  print('Output:');
  print('  "$output"');
  print('');
}

void example3() {
  print('EXAMPLE 3: Bullet Points Formatting');
  print('-' * 40);

  const input = '''* Learning your habits
* Dynamic prioritization
- First alternative item
- Second alternative item''';

  final output = TextFormatter.format(input);

  print('Input:');
  input.split('\n').forEach((line) => print('  "$line"'));
  print('');
  print('Output:');
  output.split('\n').forEach((line) => print('  "$line"'));
  print('');
}

void example4() {
  print('EXAMPLE 4: Complex Mixed Content');
  print('-' * 40);

  const input = '''## Core AI Enhancements and Features:

**1. Smart Prioritization & Scheduling:**
* **Learning Your Habits:** AI could observe when you typically complete certain types of tasks...
* **Dynamic Prioritization:** Instead of just "high/medium/low," AI could suggest...

**2. Natural Language Task Creation:**
* Just type what you want to do
* AI extracts details automatically''';

  final output = TextFormatter.format(input);

  print('Input:');
  print(input);
  print('');
  print('Output:');
  print(output);
  print('');
}

void example5() {
  print('EXAMPLE 5: Streaming Simulation');
  print('-' * 40);

  final accumulator = TextFormatter.createAccumulator();

  final chunks = [
    '## Features',
    '\n\n**1. ',
    'Smart Tasks:**',
    '\n* Learning',
    ' habits\n',
    '* Dynamic',
    ' prioritization',
  ];

  print('Simulating stream of ${chunks.length} chunks:');
  print('');

  for (var i = 0; i < chunks.length; i++) {
    final chunk = chunks[i];
    print('Chunk ${i + 1}: "${chunk.replaceAll('\n', '\\n')}"');

    final result = accumulator.add(chunk);
    print('Accumulated formatted result:');
    print('  "${result.replaceAll('\n', '\\n')}"');
    print('');
  }

  print('Final output:');
  print(accumulator.current);
  print('');
}
