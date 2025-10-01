# VibeBase - AI Coding Assistant Instructions

## Project Overview
VibeBase is a **template repository** for creating multiplatform Flutter applications with Firebase backend. It features an interactive setup wizard that automatically customizes the project with your app name, bundle identifiers, and configuration. The goal is to enable developers to clone VibeBase and have a production-ready app structure in minutes.

## Template Usage Pattern
VibeBase is designed to be **cloned and customized**, not used directly:
1. Clone: `git clone VibeBase.git MyNewApp`
2. Run `./setup.sh` - Interactive wizard collects app name, organization ID, description
3. Script automatically renames `vibebase_app` → `myapp_app` and updates all config files
4. Run `./configure_firebase.sh` to connect to Firebase project
5. Start building features immediately

See [TEMPLATE_USAGE.md](../TEMPLATE_USAGE.md) for detailed template usage.

## Quick Start (For New Projects)
1. Run `./setup.sh` - Wizard customizes app name, bundle IDs, installs dependencies, creates Firebase project, generates Android keystore
2. Enable Firebase services (Auth, Firestore, Storage) in Firebase Console
3. Run `flutter run` from `your_app_name_app/` directory

**The setup script now handles:**
- Firebase project creation with retry logic (waits up to 2 minutes for propagation)
- Authentication provider configuration (Email/Password, Anonymous)
- Android release keystore generation with SHA fingerprints
- All configuration files and build setup

See [SETUP_GUIDE.md](../SETUP_GUIDE.md) for detailed instructions.

## Architecture

### Platform Support
- **Flutter 3.0+** for cross-platform UI (Android, iOS, Web)
- **Firebase** for backend services (Authentication, Firestore, Storage, Analytics)
- **Dart 3.0+** for business logic

### Project Structure
```
vibebase_app/lib/
├── main.dart              # App entry with Firebase initialization
├── firebase_options.dart  # Auto-generated Firebase config
├── models/                # Data models (e.g., UserModel)
├── services/              # Business logic & Firebase services
│   ├── auth_service.dart      # Firebase Authentication wrapper
│   └── firestore_service.dart # Firestore database operations
├── screens/               # Full-page UI screens
├── widgets/               # Reusable UI components
└── utils/                 # Helper functions & constants
    ├── constants.dart     # App-wide constants
    └── validators.dart    # Form validation utilities
```

### Firebase Integration
- **Authentication**: Email/password via `AuthService` in `lib/services/auth_service.dart`
- **Firestore**: NoSQL database via `FirestoreService` in `lib/services/firestore_service.dart`
- **Security Rules**: Defined in root-level `firestore.rules` and `storage.rules`
- **Configuration**: Auto-generated `firebase_options.dart` after running `configure_firebase.sh`

## Development Workflow

### Initial Setup (One-time)
```bash
./setup.sh                    # Interactive wizard: renames app, creates Firebase project, generates Android keystore
# Optionally: Enable auth providers, deploy security rules during setup
firebase deploy --only firestore:rules,storage:rules  # If not done during setup
```

### Daily Development
```bash
cd vibebase_app
flutter run -d chrome         # Web development
flutter run -d android        # Android testing
flutter run -d ios            # iOS testing
flutter test                  # Run tests
```

### Deployment
```bash
./deploy.sh                   # Interactive deployment menu
# Options: Web, Android APK, iOS, Firebase rules
```

### Key Commands
- `flutter clean && flutter pub get` - Reset dependencies
- `firebase deploy --only firestore:rules` - Deploy database rules only
- `flutter build web --release` - Production web build
- `dart format lib/` - Format code

## Code Patterns & Conventions

### Service Layer Pattern
All Firebase interactions go through service classes:
- `AuthService` for authentication operations
- `FirestoreService` for database CRUD operations
- Services handle errors and return clean results to UI

Example:
```dart
final authService = AuthService();
try {
  await authService.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
} catch (e) {
  // Error is already formatted by service
  showError(e.toString());
}
```

### Model Classes
- All data models extend base patterns with `fromMap()` and `toMap()` methods
- Use `copyWith()` for immutability
- See `lib/models/user_model.dart` for reference implementation

### Validation
- Centralized validators in `lib/utils/validators.dart`
- Use in forms: `validator: Validators.validateEmail`
- Follows Material Design guidelines for error messages

### Firebase Initialization
Main entry point requires async setup:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const VibeBaseApp());
}
```

### Constants
- App-wide constants in `lib/utils/constants.dart`
- Firestore collection names
- Storage paths with `{uid}` and `{id}` placeholders
- Error messages and validation rules

## Key Files & Directories

### Scripts (Root Level)
- `setup.sh` - **Interactive wizard** that customizes app (name, IDs), renames directories, installs dependencies, creates Firebase project, generates Android keystore
- `configure_firebase.sh` - Firebase project configuration (auto-detects app directory)
- `configure_android_signing.sh` - Configures build.gradle for release signing
- `deploy.sh` - Multi-platform deployment (auto-detects app directory)
- `reset_to_vibebase.sh` - Resets project to template state

### Configuration (Root Level)
- `firebase.json` - Firebase project configuration (hosting, rules paths)
- `firestore.rules` - Database security rules with helper functions
- `storage.rules` - File storage security rules
- `.gitignore` - Excludes `firebase_options.dart`, credentials, build artifacts, **Android keystore files**

### Documentation (Root Level)
- `README.md` - Quick start guide
- `SETUP_GUIDE.md` - Comprehensive setup instructions
- `ACTION_ITEMS.md` - Development checklist and next steps

### Core App Files
- `vibebase_app/lib/main.dart` - Entry point with Firebase init
- `vibebase_app/lib/services/auth_service.dart` - Authentication reference implementation
- `vibebase_app/lib/models/user_model.dart` - Data model pattern reference

## Integration Points

### Firebase Services
- **Auth State**: Stream via `AuthService.authStateChanges`
- **Firestore**: Real-time streams via `FirestoreService.streamCollection()`
- **Platform Config**: Auto-handled by `DefaultFirebaseOptions.currentPlatform`

### Platform-Specific
- Android: `minSdkVersion 21` in `android/app/build.gradle`, **release signing auto-configured with keystore**
- iOS: Development team auto-selected: "Apple Development: Mike Appleton"
- Web: Firebase Hosting configured to `vibebase_app/build/web`
- Android Keystore: Generated at `android/keystore/release.jks` with credentials in `keystore_credentials.txt`

### External Dependencies
Core packages (see `vibebase_app/pubspec.yaml`):
- `firebase_core` - Firebase initialization
- `firebase_auth` - Authentication
- `cloud_firestore` - Database
- `firebase_storage` - File storage
- `firebase_analytics` - Analytics

### Security Rules
Rules use helper functions for clarity:
```javascript
function isAuthenticated() {
  return request.auth != null;
}

function isOwner(userId) {
  return isAuthenticated() && request.auth.uid == userId;
}
```

Deploy with: `firebase deploy --only firestore:rules,storage:rules`

## Important Notes
- **Never commit** `firebase_options.dart`, `google-services.json`, or `GoogleService-Info.plist`
- **Never commit** Android keystore files (automatically git-ignored)
- **Always back up** `android/keystore/` folder - you cannot update your app without it!
- **Security rules** default to restrictive - customize for your use case
- **Scripts are automated** - prefer running scripts over manual commands
- **See ACTION_ITEMS.md** for current development status and next steps
- **See ANDROID_SIGNING.md** for detailed keystore documentation

---
*Last Updated: October 1, 2025*