# Environment Variables Setup

## Quick Start

1. **Copy the example file:**
   ```bash
   cp .env.example .env
   ```

2. **Add your API key to `.env`:**
   ```env
   GEMINI_API_KEY=your_actual_api_key_here
   ```

3. **Never commit `.env` file!**
   It's already in `.gitignore`

## Getting Your API Key

1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy the key and paste it in your `.env` file

## Troubleshooting

### Error: "GEMINI_API_KEY not found"
- Make sure `.env` file exists in project root
- Check the key name matches exactly: `GEMINI_API_KEY`
- Run `flutter pub get` after creating `.env`
- Restart your app

### Error: "Unable to load asset: .env"
- Ensure `.env` is listed in `pubspec.yaml` under assets
- Run `flutter clean && flutter pub get`
- Hot restart (not hot reload)

## File Structure

```
daily_activity/
├── .env                 # Your actual key (NEVER COMMIT!)
├── .env.example         # Template (safe to commit)
├── .gitignore          # Includes .env
└── pubspec.yaml        # Includes .env in assets
```

## Security Notes

- ✅ `.env` is in `.gitignore`
- ✅ `.env.example` is in Git (no real key)
- ❌ Never commit `.env` file
- ❌ Never share your API key
- 🔄 Rotate keys regularly (every 3-6 months)

## Need Help?

See `API_SECURITY_GUIDE.md` for detailed instructions.
