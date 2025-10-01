# Quick Start Guide - Sample App

## Prerequisites
✅ Setup script already run (`./setup.sh`)
✅ Firebase project configured
✅ Dependencies installed (`flutter pub get`)
✅ Riverpod code generated (build_runner)

## Running the App

### Web (Recommended for Testing)
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

## What You'll See

### 1. Home Tab (Default)
- Welcome card showing "Guest" or your email
- Feature cards explaining the app
- Material 3 design with rounded corners

### 2. Profile Tab
**Not Signed In:**
- Login form (email + password)
- Social login buttons:
  - Google Sign-In (all platforms)
  - Apple Sign-In (iOS only)
- "Create Account" link → Registration screen

**Signed In:**
- User profile card with email
- Account details (created date)
- "Update Profile" button
- "Delete Account" button (with confirmation)
- "Sign Out" button

### 3. Settings Tab
- Version info: 1.0.0
- Privacy Policy link (opens browser)
- Terms of Service link (opens browser)
- Notification toggle (UI only)
- Language selector (UI only)
- Help & Support section

## Testing Authentication

### Email/Password Registration
1. Go to Profile tab
2. Tap "Create an account"
3. Fill in:
   - Email: test@example.com
   - Password: password123
   - Confirm Password: password123
4. Check "I agree to the Terms..."
5. Tap "Create Account"
6. Success! You're now signed in

### Email/Password Login
1. Go to Profile tab (if not signed in)
2. Enter email and password
3. Tap "Sign In"
4. Profile loads with your information

### Google Sign-In
1. Go to Profile tab (if not signed in)
2. Tap "Sign in with Google" button
3. Choose Google account in popup
4. Grant permissions
5. Signed in with Google profile

### Apple Sign-In (iOS Only)
1. Go to Profile tab (if not signed in)
2. Tap "Sign in with Apple" button
3. Authenticate with Face ID/Touch ID
4. Choose privacy settings
5. Signed in with Apple ID

### Sign Out
1. Go to Profile tab (when signed in)
2. Scroll to bottom
3. Tap "Sign Out"
4. Returns to login view

## Firebase Setup (If Not Done)

### Enable Authentication Providers

1. **Firebase Console**: https://console.firebase.google.com
2. Select your project
3. Go to **Authentication** → **Sign-in method**

#### Email/Password
- Click "Email/Password"
- Enable toggle
- Save

#### Anonymous
- Click "Anonymous"
- Enable toggle
- Save

#### Google Sign-In
- Click "Google"
- Enable toggle
- Add support email
- Save

**For Android:**
- Add SHA-1 and SHA-256 fingerprints:
```bash
cd vibebase_app/android
./gradlew signingReport
```
- Copy SHA-1 and SHA-256 from `:app:debug` output
- Go to Firebase Console → Project Settings → Your apps → Android app
- Add fingerprints

**For Web:**
- No additional setup needed

#### Apple Sign-In (iOS Only)
- Click "Apple"
- Enable toggle
- Save

**iOS Setup:**
1. Open Xcode
2. Select project → Signing & Capabilities
3. Add "Sign in with Apple" capability

**Apple Developer Portal:**
1. Create Services ID
2. Configure Sign in with Apple
3. Add redirect URIs

## Common Issues

### Issue: "No Firebase App has been created"
**Solution:** Firebase initialization failed
```bash
cd vibebase_app
flutter clean
flutter pub get
flutter run
```

### Issue: Google Sign-In not working on Android
**Solution:** Add SHA fingerprints to Firebase Console
```bash
cd vibebase_app/android
./gradlew signingReport
# Copy SHA-1 and SHA-256 to Firebase Console
```

### Issue: Compile errors with "Undefined name 'authServiceProvider'"
**Solution:** Run build_runner again
```bash
cd vibebase_app
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Policy links show error
**Solution:** Policy URLs are placeholders
- Update URLs in `lib/screens/settings_screen.dart` (line 145)
- Update URLs in `lib/widgets/auth/register_screen.dart` (line 79)
- Or host policies and update URLs

### Issue: Apple Sign-In doesn't show on Android
**This is expected behavior.** Apple Sign-In only appears on iOS devices.

### Issue: Google logo missing
**This is expected.** The code has a graceful fallback showing an icon + text button.

## Hot Reload Tips

- **r**: Hot reload (applies code changes instantly)
- **R**: Hot restart (full restart)
- **q**: Quit app

When editing:
- UI changes → Use **r** (hot reload)
- State/logic changes → Use **R** (hot restart)
- Provider changes → Stop app, run build_runner, restart app

## Testing Checklist

### Basic Flow
- [ ] App launches without errors
- [ ] All 3 tabs load
- [ ] Tab switching works smoothly
- [ ] Theme looks correct (Material 3)

### Authentication Flow
- [ ] Can create new account
- [ ] Can sign in with email/password
- [ ] Can sign in with Google (if configured)
- [ ] Can sign in with Apple (iOS only, if configured)
- [ ] Profile shows correct user info
- [ ] Can sign out
- [ ] Profile returns to login view after sign out

### Settings Flow
- [ ] Can tap Privacy Policy link
- [ ] Policy opens in browser/new tab
- [ ] Can tap Terms of Service link
- [ ] Terms open in browser/new tab

### Edge Cases
- [ ] Can't register with invalid email
- [ ] Can't register with short password
- [ ] Can't register without accepting terms
- [ ] Password visibility toggle works
- [ ] Loading states show during auth operations
- [ ] Error messages display correctly

## Next Steps

1. **Customize Branding**
   - Update app name in `pubspec.yaml`
   - Add app icon (use `flutter_launcher_icons` package)
   - Add splash screen

2. **Update Policy URLs**
   - Host privacy-policy.html and terms-of-service.html
   - Update URLs in settings_screen.dart and register_screen.dart

3. **Add Features**
   - Implement forgot password flow
   - Add profile photo upload
   - Implement notification settings
   - Add language selection

4. **Deploy**
   - Test on physical devices
   - Configure release signing (Android)
   - Configure provisioning profiles (iOS)
   - Build and deploy to stores

## Resources

- **VibeBase Docs**: See `SAMPLE_APP.md` for detailed implementation
- **Firebase Docs**: https://firebase.google.com/docs
- **Riverpod Docs**: https://riverpod.dev
- **Flutter Docs**: https://docs.flutter.dev

## Getting Help

**Compile Errors:**
1. Check `flutter analyze` output
2. Run `flutter clean && flutter pub get`
3. Ensure Firebase is configured

**Authentication Issues:**
1. Check Firebase Console for enabled providers
2. Verify SHA fingerprints (Android)
3. Check Apple Developer Portal settings (iOS)

**State Management Issues:**
1. Review `lib/providers/` files
2. Check Riverpod documentation
3. Ensure build_runner has been executed

---

**You're all set!** 🚀

Start building your app features on top of this authentication foundation.
