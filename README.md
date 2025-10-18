# Daily Activity - Task Management & To-Do App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.6.1-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.6.1-blue.svg)
![License](https://img.shields.io/badge/License-Private-red.svg)

A beautiful and intuitive task management application built with Flutter, featuring AI-powered assistance and smart task organization.

</div>

## 📱 About

Daily Activity is a modern Flutter-based task management application designed to help users organize their daily activities, projects, and tasks efficiently. The app features a clean, intuitive UI and integrates AI capabilities powered by Google's Gemini API to provide intelligent task suggestions and assistance.

### ✨ Key Features

- 📋 **Project Management** - Create and manage multiple projects with categories
- ✅ **Task Tracking** - Add, edit, and complete tasks with progress tracking
- 🤖 **AI Assistant** - Get intelligent suggestions from Gemini AI
- 📊 **Progress Visualization** - Visual progress indicators for projects
- 🎨 **Beautiful UI** - Modern, clean interface with smooth animations
- 🌙 **Dark Mode** - Support for light and dark themes
- 📅 **Date Management** - Calendar integration for task scheduling
- 💾 **Local Storage** - Offline-first with Hive database

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.6.1 or higher
- Dart SDK 3.6.1 or higher
- Android Studio / VS Code
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
   ```bash
   cp .env.example .env
   ```
   Then edit `.env` and add your Gemini API key:
   ```env
   GEMINI_API_KEY=your_api_key_here
   ```
   
   Get your API key from [Google AI Studio](https://makersuite.google.com/app/apikey).

4. **Run the app**
   ```bash
   flutter run
   ```

## 📚 Documentation

### ✍️ Text Formatter

- **[Formatter Implementation](formatter/FORMATTER_IMPLEMENTATION_SUMMARY.md)** - Implementation details
- **[Formatter Quick Reference](formatter/FORMATTER_QUICK_REFERENCE.md)** - Quick usage guide
- **[Formatter Visual Guide](formatter/FORMATTER_VISUAL_GUIDE.txt)** - Before/after examples

## 🏗️ Project Structure

```
daily_activity/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── layout.dart               # Main layout structure
│   ├── core/                     # Core functionality
│   │   ├── adapters/            # Hive type adapters
│   │   ├── data/                # Dummy data and constants
│   │   ├── error/               # Error handling
│   │   ├── models/              # Data models
│   │   ├── services/            # API services (Gemini)
│   │   ├── utils/               # Utilities and helpers
│   │   └── widgets/             # Reusable widgets
│   └── features/                 # Feature modules
│       ├── ai_assistant/        # AI chat feature
│       ├── home/                # Home screen
│       ├── project/             # Project management
│       ├── settings/            # App settings
│       ├── today_tasks/         # Today's tasks view
│       └── welcome/             # Welcome screen
├── assets/                       # Images and resources
│   ├── images/
│   └── svg/
├── test/                         # Test files
├── readme/                       # Documentation
│   └── formatter/               # Formatter docs
├── .env                         # Environment variables (not in git)
├── .env.example                 # Environment template
└── pubspec.yaml                 # Dependencies
```

## 🛠️ Technology Stack

### Core
- **Flutter** - UI framework
- **Dart** - Programming language
- **Bloc/Cubit** - State management

### Packages
- `flutter_bloc` - State management
- `hive` & `hive_flutter` - Local database
- `go_router` - Navigation
- `dio` - HTTP client
- `flutter_dotenv` - Environment variables
- `google_fonts` - Custom fonts
- `intl` - Internationalization
- `dartz` - Functional programming

### UI Components
- `iconsax` - Modern icons
- `phosphor_flutter` - Icon library
- `font_awesome_flutter` - Font Awesome icons
- `curved_navigation_bar` - Custom navigation
- `percent_indicator` - Progress indicators
- `skeletonizer` - Loading skeletons

## 🎨 Features in Detail

### 1. Project Management
- Create projects with custom categories
- Set start and end dates
- Track project progress
- Add multiple tasks per project
- Color-coded categories

### 2. AI Assistant
- Powered by Google Gemini API
- Natural language processing
- Task suggestions and recommendations
- Context-aware responses
- Streaming responses with formatted output

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

## 🔒 Security

This app implements best practices for API key security:

- ✅ Environment variables for sensitive data
- ✅ `.env` file excluded from git
- ✅ API key rotation guidelines
- ✅ Secure initialization flow

**Important:** Never commit your `.env` file! Keep your API keys secure and rotate them regularly.

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

## 🤝 Contributing

This is a private project for learning purposes. If you'd like to contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📋 Roadmap

- [ ] Cloud synchronization
- [ ] Collaborative projects
- [ ] Recurring tasks
- [ ] Task reminders/notifications
- [ ] Export/import functionality
- [ ] Advanced analytics
- [ ] Voice input
- [ ] Widget support

## 🐛 Known Issues

See the [Issues](https://github.com/Abdelrahman2335/daily_activity/issues) section for known bugs and feature requests.

## 📄 License

This project is private and for educational purposes.

## 👤 Author

**Abdelrahman**
- GitHub: [@Abdelrahman2335](https://github.com/Abdelrahman2335)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Google for the Gemini API
- All the open-source package contributors

## 📞 Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Check the documentation in the `readme/` folder

---

<div align="center">

**Built with ❤️ using Flutter**

[Documentation](readme/) • [Report Bug](../../issues)

</div>
