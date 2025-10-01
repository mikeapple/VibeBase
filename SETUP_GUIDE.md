# VibeBase Setup Guide

This guide will help you set up the VibeBase Flutter application with Firebase backend.

## Prerequisites

Before starting, ensure you have:

- **Flutter SDK** (3.0 or later) - [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Xcode** (for iOS development on macOS) - [Download Xcode](https://developer.apple.com/xcode/)
- **Android Studio** (for Android development) - [Download Android Studio](https://developer.android.com/studio)
- **Node.js & npm** (for Firebase CLI) - [Install Node.js](https://nodejs.org/)
- **Git** - [Install Git](https://git-scm.com/downloads)

## Initial Setup

### 1. Run the Setup Script

The setup script will install necessary dependencies and configure the project:

```bash
chmod +x setup.sh
./setup.sh
```

This script will:
- Verify Flutter installation
- Install Firebase CLI (if not present)
- Install FlutterFire CLI
- Add Firebase dependencies to the project
- Get all Flutter dependencies

### 2. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or select an existing project
3. Follow the setup wizard
4. Note your **Project ID** (you'll need this in the next step)

### 3. Configure Firebase

Run the Firebase configuration script:

```bash
chmod +x configure_firebase.sh
./configure_firebase.sh
```

When prompted:
- Enter your Firebase Project ID
- The script will automatically configure Firebase for Android, iOS, and Web

### 4. Enable Firebase Services

In the [Firebase Console](https://console.firebase.google.com/):

#### Authentication
1. Navigate to **Authentication** → **Sign-in method**
2. Enable desired providers:
   - Email/Password
   - Google Sign-In
   - Apple Sign-In (for iOS)
   - Anonymous (optional, for testing)

#### Firestore Database
1. Navigate to **Firestore Database**
2. Click **Create database**
3. Start in **Test mode** (for development)
4. Choose a location close to your users
5. Later, update security rules in `firestore.rules`

#### Storage (Optional)
1. Navigate to **Storage**
2. Click **Get started**
3. Start in **Test mode** (for development)
4. Later, update security rules in `storage.rules`

#### Analytics (Optional)
1. Navigate to **Analytics**
2. Enable Google Analytics
3. Link to existing GA property or create new one

## Project Structure

```
vibebase_app/
├── lib/
│   ├── main.dart              # App entry point
│   ├── firebase_options.dart  # Auto-generated Firebase config
│   ├── models/                # Data models
│   ├── services/              # Business logic & Firebase services
│   ├── screens/               # UI screens
│   ├── widgets/               # Reusable widgets
│   └── utils/                 # Utility functions
├── android/                   # Android-specific code
├── ios/                       # iOS-specific code
├── web/                       # Web-specific code
├── test/                      # Unit and widget tests
└── pubspec.yaml              # Dependencies
```

## Running the Application

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

### iOS (macOS only)
```bash
cd vibebase_app
flutter run -d ios
```

### All platforms
```bash
cd vibebase_app
flutter run
# Then select the device from the list
```

## Development Workflow

### Adding Dependencies
```bash
cd vibebase_app
flutter pub add package_name
```

### Running Tests
```bash
cd vibebase_app
flutter test
```

### Building for Production

#### Android (APK)
```bash
cd vibebase_app
flutter build apk --release
```

#### Android (App Bundle)
```bash
cd vibebase_app
flutter build appbundle --release
```

#### iOS
```bash
cd vibebase_app
flutter build ios --release
```

#### Web
```bash
cd vibebase_app
flutter build web --release
```

## Firebase Security Rules

### Firestore Rules Template
Create `firestore.rules` in the project root:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Add more rules as needed
  }
}
```

### Storage Rules Template
Create `storage.rules` in the project root:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

Deploy rules:
```bash
firebase deploy --only firestore:rules
firebase deploy --only storage:rules
```

## Troubleshooting

### Flutter Issues
```bash
flutter clean
flutter pub get
flutter doctor
```

### Firebase Issues
```bash
firebase login --reauth
flutterfire configure --project=YOUR_PROJECT_ID
```

### iOS Specific
```bash
cd ios
pod install
cd ..
```

### Android Specific
- Ensure `minSdkVersion` is at least 21 in `android/app/build.gradle`
- Update Google Services plugin if needed

## Next Steps

1. Review the auto-generated `lib/main.dart`
2. Create your authentication flow
3. Set up Firestore data models
4. Implement your app's features
5. Write tests
6. Configure CI/CD (GitHub Actions, etc.)

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [VibeBase GitHub](https://github.com/your-org/vibebase)

## Support

For issues or questions, please refer to:
- Project documentation
- GitHub Issues
- Flutter community
- Firebase community
