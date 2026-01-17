# Daily Activity - Task Management & To-Do App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.6.1-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.6.1-blue.svg)
![License](https://img.shields.io/badge/License-Private-red.svg)

A beautiful and intuitive task management application built with Flutter, featuring AI-powered assistance and smart task organization.

</div>

## 📑 Table of Contents

- [About](#-about)
- [Key Features](#-key-features)
- [Getting Started](#-getting-started)
- [Usage Guide](#-usage-guide)
- [Documentation](#-documentation)
- [Project Structure](#-project-structure)
- [Technology Stack](#-technology-stack)
- [Features in Detail](#-features-in-detail)
- [AI Assistant Architecture](#-ai-assistant-architecture)
- [Security](#-security)
- [Testing](#-testing)
- [Building](#-building)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [Roadmap](#-roadmap)
- [Known Issues](#-known-issues)
- [Support](#-support)

## 📱 About

Daily Activity is a modern Flutter-based task management application designed to help users organize their daily activities, projects, and tasks efficiently. The app features a clean, intuitive UI and integrates advanced AI capabilities powered by Google's Gemini 2.5 Flash API to provide intelligent, context-aware conversational assistance with full conversation history support.

### ✨ Key Features

- 📋 **Project Management** - Create and manage multiple projects with categories
- ✅ **Task Tracking** - Add, edit, and complete tasks with progress tracking
- 🤖 **AI Assistant** - Conversational AI powered by Gemini 2.5 Flash with:
  - Full conversation history and context retention
  - Real-time streaming responses
  - Formatted markdown output with code blocks
  - New conversation feature to reset chat history
- 📊 **Progress Visualization** - Visual progress indicators for projects
- 🎨 **Beautiful UI** - Modern, clean interface with smooth animations
- 🌙 **Dark Mode** - Support for light and dark themes
- 📅 **Date Management** - Calendar integration for task scheduling
- 💾 **Local Storage** - Offline-first with Hive database

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.6.1 or higher
- Dart SDK 3.6.1 or higher
- Android Studio / IntelliJ IDEA / VS Code with Flutter extensions
- A Google Gemini API key (for AI features)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Abdelrahman2335/daily_activity.git
   cd daily_activity
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   
   Create a `.env` file in the project root:
   ```bash
   # Windows PowerShell
   Copy-Item .env.example .env
   
   # Linux/macOS
   cp .env.example .env
   ```
   
   Then edit `.env` and add your Gemini API key:
   ```env
   GEMINI_API_KEY=your_actual_api_key_here
   ```
   
   **Get your API key:**
   - Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Sign in with your Google account
   - Create a new API key
   - Copy and paste it into your `.env` file

4. **Run the app**
   ```bash
   flutter run
   ```

### First Run

On first launch:
- The app will initialize Hive local database
- The Gemini service will validate your API key
- You'll see the welcome screen
- Navigate to the AI Assistant to start a conversation!

## 📖 Usage Guide

### Using the AI Assistant

1. **Starting a Conversation**
   - Navigate to the AI Assistant screen
   - Type your message in the input field
   - Press send and watch the AI respond in real-time

2. **Conversation Features**
   - The AI remembers all previous messages in the conversation
   - Ask follow-up questions that reference earlier context
   - Responses stream token-by-token for instant feedback
   - Markdown formatting is automatically applied

3. **Starting Fresh**
   - Tap the refresh icon (🔄) in the app bar
   - Confirm you want to start a new conversation
   - All messages will be cleared
   - The AI will start with a clean context

4. **Best Practices**
   - Be specific in your questions
   - Reference previous messages for context-aware answers
   - Use the AI for task suggestions, project ideas, and productivity tips
   - Start a new conversation when changing topics significantly

### Managing Projects

1. **Create a Project**
   - Tap the "+" button on the home screen
   - Enter project name, description, and category
   - Set start and end dates
   - Add tasks to the project

2. **Track Progress**
   - View progress bars on project cards
   - Complete tasks to update progress automatically
   - See completion percentages in real-time

3. **Edit & Delete**
   - Long-press on a project to edit
   - Swipe to delete projects
   - All tasks are preserved with the project

### App Settings

- Toggle dark mode from the settings screen
- Customize app preferences
- View app information and version

## 📚 Documentation

### Main Documentation
- **[Documentation Index](readme/README.md)** - Complete documentation hub
- **[AI Assistant Context Fix](readme/AI_ASSISTANT_CONTEXT_FIX.md)** - Conversation context implementation

### Text Formatter Documentation
- **[Formatter Implementation](readme/formatter/FORMATTER_IMPLEMENTATION_SUMMARY.md)** - Implementation details
- **[Formatter Quick Reference](readme/formatter/FORMATTER_QUICK_REFERENCE.md)** - Quick usage guide
- **[Formatter Visual Guide](readme/formatter/FORMATTER_VISUAL_GUIDE.txt)** - Before/after examples
- **[Streaming System Guide](readme/formatter/STREAMING_SYSTEM_GUIDE.md)** - Complete streaming response system
- **[Streaming Checklist](readme/formatter/STREAMING_IMPLEMENTATION_CHECKLIST.md)** - Implementation checklist

### Project Structure
- **[Restructuring Summary](readme/RESTRUCTURING_SUMMARY.md)** - Project organization details
- **[Folder Structure](readme/FOLDER_STRUCTURE.txt)** - Complete folder breakdown

## 🏗️ Project Structure

```
daily_activity/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── layout.dart               # Main layout structure
│   ├── core/                     # Core functionality
│   │   ├── adapters/            # Hive type adapters
│   │   │   ├── date_time_adapter.dart
│   │   │   └── icon_adapter.dart
│   │   ├── data/                # Constants and dummy data
│   │   ├── error/               # Error handling
│   │   │   ├── failure.dart
│   │   │   └── dio_failure.dart
│   │   ├── models/              # Data models
│   │   │   ├── project_model.dart
│   │   │   ├── task_model.dart
│   │   │   ├── project_category.dart
│   │   │   └── project_status.dart
│   │   ├── services/            # External services
│   │   │   └── gemini_service.dart  # Gemini API integration
│   │   ├── utils/               # Utilities and helpers
│   │   │   ├── app_router.dart      # Navigation routes
│   │   │   ├── constants.dart
│   │   │   ├── theme_manager.dart
│   │   │   ├── bloc_observer.dart
│   │   │   └── text_formatter.dart  # AI response formatter
│   │   └── widgets/             # Reusable widgets
│   └── features/                 # Feature modules
│       ├── ai_assistant/        # AI chat feature
│       │   ├── data/
│       │   │   ├── model/       # Chat message models
│       │   │   └── repository/  # AI repository
│       │   ├── domain/          # Business logic
│       │   └── presentation/    # UI layer
│       │       ├── manager/cubit/  # State management
│       │       └── views/       # UI screens & widgets
│       ├── home/                # Home screen
│       ├── project/             # Project management
│       ├── settings/            # App settings
│       └── welcome/             # Welcome screen
├── assets/                       # Images and resources
│   ├── images/
│   └── svg/
├── test/                         # Test files
├── readme/                       # Documentation
│   ├── AI_ASSISTANT_CONTEXT_FIX.md
│   ├── RESTRUCTURING_SUMMARY.md
│   └── formatter/               # Formatter docs
├── .env                         # Environment variables (not in git)
├── .env.example                 # Environment template
└── pubspec.yaml                 # Dependencies
```

## 🛠️ Technology Stack

### Core
- **Flutter SDK** - 3.6.1+ UI framework
- **Dart** - 3.6.1+ Programming language
- **Bloc/Cubit** - State management pattern

### State Management & Architecture
- `flutter_bloc` (^9.1.1) - State management
- `bloc` (^9.0.0) - Business logic component
- `dartz` (^0.10.1) - Functional programming utilities

### Data & Storage
- `hive` (^2.2.3) - Fast, NoSQL local database
- `hive_flutter` (^1.1.0) - Hive integration for Flutter
- Custom type adapters for complex models

### Networking & API
- `dio` (^5.9.0) - HTTP client for API requests
- `flutter_dotenv` (^6.0.0) - Environment variable management
- **Google Gemini 2.5 Flash API** - AI conversation backend

### Navigation
- `go_router` (^16.0.0) - Declarative routing

### UI & Design
- `iconsax` (^0.0.8) - Modern icon pack
- `phosphor_flutter` (^2.1.0) - Icon library
- `font_awesome_flutter` (^10.8.0) - Font Awesome icons
- `curved_navigation_bar` (^1.0.6) - Custom bottom navigation
- `percent_indicator` (^4.2.5) - Progress indicators
- `skeletonizer` (^2.1.0+1) - Loading skeleton UI
- `flutter_svg` (^2.2.1) - SVG rendering
- `flutter_animate` (^4.5.2) - Animation utilities
- `animated_text_kit` (^4.3.0) - Text animations
- `loading_animation_widget` (^1.3.0) - Loading animations

### Utilities
- `intl` (^0.20.2) - Internationalization and date formatting
- `uuid` (^4.5.1) - Unique ID generation

### Development Tools
- `build_runner` (^2.4.6) - Code generation
- `hive_generator` (^2.0.1) - Hive model generation
- `flutter_lints` (^5.0.0) - Linting rules
- `flutter_launcher_icons` (^0.14.4) - App icon generation

## 🎨 Features in Detail

### 1. Project Management
- Create projects with custom categories
- Set start and end dates
- Track project progress
- Add multiple tasks per project
- Color-coded categories

### 2. AI Assistant
- **Powered by Google Gemini 2.5 Flash API**
- **Conversational AI with Full Context**
  - Maintains complete conversation history across messages
  - Each message sent includes the entire conversation context
  - AI responds with full awareness of previous messages
  - Start fresh conversations with the "New Conversation" button
- **Real-time Streaming Responses**
  - Token-by-token streaming for instant feedback
  - Smooth, progressive text rendering
  - Optimized for responsiveness
- **Advanced Text Formatting**
  - Markdown support with proper rendering
  - Code blocks with syntax highlighting
  - Lists, headers, and emphasis formatting
  - Custom text formatter for clean output
- **Smart Features**
  - Natural language understanding
  - Context-aware task suggestions
  - Project recommendations
  - Maximum 300 tokens per response for concise answers

### 3. Task Organization
- Today's tasks view
- Task completion tracking
- Progress visualization
- Due date management
- Priority indicators

### 4. User Interface
- Clean, modern design
- Dark mode support
- Smooth animations
- Responsive layout
- Custom color themes

## 🧠 AI Assistant Architecture

The AI Assistant feature is built with a robust architecture that ensures conversation continuity and optimal performance:

### Conversation Context Management

```
User Message → Cubit → Repository → Gemini Service → Streaming Response
     ↓                                                        ↓
 Add to State.messages                            Update message chunks
     ↓                                                        ↓
 Include full history                             Emit state updates
     ↓                                                        ↓
 Send to API with context                        Render in UI
```

**Key Components:**

1. **ChatMessage Model**
   - `ChatRole`: user or assistant
   - `text`: message content
   - `isStreaming`: real-time status
   - `timestamp`: message time

2. **AiAssistantCubit** (State Management)
   - Maintains `List<ChatMessage>` in state
   - Adds user message + empty assistant placeholder
   - Passes entire conversation history to repository
   - Updates assistant message with streaming chunks
   - Handles errors and streaming completion

3. **AiAssistantRepoImpl** (Data Layer)
   - Builds `contents` array from conversation history
   - Formats messages for Gemini API (user/model roles)
   - Configures generation parameters (max tokens: 300)
   - Returns streaming response

4. **GeminiService** (API Layer)
   - Initializes with API key from `.env`
   - Uses Gemini 2.5 Flash model
   - Streams token-by-token responses
   - Handles network errors and timeouts

5. **Text Formatter**
   - Processes streaming markdown
   - Handles code blocks, lists, headers
   - Clean output rendering

### Conversation Features

- **Full Context Retention**: Every message includes complete chat history
- **New Conversation**: Reset button clears all messages
- **Error Handling**: Graceful failure with user-friendly messages
- **Streaming UI**: Progressive text rendering as tokens arrive
- **Optimized Tokens**: 300 token limit for concise, fast responses

## 🔒 Security

This app implements best practices for API key security:

- ✅ **Environment Variables** - API keys stored in `.env` file
- ✅ **Git Ignore** - `.env` file excluded from version control
- ✅ **No Hardcoding** - No sensitive data in source code
- ✅ **Initialization Check** - Validates API key on startup
- ✅ **Error Messages** - Clear guidance if key is missing
- ✅ **Template Provided** - `.env.example` for easy setup

**Security Best Practices:**

1. **Never commit your `.env` file** - It's in `.gitignore` for a reason
2. **Rotate API keys regularly** - Create new keys periodically
3. **Use different keys** - Separate keys for dev/prod environments
4. **Monitor usage** - Check Google AI Studio for API consumption
5. **Revoke compromised keys** - Immediately disable if exposed

**Important:** If you accidentally commit an API key, revoke it immediately in Google AI Studio and create a new one.

## 🧪 Testing

Run tests with:

```bash
# All tests
flutter test

# Specific test
flutter test test/text_formatter_test.dart

# With coverage
flutter test --coverage
```

## 📱 Building

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🔧 Troubleshooting

### Common Issues

**1. "GEMINI_API_KEY not found in .env file"**
- Solution: Create `.env` file from `.env.example` and add your API key
- Verify the file is in the project root directory
- Ensure the key is on a new line: `GEMINI_API_KEY=your_key_here`

**2. "AI Assistant not responding"**
- Check your internet connection
- Verify your API key is valid in [Google AI Studio](https://makersuite.google.com/app/apikey)
- Check if you've exceeded API quota
- Try resetting the conversation with the refresh button

**3. "Conversation context not working"**
- This has been fixed! Make sure you're on the latest version
- The AI now receives full conversation history with each message
- Use "New Conversation" button to reset context

**4. "Build errors after `flutter pub get`"**
- Run `flutter clean`
- Delete `pubspec.lock`
- Run `flutter pub get` again
- Run `flutter pub run build_runner build --delete-conflicting-outputs`

**5. "Hive database errors"**
- Clear app data
- Delete the Hive boxes: `Hive.deleteBoxFromDisk('mainBox')`
- Restart the app to reinitialize

**6. "Dark mode not switching"**
- Check Settings screen
- Ensure SettingCubit is properly initialized
- Restart the app

### Getting Help

- Check [Issues](https://github.com/Abdelrahman2335/daily_activity/issues) for similar problems
- Review documentation in `readme/` folder
- Create a new issue with:
  - Flutter version (`flutter --version`)
  - Error logs
  - Steps to reproduce

## 🤝 Contributing

This is a private project for learning purposes. If you'd like to contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📋 Roadmap

### Planned Features
- [ ] **Cloud Synchronization** - Sync data across devices
- [ ] **Collaborative Projects** - Share projects with team members
- [ ] **Recurring Tasks** - Auto-generate repeated tasks
- [ ] **Notifications & Reminders** - Task deadline alerts
- [ ] **Export/Import** - Backup and restore functionality
- [ ] **Advanced Analytics** - Productivity insights and charts
- [ ] **Voice Input** - Voice-to-text for tasks
- [ ] **Home Screen Widgets** - Quick access widgets
- [ ] **AI Project Generator** - Generate complete projects from prompts
- [ ] **Multi-language Support** - Internationalization
- [ ] **Task Templates** - Pre-built task collections

### Recently Completed ✅
- [x] Full conversation context in AI Assistant
- [x] Streaming responses with real-time updates
- [x] Text formatter for markdown rendering
- [x] New conversation feature
- [x] Dark mode support
- [x] Local data persistence with Hive

## 🐛 Known Issues

~~AI Assistant conversation context not working~~ ✅ **FIXED!** - Full conversation context now implemented.

See the [Issues](https://github.com/Abdelrahman2335/daily_activity/issues) section for current bugs and feature requests.

### Reporting Issues

When reporting a bug, please include:
- Flutter version (`flutter --version`)
- Device/Platform (Android, iOS, Web, etc.)
- Steps to reproduce
- Expected vs actual behavior
- Error logs if applicable
- Screenshots if relevant

## 📄 License

This project is private and for educational purposes.

## 👤 Author

**Abdelrahman**
- GitHub: [@Abdelrahman2335](https://github.com/Abdelrahman2335)

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing cross-platform framework
- **Google** - For the Gemini 2.5 Flash API and AI capabilities
- **Bloc Library Team** - For excellent state management solution
- **Hive Team** - For fast, lightweight local database
- **Open Source Community** - For all the incredible packages used in this project

### Special Thanks

This project uses many open-source packages. Special thanks to all contributors and maintainers of:
- `flutter_bloc`, `go_router`, `dio`, `hive`, `dartz`
- `iconsax`, `phosphor_flutter`, `font_awesome_flutter`
- `percent_indicator`, `skeletonizer`, `loading_animation_widget`
- And many more listed in `pubspec.yaml`

## 📞 Support

### Getting Help

- 📖 **Documentation**: Check the `readme/` folder for comprehensive guides
- 🐛 **Bug Reports**: [Open an issue](https://github.com/Abdelrahman2335/daily_activity/issues/new) on GitHub
- 💡 **Feature Requests**: [Submit a feature request](https://github.com/Abdelrahman2335/daily_activity/issues/new)
- ❓ **Questions**: Review existing [issues](https://github.com/Abdelrahman2335/daily_activity/issues) or open a new one

### Useful Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Gemini API Documentation](https://ai.google.dev/docs)
- [Bloc Library Documentation](https://bloclibrary.dev/)
- [Hive Documentation](https://docs.hivedb.dev/)

### Quick Links

- [Main Documentation](readme/README.md)
- [AI Assistant Context Fix](readme/AI_ASSISTANT_CONTEXT_FIX.md)
- [Text Formatter Guide](readme/formatter/)
- [Troubleshooting](#-troubleshooting)

---

<div align="center">

**Built with ❤️ using Flutter**

[Documentation](readme/) • [Report Bug](../../issues)

</div>
