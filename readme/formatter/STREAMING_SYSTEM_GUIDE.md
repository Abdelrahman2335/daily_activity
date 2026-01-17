# 🎬 Streaming Response System with Typing Animation

## Overview

This document describes the streaming response system for the AI Assistant chat interface, which provides real-time typing indicators and smooth text streaming animations.

## 🏗️ Architecture

### Components

```
┌─────────────────────────────────────────────────────────────┐
│                    Streaming System                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────┐    ┌──────────────┐   ┌──────────────┐  │
│  │  Gemini API  │───▶│  Formatter   │──▶│   UI Layer   │  │
│  │   Streaming  │    │ with States  │   │   + Widget   │  │
│  └──────────────┘    └──────────────┘   └──────────────┘  │
│         │                    │                   │          │
│         │                    │                   │          │
│     Raw chunks         State signals        Visual         │
│     with markdown      + Clean text         rendering      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Files

1. **`lib/core/utils/streaming_formatter.dart`**
   - Handles state signals (`[state:typing_start]`, `[state:typing_stop]`)
   - Formats markdown text
   - Manages streaming accumulation

2. **`lib/features/ai_assistant/presentation/views/widgets/typing_indicator.dart`**
   - Animated three-dot typing indicator
   - Gradient background matching AI message style

3. **`lib/features/ai_assistant/presentation/views/widgets/ai_assistant_view_body.dart`**
   - Displays messages and typing indicator
   - Manages streaming state

## 📡 State Signals

### Signal Protocol

```dart
[state:typing_start]   // Show typing indicator
[state:typing_stop]    // Hide typing indicator, start content
```

### Flow Example

```
Step 1: [state:typing_start]
        ↓
        UI shows: ● ● ●  (animated dots)

Step 2: [state:typing_stop]
        ↓
        UI hides dots, prepares for content

Step 3: "Core AI Enhancements..."
        ↓
        UI displays: Core AI Enhancements...
```

## 🎨 UI Components

### 1. Typing Indicator

**File**: `typing_indicator.dart`

**Visual**:
```
┌─────────────┐
│   ● ● ●     │  ← Animated dots (bouncing, fading)
└─────────────┘
   Gradient background (purple/blue)
```

**Features**:
- Three animated dots
- Smooth bounce and fade animation
- Matches AI message bubble style
- 1.5s animation loop

**Code Example**:
```dart
if (showTyping) {
  return const TypingIndicator();
}
```

### 2. Streaming Formatter

**File**: `streaming_formatter.dart`

**Usage**:
```dart
final accumulator = StreamingResponseAccumulator();

stream.listen((chunk) {
  final formatted = accumulator.addChunk(chunk);
  
  if (formatted != null) {
    // Update UI with formatted text
    updateMessage(formatted);
  }
  
  // Check state
  if (accumulator.currentState == StreamingState.typingStart) {
    showTypingIndicator();
  } else if (accumulator.currentState == StreamingState.typingStop) {
    hideTypingIndicator();
  }
});
```

## 🔄 Complete Flow

### Sequence Diagram

```
User                Flutter UI              Cubit               Gemini API
 │                      │                    │                      │
 │──Send Message────────▶                    │                      │
 │                      │                    │                      │
 │                      │──sendMessage()────▶│                      │
 │                      │                    │                      │
 │                      │                    │──HTTP Request───────▶│
 │                      │                    │                      │
 │                      │                    │◀─Chunk 1 ───────────│
 │                      │                    │  [state:typing_start]│
 │                      │                    │                      │
 │                      │◀─State Update──────│                      │
 │◀──Show ● ● ●────────│                    │                      │
 │                      │                    │                      │
 │                      │                    │◀─Chunk 2 ───────────│
 │                      │                    │  [state:typing_stop] │
 │                      │                    │                      │
 │                      │◀─State Update──────│                      │
 │◀──Hide ● ● ●────────│                    │                      │
 │                      │                    │                      │
 │                      │                    │◀─Chunk 3 ───────────│
 │                      │                    │  "Core AI..."        │
 │                      │                    │                      │
 │                      │◀─Text Update───────│                      │
 │◀──Display Text───────│                    │                      │
 │   "Core AI..."       │                    │                      │
 │                      │                    │                      │
 │                      │                    │◀─Chunk 4 ───────────│
 │                      │                    │  " Features:\n..."   │
 │                      │                    │                      │
 │                      │◀─Text Update───────│                      │
 │◀──Display Text───────│                    │                      │
 │   "Core AI Features" │                    │                      │
 │                      │                    │                      │
```

### Step-by-Step

1. **User sends message**
   ```dart
   onSend("What are AI enhancements?")
   ```

2. **UI adds user message**
   ```dart
   messages.add(ChatMessage(role: user, text: "What..."))
   ```

3. **UI adds empty AI message**
   ```dart
   messages.add(ChatMessage(role: assistant, text: "", isStreaming: true))
   ```

4. **Stream starts - Chunk 1: State signal**
   ```
   Input: "[state:typing_start]"
   Action: Show TypingIndicator()
   ```

5. **Chunk 2: State signal**
   ```
   Input: "[state:typing_stop]"
   Action: Hide TypingIndicator(), prepare for content
   ```

6. **Chunk 3+: Content**
   ```
   Input: "## Core AI Features:\n**1. Smart Tasks:**"
   Formatted: "Core AI Features:\n\n1. Smart Tasks:"
   Action: Display formatted text
   ```

7. **Stream completes**
   ```dart
   isStreaming = false
   ```

## 💻 Implementation Guide

### For Backend/API (Gemini Integration)

Your Gemini service should emit chunks in this order:

```dart
Stream<String> generateResponse() async* {
  // 1. Signal typing start
  yield '[state:typing_start]';
  
  // Small delay to show animation
  await Future.delayed(Duration(milliseconds: 500));
  
  // 2. Signal typing stop
  yield '[state:typing_stop]';
  
  // 3. Stream actual content
  yield '## Core AI Features:\n';
  yield '**1. Smart Tasks:**\n';
  yield '* Learning habits\n';
  // ... more content
}
```

### For Frontend (Flutter UI)

**Update Cubit to handle state signals**:

```dart
_streamSub = stream.listen(
  (chunk) {
    // Check for state signals
    if (chunk.trim() == '[state:typing_start]') {
      emit(state.copyWith(
        isTyping: true,
        isStreaming: true,
      ));
      return;
    }
    
    if (chunk.trim() == '[state:typing_stop]') {
      emit(state.copyWith(
        isTyping: false,
        isStreaming: true,
      ));
      return;
    }
    
    // Handle actual content
    final msgs = List<ChatMessage>.from(state.messages);
    final lastIdx = msgs.lastIndexWhere((m) => m.role == ChatRole.assistant);
    
    if (lastIdx != -1) {
      final current = msgs[lastIdx];
      msgs[lastIdx] = current.copyWith(
        text: current.text + chunk,
        isStreaming: true,
      );
      emit(state.copyWith(
        messages: msgs,
        isTyping: false,
        isStreaming: true,
      ));
    }
  },
);
```

**Update UI to show typing indicator**:

```dart
ListView.builder(
  itemCount: messages.length + (state.isTyping ? 1 : 0),
  itemBuilder: (context, index) {
    // Show typing indicator
    if (state.isTyping && index == messages.length) {
      return const TypingIndicator();
    }
    
    // Show messages
    final message = messages[index];
    return CustomChatCard(
      isUser: message.role == ChatRole.user,
      text: message.text,
    );
  },
)
```

## 🎭 Animation Details

### Typing Indicator Animation

```dart
AnimationController(
  duration: Duration(milliseconds: 1500),
  vsync: this,
)..repeat();

// Each dot has 0.2s delay
// Creates wave effect: ●  ●● ●●● ●● ●  (repeating)
```

**Phases**:
- **0.0 - 0.5**: Scale up + fade in
- **0.5 - 1.0**: Scale down + fade out
- **Delay**: 200ms between each dot

### Text Streaming Animation

For future enhancement, you can add character-by-character animation:

```dart
AnimatedTextKit(
  animatedTexts: [
    TypewriterAnimatedText(
      message.text,
      speed: Duration(milliseconds: 50),
    ),
  ],
)
```

## 🧪 Testing

### Manual Testing Checklist

- [ ] Typing indicator shows immediately after sending message
- [ ] Indicator animates smoothly (three dots bouncing)
- [ ] Indicator hides when content starts streaming
- [ ] Text appears in real-time as it streams
- [ ] Markdown is properly formatted
- [ ] No flicker when transitioning from indicator to text
- [ ] Multiple rapid messages work correctly
- [ ] Indicator matches AI message bubble style

### Test Scenarios

1. **Normal Flow**
   ```
   Send message → See ● ● ● → See text stream → Complete
   ```

2. **Fast Response**
   ```
   Send message → Brief ● ● ● → Immediate text
   ```

3. **Long Response**
   ```
   Send message → ● ● ● → Long streaming text → Complete
   ```

4. **Multiple Messages**
   ```
   Message 1 → ● ● ● → Text → Message 2 → ● ● ● → Text
   ```

## 📋 Best Practices

### 1. State Signal Timing

```dart
// ✅ GOOD: Small delay between signals
yield '[state:typing_start]';
await Future.delayed(Duration(milliseconds: 500));
yield '[state:typing_stop]';

// ❌ BAD: No delay, indicator won't be visible
yield '[state:typing_start]';
yield '[state:typing_stop]';
```

### 2. Error Handling

```dart
try {
  yield '[state:typing_start]';
  // ... API call
  yield '[state:typing_stop]';
  // ... content
} catch (e) {
  yield '[state:typing_stop]'; // Always stop typing on error
  throw e;
}
```

### 3. Cleanup

```dart
@override
Future<void> close() async {
  await _streamSub?.cancel();
  return super.close();
}
```

## 🔧 Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| Indicator doesn't show | State signal not emitted | Check Gemini service yields `[state:typing_start]` |
| Indicator stays visible | Missing `[state:typing_stop]` | Ensure signal is sent before content |
| Text not animating | Wrong state handling | Check cubit processes state signals correctly |
| Flickering | Rapid state changes | Add debouncing or minimum display time |
| Indicator wrong style | CSS/styling issue | Check TypingIndicator widget styling |

## 🚀 Future Enhancements

1. **Character-by-Character Animation**
   - Add typewriter effect for streamed text
   - Adjustable speed based on content length

2. **Sound Effects**
   - Typing sound during indicator
   - "ding" when message completes

3. **Advanced Indicators**
   - Different animations for different response types
   - Progress indicator for long responses

4. **Smart Timing**
   - Adjust typing indicator duration based on expected response length
   - Adaptive animation speed

## 📚 Related Documentation

- [Text Formatter Guide](../formatter/FORMATTER_QUICK_REFERENCE.md)
- [Chat Message Model](../../lib/features/ai_assistant/data/model/chat_message.dart)
- [AI Assistant Cubit](../../lib/features/ai_assistant/presentation/manager/cubit/ai_assistant_cubit.dart)

---

**Built with ❤️ for a smooth user experience**
