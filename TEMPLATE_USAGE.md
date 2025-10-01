# Using VibeBase as a Template

VibeBase is designed to be a template repository that you can clone and customize for your own projects. This guide explains how to use it effectively.

## 🎯 Quick Start for New Projects

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/VibeBase.git MyNewApp
cd MyNewApp
rm -rf .git  # Remove VibeBase git history
git init     # Start fresh git repository
```

### 2. Run the One-and-Done Setup Script

The setup script will guide you through customizing the app **and optionally create your Firebase project automatically**:

```bash
./setup.sh
```

#### Interactive Setup Questions:

**Project Identity:**
- **App Name**: The display name (e.g., "My Awesome App")
- **Organization ID**: Your reverse domain (e.g., "com.mycompany" or "io.github.username")
- **App Description**: A short description of your app

**Firebase Setup (Optional but Recommended):**
- **Auto-create Firebase project?**: Answer "y" to automatically create a new Firebase project
- **Deploy security rules?**: Answer "y" to deploy secure defaults immediately

If you choose automatic Firebase setup, the script will:
1. Create a new Firebase project with a unique ID
2. Configure Firebase for Android, iOS, and Web
3. Generate `firebase_options.dart`
4. Optionally deploy security rules
5. Link your local project to Firebase

### 3. What Gets Automatically Done (One Script Does Everything!)

The setup script automatically handles:

#### ✅ Project Customization
- Renames `vibebase_app/` → `your_app_name_app/`
- Updates `pubspec.yaml` - Package name and description
- Updates `main.dart` - App title and branding
- Updates `constants.dart` - App name constant
- Updates Android `build.gradle` - Application ID
- Updates Android `AndroidManifest.xml` - App label
- Updates iOS `Info.plist` - Bundle name and display name
- Updates Web `index.html` - Page title
- Updates Web `manifest.json` - App name
- Updates all bundle identifiers across platforms

#### ✅ Dependencies & Tools
- Installs Firebase CLI (if not present)
- Installs FlutterFire CLI (if not present)
- Adds all Firebase packages (auth, firestore, storage, analytics)
- Adds development tools (launcher icons, splash screen)
- Runs `flutter pub get` to fetch dependencies

#### ✅ Firebase Project (If You Choose "Yes")
- **Creates new Firebase project** with unique ID
- **Authenticates with Firebase** (prompts for login if needed)
- **Configures Firebase** for Android, iOS, and Web
- **Generates `firebase_options.dart`** automatically
- **Links project** to Firebase (creates `.firebaserc`)
- **Optionally deploys security rules** for Firestore and Storage

#### ✅ Documentation
- Creates `PROJECT_INFO.md` with complete project details
- Lists Firebase project ID and console URL
- Updates `README.md` with your app name
- Updates `firebase.json` configuration
- Generates next steps checklist

## 📋 Interactive Setup Example

```bash
$ ./setup.sh

╔════════════════════════════════════════════════════════════════╗
║                   🚀 VibeBase Setup Wizard                    ║
║          Transform VibeBase into Your Custom App              ║
╚════════════════════════════════════════════════════════════════╝

✓ Flutter is installed

═══════════════════════════════════════════════════════════════
         Step 1: Project Identity Configuration
═══════════════════════════════════════════════════════════════

Enter your app name (e.g., 'MyAwesomeApp'):
This will be displayed to users and used for branding.
App Name: TaskMaster Pro

✓ Generated app identifier: taskmaster_pro

Enter your organization identifier (e.g., 'com.mycompany' or 'io.github.username'):
This is used for Android/iOS bundle identifiers.
Organization ID: com.mycompany

✓ Bundle identifier will be: com.mycompany.taskmaster_pro

Enter a short description of your app:
Description: A powerful task management application

═══════════════════════════════════════════════════════════════
              Please Confirm Your Project Details
═══════════════════════════════════════════════════════════════
App Name:          TaskMaster Pro
App ID:            taskmaster_pro
Bundle ID:         com.mycompany.taskmaster_pro
Organization:      com.mycompany
Description:       A powerful task management application
═══════════════════════════════════════════════════════════════

Is this information correct? (y/n): y

[Setup continues automatically...]
```

## 🔄 After Setup

### Your New Project Structure

```
MyNewApp/
├── taskmaster_pro_app/        # Your renamed app
│   ├── lib/
│   │   ├── main.dart         # Updated with "TaskMaster Pro"
│   │   ├── models/
│   │   ├── services/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── utils/
│   │       └── constants.dart # Updated with your app name
│   ├── android/               # Updated bundle ID
│   ├── ios/                   # Updated bundle ID
│   └── web/                   # Updated app name
├── PROJECT_INFO.md            # Your project details
├── setup.sh                   # Template setup script
├── configure_firebase.sh      # Firebase configuration
├── deploy.sh                  # Deployment automation
└── [other files...]
```

### Next Steps After Setup

1. **Configure Firebase** (if using backend):
   ```bash
   ./configure_firebase.sh
   ```

2. **Enable Firebase Services**:
   - Go to Firebase Console
   - Enable Authentication, Firestore, Storage

3. **Deploy Security Rules**:
   ```bash
   firebase deploy --only firestore:rules,storage:rules
   ```

4. **Start Development**:
   ```bash
   cd taskmaster_pro_app  # Or your app name
   flutter run
   ```

## 🎨 Customization After Setup

### Update App Icon
```bash
# Add your icon to assets/icon/app_icon.png
cd your_app_name_app
flutter pub run flutter_launcher_icons
```

### Update Splash Screen
```bash
# Configure in pubspec.yaml
flutter pub run flutter_native_splash:create
```

### Modify Colors/Theme
Edit `lib/main.dart`:
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.yourColor),
  useMaterial3: true,
),
```

## 🔐 Important Notes

### What NOT to Commit
The setup script creates a proper `.gitignore` that excludes:
- `firebase_options.dart` (generated per environment)
- `google-services.json` (Android Firebase config)
- `GoogleService-Info.plist` (iOS Firebase config)
- Build artifacts
- IDE files

### Environment-Specific Configuration
For multiple environments (dev, staging, prod):

1. **Option A**: Use different Firebase projects
   ```bash
   # Development
   flutterfire configure --project=myapp-dev
   
   # Production
   flutterfire configure --project=myapp-prod
   ```

2. **Option B**: Use flavor-based configuration
   - Configure Flutter flavors
   - Create separate Firebase configs per flavor

## 📝 PROJECT_INFO.md

After setup, you'll have a `PROJECT_INFO.md` file:

```markdown
# Project Information

## App Details
- **App Name**: TaskMaster Pro
- **App ID**: taskmaster_pro
- **Bundle Identifier**: com.mycompany.taskmaster_pro
- **Organization**: com.mycompany
- **Description**: A powerful task management application

## Directory Structure
- **App Directory**: taskmaster_pro_app/
- **Created Date**: [timestamp]

## Configuration Status
- [x] Project renamed
- [x] Bundle identifiers updated
- [x] Dependencies installed
- [ ] Firebase configured
- [ ] Firebase services enabled
- [ ] Security rules deployed

## Next Steps
[Checklist of remaining tasks]
```

## 🚀 CI/CD Integration

### GitHub Actions Example

Create `.github/workflows/flutter.yml`:

```yaml
name: Flutter CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
        working-directory: ./your_app_name_app
      - run: flutter test
        working-directory: ./your_app_name_app
      - run: flutter build web
        working-directory: ./your_app_name_app
```

## 💡 Tips for Using VibeBase as a Template

### 1. Keep Template Updated
```bash
# Add VibeBase as upstream remote
git remote add upstream https://github.com/your-org/VibeBase.git

# Pull updates (carefully, as your app may have diverged)
git fetch upstream
git merge upstream/main --allow-unrelated-histories
```

### 2. Customize Security Rules
The default rules in `firestore.rules` and `storage.rules` are permissive for development. Update them for production.

### 3. Add Your Own Services
Follow the pattern in `lib/services/`:
- Create service classes
- Handle errors appropriately
- Return clean results to UI
- Document your code

### 4. Use the Template Scripts
- `./setup.sh` - One-time project customization
- `./configure_firebase.sh` - Connect to Firebase
- `./deploy.sh` - Deploy to various platforms

## 🔧 Troubleshooting

### "App directory not found"
- Make sure you've run `./setup.sh` first
- Check that the directory exists and ends with `_app`

### "Firebase project not found"
- Create the Firebase project first
- Make sure you're logged in: `firebase login`
- Check the project ID is correct

### "Build errors after renaming"
- Run: `flutter clean`
- Run: `flutter pub get`
- Restart your IDE

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- Project `README.md` for quick reference
- `SETUP_GUIDE.md` for detailed setup instructions
- `QUICK_REFERENCE.md` for common commands

---

**Summary**: Clone VibeBase → Run `./setup.sh` → Answer questions → Start building your app!
