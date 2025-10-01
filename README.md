# VibeBase

A production-ready Flutter application template with Firebase backend support for Android, iOS, and Web. Clone it, customize it, and start building your app in minutes!

## ✨ Features

- 🎯 **Interactive Setup Wizard** - Automatically renames and configures your app
- 🔥 **Firebase Integration** - Pre-configured Auth, Firestore, Storage, and Analytics
- 📱 **Multi-Platform** - Single codebase for Android, iOS, and Web
- 🏗️ **Clean Architecture** - Service layer pattern with organized folder structure
- 🔒 **Production-Ready Security** - Template security rules for Firestore and Storage
- 🚀 **Automated Scripts** - Setup, configuration, and deployment automation
- 📚 **Comprehensive Docs** - Detailed guides and code examples

## 🚀 Quick Start for New Projects

### 1. Clone as Template
```bash
git clone https://github.com/your-org/VibeBase.git MyNewApp
cd MyNewApp
rm -rf .git && git init  # Start fresh
```

### 2. Run Interactive Setup
```bash
./setup.sh
```

The wizard will ask you for:
- **App Name** (e.g., "TaskMaster Pro")
- **Organization ID** (e.g., "com.mycompany")
- **Description** (e.g., "A task management app")

The script automatically:
- ✅ Renames `vibebase_app` to `your_app_name_app`
- ✅ Updates all configuration files (pubspec.yaml, AndroidManifest.xml, Info.plist, etc.)
- ✅ Updates bundle identifiers for Android and iOS
- ✅ Installs Firebase CLI and all dependencies
- ✅ Generates `PROJECT_INFO.md` with your project details

### 3. Configure Firebase
```bash
./configure_firebase.sh
```
- Enter your Firebase Project ID
- Automatically configures all platforms

### 4. Enable Firebase Services
- Visit [Firebase Console](https://console.firebase.google.com/)
- Enable Authentication, Firestore, Storage

### 5. Deploy & Run
```bash
firebase deploy --only firestore:rules,storage:rules
cd your_app_name_app
flutter run
```

**Total time from clone to first run: ~10 minutes!**

For detailed instructions, see [TEMPLATE_USAGE.md](TEMPLATE_USAGE.md)

## 📋 What You Get

### Automated Setup
- Interactive wizard collects project information
- Automatic file renaming and configuration
- Bundle identifier updates across all platforms
- Dependency installation

### Code Templates
- **AuthService** - Complete authentication with error handling
- **FirestoreService** - Database operations with real-time streams
- **UserModel** - Data model with serialization patterns
- **Validators** - Form validation utilities
- **Constants** - Centralized configuration

### Scripts
- `setup.sh` - Transform VibeBase into your custom app
- `configure_firebase.sh` - Connect to Firebase project
- `deploy.sh` - Deploy to Web, build Android/iOS apps

### Documentation
- `TEMPLATE_USAGE.md` - How to use VibeBase as a template
- `SETUP_GUIDE.md` - Comprehensive setup instructions
- `QUICK_REFERENCE.md` - Common commands and code snippets
- `ACTION_ITEMS.md` - Development checklist

## 📱 Running the App

### Web
```bash
cd vibebase_app
flutter run -d chrome
```

### Android
```bash
cd vibebase_app
flutter run -d android
```

### iOS
```bash
cd vibebase_app
flutter run -d ios
```

## 🏗️ Project Structure

```
VibeBase/
├── vibebase_app/           # Flutter application
│   ├── lib/
│   │   ├── main.dart
│   │   ├── models/         # Data models
│   │   ├── services/       # Firebase & business logic
│   │   ├── screens/        # UI screens
│   │   ├── widgets/        # Reusable widgets
│   │   └── utils/          # Utilities
│   ├── android/            # Android platform code
│   ├── ios/                # iOS platform code
│   ├── web/                # Web platform code
│   └── test/               # Tests
├── setup.sh                # Initial setup script
├── configure_firebase.sh   # Firebase configuration script
├── firestore.rules         # Firestore security rules
├── storage.rules           # Storage security rules
├── firebase.json           # Firebase configuration
└── SETUP_GUIDE.md          # Detailed setup guide
```

## 🔥 Firebase Services

This project is configured to use:
- **Firebase Authentication** - User authentication
- **Cloud Firestore** - NoSQL database
- **Firebase Storage** - File storage
- **Firebase Analytics** - App analytics
- **Firebase Hosting** - Web hosting (optional)

## 🧪 Testing

```bash
cd vibebase_app
flutter test
```

## 📦 Building

### Android APK
```bash
cd vibebase_app
flutter build apk --release
```

### iOS
```bash
cd vibebase_app
flutter build ios --release
```

### Web
```bash
cd vibebase_app
flutter build web --release
```

## 🔒 Security

- Review and customize `firestore.rules` for your use case
- Review and customize `storage.rules` for your use case
- Deploy rules: `firebase deploy --only firestore:rules,storage:rules`
- Never commit sensitive credentials to version control

## 📚 Documentation

- [Setup Guide](SETUP_GUIDE.md) - Detailed setup instructions
- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For issues and questions:
- Check [SETUP_GUIDE.md](SETUP_GUIDE.md)
- Review existing GitHub Issues
- Create a new issue if needed

---

Built with ❤️ using Flutter and Firebase
