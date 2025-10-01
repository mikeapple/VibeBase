# VibeBase Quick Reference

Quick commands and code snippets for common tasks.

## 🚀 Common Commands

### Development
```bash
# Run on different platforms
flutter run -d chrome              # Web
flutter run -d android             # Android
flutter run -d ios                 # iOS

# Hot reload: press 'r' in terminal
# Hot restart: press 'R' in terminal
# Quit: press 'q' in terminal

# Clean and rebuild
flutter clean
flutter pub get
```

### Testing
```bash
flutter test                       # Run all tests
flutter test test/unit/           # Run unit tests only
flutter test test/widgets/        # Run widget tests only
```

### Building
```bash
# Development builds
flutter build apk                  # Android APK (debug)
flutter build ios                  # iOS app (debug)
flutter build web                  # Web app (debug)

# Release builds
flutter build apk --release        # Android APK
flutter build appbundle --release  # Android App Bundle
flutter build ios --release        # iOS app
flutter build web --release        # Web app
```

### Firebase
```bash
# Deploy security rules
firebase deploy --only firestore:rules
firebase deploy --only storage:rules

# Deploy web hosting
firebase deploy --only hosting

# Deploy everything
firebase deploy

# View project info
firebase projects:list
firebase use --add                 # Add project alias
```

## 📝 Code Snippets

### Authentication

#### Sign Up
```dart
final authService = AuthService();

try {
  final userCredential = await authService.createUserWithEmailAndPassword(
    email: emailController.text,
    password: passwordController.text,
  );
  // Navigate to home
} catch (e) {
  // Show error
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.toString())),
  );
}
```

#### Sign In
```dart
final authService = AuthService();

try {
  await authService.signInWithEmailAndPassword(
    email: emailController.text,
    password: passwordController.text,
  );
  // Navigate to home
} catch (e) {
  // Show error
}
```

#### Sign Out
```dart
final authService = AuthService();
await authService.signOut();
```

#### Check Auth State
```dart
StreamBuilder<User?>(
  stream: AuthService().authStateChanges,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return HomePage();  // User is signed in
    }
    return LoginPage();   // User is signed out
  },
)
```

### Firestore Operations

#### Create Document
```dart
final firestoreService = FirestoreService();

await firestoreService.addDocument(
  'users',
  {
    'uid': userId,
    'email': email,
    'displayName': name,
    'createdAt': DateTime.now(),
  },
);
```

#### Read Document
```dart
final firestoreService = FirestoreService();

final doc = await firestoreService.getDocument('users', userId);
if (doc.exists) {
  final userData = doc.data() as Map<String, dynamic>;
  final user = UserModel.fromMap(userData);
}
```

#### Update Document
```dart
await firestoreService.updateDocument(
  'users',
  userId,
  {'displayName': newName, 'updatedAt': DateTime.now()},
);
```

#### Delete Document
```dart
await firestoreService.deleteDocument('users', userId);
```

#### Stream Collection (Real-time)
```dart
StreamBuilder<QuerySnapshot>(
  stream: FirestoreService().streamCollection('posts'),
  builder: (context, snapshot) {
    if (snapshot.hasError) return Text('Error: ${snapshot.error}');
    if (!snapshot.hasData) return CircularProgressIndicator();
    
    final posts = snapshot.data!.docs;
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index].data() as Map<String, dynamic>;
        return ListTile(title: Text(post['title']));
      },
    );
  },
)
```

### Form Validation

#### Email Field
```dart
TextFormField(
  controller: emailController,
  validator: Validators.validateEmail,
  decoration: InputDecoration(labelText: 'Email'),
  keyboardType: TextInputType.emailAddress,
)
```

#### Password Field
```dart
TextFormField(
  controller: passwordController,
  validator: Validators.validatePassword,
  decoration: InputDecoration(labelText: 'Password'),
  obscureText: true,
)
```

#### Name Field
```dart
TextFormField(
  controller: nameController,
  validator: Validators.validateName,
  decoration: InputDecoration(labelText: 'Name'),
)
```

### Navigation

#### Simple Navigation
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => DetailPage()),
);
```

#### Named Routes
```dart
// In MaterialApp
routes: {
  '/': (context) => HomePage(),
  '/login': (context) => LoginPage(),
  '/profile': (context) => ProfilePage(),
},

// Navigate
Navigator.pushNamed(context, '/login');

// Navigate with replacement
Navigator.pushReplacementNamed(context, '/home');
```

## 🔧 Troubleshooting

### Flutter Issues
```bash
# Reset everything
flutter clean
rm -rf pubspec.lock
flutter pub get

# Check for issues
flutter doctor

# Upgrade Flutter
flutter upgrade
```

### iOS Issues
```bash
cd ios
pod deintegrate
pod install
cd ..
```

### Android Issues
```bash
# Clean build
cd android
./gradlew clean
cd ..

# Invalidate caches (Android Studio)
# File → Invalidate Caches / Restart
```

### Firebase Issues
```bash
# Reauth
firebase login --reauth

# Reconfigure
flutterfire configure --project=YOUR_PROJECT_ID

# Check active project
firebase use
```

## 📊 Useful Debugging

### Print Statements
```dart
print('Debug: $variable');
debugPrint('Debug with timestamp');
```

### Firebase Emulator (Optional)
```bash
firebase emulators:start
```

### Chrome DevTools
```bash
flutter run -d chrome --web-renderer html  # Better for debugging
```

## 🎨 Common Widgets

### Loading Indicator
```dart
Center(child: CircularProgressIndicator())
```

### Error Message
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Error message'),
    backgroundColor: Colors.red,
  ),
);
```

### Confirmation Dialog
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Confirm'),
    content: Text('Are you sure?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          // Perform action
          Navigator.pop(context);
        },
        child: Text('Confirm'),
      ),
    ],
  ),
);
```

## 📱 Platform-Specific Code

```dart
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

if (kIsWeb) {
  // Web-specific code
} else if (Platform.isAndroid) {
  // Android-specific code
} else if (Platform.isIOS) {
  // iOS-specific code
}
```

## 🔗 Helpful Resources

- [Flutter Docs](https://docs.flutter.dev/)
- [Firebase Docs](https://firebase.google.com/docs)
- [Dart Packages](https://pub.dev/)
- [Flutter Widget Catalog](https://flutter.dev/docs/development/ui/widgets)
- [Material Design](https://material.io/)

---

For complete setup instructions, see [SETUP_GUIDE.md](SETUP_GUIDE.md)
