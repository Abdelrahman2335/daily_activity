# 📚 Documentation Index

Welcome to the Flowi app documentation! This folder contains comprehensive guides for developers, contributors, and users.

## 📖 Quick Navigation

### 🚀 Getting Started
- **[Main README](../README.md)** - Project overview and quick start
- **[Installation Guide](../README.md#getting-started)** - Setup instructions

### ✍️ Text Formatter Documentation
Located in [`formatter/`](formatter/)

| Document | Description |
|----------|-------------|
| [Implementation Summary](formatter/FORMATTER_IMPLEMENTATION_SUMMARY.md) | Technical implementation details |
| [Quick Reference](formatter/FORMATTER_QUICK_REFERENCE.md) | Quick usage guide and API reference |
| [Visual Guide](formatter/FORMATTER_VISUAL_GUIDE.txt) | Before/after formatting examples |
| [Streaming System Guide](formatter/STREAMING_SYSTEM_GUIDE.md) | 🆕 Complete streaming response system |
| [Streaming Checklist](formatter/STREAMING_IMPLEMENTATION_CHECKLIST.md) | 🆕 Implementation checklist |
| [Streaming Summary](formatter/STREAMING_IMPLEMENTATION_SUMMARY.txt) | 🆕 Visual integration guide |
| [API Docs](../lib/core/utils/TEXT_FORMATTER_README.md) | In-code documentation |

**📌 Start here if:** You're working with Gemini API responses or need to format markdown text.

## 🎯 Common Tasks

### For New Developers

1. **First Time Setup**
   - Read: [Main README](../README.md)
   - Create: `.env` file from `.env.example`
   - Add: Your Gemini API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Run: `flutter pub get` and `flutter run`

2. **API Key Configuration**
   - Copy `.env.example` to `.env`
   - Add your Gemini API key: `GEMINI_API_KEY=your_key_here`
   - Never commit the `.env` file

3. **Understanding the Codebase**
   - Check: [Project Structure](../README.md#project-structure)
   - Review: [Technology Stack](../README.md#technology-stack)

### For Contributors

1. **Code Style**
   - Follow Flutter/Dart conventions
   - Run `flutter analyze` before committing
   - Write tests for new features

2. **Documentation**
   - Update relevant docs when adding features
   - Add inline comments for complex logic
   - Update this index if adding new docs

3. **Security**
   - Never commit `.env` file
   - Keep API keys secure
   - Rotate keys regularly

## 📂 Folder Structure

```
readme/
├── README.md                          # This file (documentation index)
├── formatter/                         # Text formatter documentation
│   ├── FORMATTER_IMPLEMENTATION_SUMMARY.md  # Implementation details
│   ├── FORMATTER_QUICK_REFERENCE.md         # Quick reference
│   └── FORMATTER_VISUAL_GUIDE.txt           # Visual examples
└── getting-started/                   # (Reserved for future guides)
```

## 🔍 Finding What You Need

### By Topic

**Text Formatting**
- Quick usage: [FORMATTER_QUICK_REFERENCE.md](formatter/FORMATTER_QUICK_REFERENCE.md)
- Examples: [FORMATTER_VISUAL_GUIDE.txt](formatter/FORMATTER_VISUAL_GUIDE.txt)
- Implementation: [FORMATTER_IMPLEMENTATION_SUMMARY.md](formatter/FORMATTER_IMPLEMENTATION_SUMMARY.md)

**Project Setup**
- Installation: [Main README](../README.md#installation)
- Dependencies: [Main README](../README.md#technology-stack)
- Building: [Main README](../README.md#building)

### By Role

**New Developer**
1. [Main README](../README.md)
2. [Project Structure](../README.md#project-structure)
3. [Installation Guide](../README.md#getting-started)

**Contributor**
1. [Contributing Guidelines](../README.md#contributing)
2. [Code Documentation](../lib/)
3. [Testing Guide](../README.md#testing)

**User**
1. [Main README](../README.md#about)
2. [Features](../README.md#features-in-detail)
3. [Installation](../README.md#installation)

## 🆘 Troubleshooting

| Issue | Solution |
|-------|----------|
| Can't find API key setup | Copy `.env.example` to `.env` and add your key |
| Formatter usage | Read [FORMATTER_QUICK_REFERENCE.md](formatter/FORMATTER_QUICK_REFERENCE.md) |
| General issues | Check [Main README](../README.md) |

## 📝 Documentation Standards

When adding new documentation:

1. **Location**
   - Feature docs → `formatter/` or create new folder
   - Getting started → `getting-started/`

2. **Format**
   - Use Markdown (.md) for main docs
   - Use .txt for visual/ASCII art guides
   - Include code examples
   - Add table of contents for long docs

3. **Naming**
   - Use UPPERCASE for main guides
   - Use descriptive names
   - Include category prefix (e.g., FORMATTER_*, SECURITY_*)

4. **Content**
   - Start with overview/purpose
   - Include practical examples
   - Add troubleshooting section
   - Link to related docs

## 🔗 External Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [Google Gemini API](https://ai.google.dev/)
- [Hive Database](https://docs.hivedb.dev/)
- [Bloc Pattern](https://bloclibrary.dev/)

## 📞 Need Help?

- 📖 Check this index first
- 🔍 Search the documentation
- 🐛 [Open an issue](https://github.com/Abdelrahman2335/flowi/issues)
- 💬 Contact the maintainer

---

<div align="center">

**Documentation maintained with ❤️**

[Back to Main README](../README.md) • [Project Structure](../README.md#project-structure) • [Contributing](../README.md#contributing)

</div>