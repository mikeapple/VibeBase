# VibeBase

A production-ready Flutter application template with Firebase backend support for Android, iOS, and Web. Clone it, customize it, and start building your app in minutes!

## ✨ Features

- 🎯 **One-and-Done Setup** - Automatic Firebase project creation and configuration
- 🔐 **Auto-Auth Setup** - Email/Password and Anonymous authentication enabled automatically
- 🔥 **Firebase Integration** - Pre-configured Auth, Firestore, Storage, and Analytics
- 📱 **Multi-Platform** - Single codebase for Android, iOS, and Web
- 🏗️ **Clean Architecture** - Service layer pattern with organized folder structure
- 🔒 **Production-Ready Security** - Template security rules for Firestore and Storage
- 🚀 **Automated Scripts** - Setup, configuration, deployment, and reset automation
- 📚 **Comprehensive Docs** - Detailed guides and code examples
- 🔄 **Reset Script** - Return to template state for testing or new projects

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/your-org/VibeBase.git MyNewApp
cd MyNewApp
rm -rf .git && git init  # Start fresh git history
```

### 2. Run One-and-Done Setup
```bash
./setup.sh
```

The interactive wizard will:
- ✅ Ask for your **App Name**, **Organization ID**, and **Description**
- ✅ Rename `vibebase_app` → `your_app_name_app`
- ✅ Update all config files (pubspec.yaml, AndroidManifest.xml, Info.plist, etc.)
- ✅ Update bundle identifiers for all platforms
- ✅ Install Firebase CLI and dependencies
- ✅ **Create Firebase project automatically** (optional)
- ✅ **Configure Firebase** for Android, iOS, and Web
- ✅ **Enable Email/Password authentication** (optional)
- ✅ **Enable Anonymous authentication** (optional)
- ✅ Deploy security rules (optional)
- ✅ Generate `PROJECT_INFO.md` with project details

**The script waits for Firebase project propagation** (up to 2 minutes) to ensure reliable configuration.

### 3. Enable Firebase Services (Manual)
- Visit [Firebase Console](https://console.firebase.google.com/)
- Enable Firestore Database (test mode)
- Enable Storage (test mode, optional)

### 4. Start Building
```bash
cd your_app_name_app
flutter run
```

**Total time from clone to first run: ~5-7 minutes!**

For detailed instructions, see [TEMPLATE_USAGE.md](TEMPLATE_USAGE.md)

## 🔄 Reset to Template State

Want to test the setup process again or start a different project?

```bash
./reset_to_vibebase.sh
```

This script will:
- ✅ Rename app directory back to `vibebase_app`
- ✅ Reset `main.dart` to template
- ✅ Reset `firebase_options.dart` to placeholder
- ✅ Restore all configuration files
- ✅ Reset bundle identifiers
- ✅ Fix iOS Info.plist properly
- ✅ Remove PROJECT_INFO.md
- ✅ Remove Firebase project link (.firebaserc)
- ✅ Preserve your custom code in services/models/screens/widgets
- ✅ Keep all dependencies

After reset, run `./setup.sh` again to create a new project!

## 📦 What's Included

### Automated Setup
- Interactive wizard with smart prompts
- Automatic file renaming and configuration
- Bundle identifier updates across all platforms
- Dependency installation
- **Firebase project creation with retry logic**
- **Authentication provider configuration**

### Pre-Built Services
- **AuthService** - Complete authentication with error handling
- **FirestoreService** - Database operations with real-time streams
- **UserModel** - Data model with serialization patterns
- **Validators** - Form validation utilities
- **Constants** - Centralized configuration

### Automation Scripts
- `setup.sh` - **One-and-done setup** with Firebase project creation
- `configure_firebase.sh` - Connect to existing Firebase project
- `deploy.sh` - Deploy to Web, build Android/iOS apps
- `reset_to_vibebase.sh` - **Reset to template state**

### Documentation
- `TEMPLATE_USAGE.md` - How to use VibeBase as a template
- `SETUP_GUIDE.md` - Comprehensive setup instructions
- `QUICK_REFERENCE.md` - Common commands and code snippets
- `ACTION_ITEMS.md` - Development checklist

## 🎯 Development Workflow

### Web Development
```bash
cd vibebase_app
flutter run -d chrome
```

### Android Development
```bash
cd vibebase_app
flutter run -d android
```

### iOS Development (macOS only)
```bash
cd vibebase_app
flutter run -d ios
```

### Running Tests
```bash
cd vibebase_app
flutter test
```

### Deploying Changes
```bash
./deploy.sh  # Interactive deployment menu
```

## 🏗️ Project Structure

```
vibebase_app/
├── lib/
│   ├── main.dart              # App entry point with Firebase init
│   ├── firebase_options.dart  # Auto-generated Firebase config
│   ├── models/                # Data models
│   │   └── user_model.dart
│   ├── services/              # Business logic & Firebase services
│   │   ├── auth_service.dart
│   │   └── firestore_service.dart
│   ├── screens/               # Full-page UI screens (add yours here)
│   ├── widgets/               # Reusable UI components (add yours here)
│   └── utils/                 # Helper functions
│       ├── constants.dart
│       └── validators.dart
├── android/                   # Android-specific code
├── ios/                       # iOS-specific code
├── web/                       # Web-specific code
└── pubspec.yaml              # Dependencies
```

## 🔐 Firebase Authentication

The setup script can automatically enable:
- ✅ **Email/Password** - Ready to use immediately
- ✅ **Anonymous** - Great for development/testing
- 📝 **Google Sign-In** - Instructions provided for platform-specific setup
- 📝 **Apple Sign-In** - Manual setup required (Apple Developer account needed)

## 🔒 Security

The template includes production-ready security rules for:
- **Firestore** - User-scoped read/write access with helper functions
- **Storage** - User-scoped file access with size/type validation

Deploy with:
```bash
firebase deploy --only firestore:rules,storage:rules
```

## 📚 Key Documentation

- **[TEMPLATE_USAGE.md](TEMPLATE_USAGE.md)** - Complete template usage guide
- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Detailed setup instructions
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Common commands
- **[ACTION_ITEMS.md](ACTION_ITEMS.md)** - Development checklist

## 🛠️ Requirements

- Flutter SDK 3.0+
- Dart 3.0+
- Firebase CLI (auto-installed by setup script)
- For iOS: Xcode
- For Android: Android Studio
- Node.js & npm (for Firebase CLI)

## 💡 Pro Tips

1. **Testing Setup**: Use `./reset_to_vibebase.sh` to reset and test setup repeatedly
2. **Multiple Projects**: Clone VibeBase multiple times for different apps
3. **Firebase Propagation**: The setup script automatically waits for new Firebase projects to be available
4. **Authentication**: Email/Password auth is enabled automatically during setup
5. **Custom Code**: All your custom code in services/models/screens/widgets is preserved during reset

## 🤝 Contributing

This is a template repository. Feel free to fork and customize for your needs!

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details

## 🎉 Get Started Now!

```bash
git clone https://github.com/your-org/VibeBase.git MyAwesomeApp
cd MyAwesomeApp
./setup.sh
# Answer a few questions, grab a coffee ☕
# Your app is ready! 🚀
```

---

**Built with ❤️ for the Flutter community**
