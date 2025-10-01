# Android Keystore & Signing Configuration

This document explains the automatic Android keystore generation and signing configuration in VibeBase.

## Overview

VibeBase now automatically generates a secure Android release keystore during setup, eliminating the manual process of creating keystores and configuring signing. This is essential for releasing Android apps to the Google Play Store.

## What Gets Generated

When you run `./setup.sh` and choose to generate a keystore, the following files are created:

```
your_app_name_app/android/
├── keystore/
│   ├── release.jks                    # Your release keystore (2048-bit RSA)
│   └── keystore_credentials.txt       # All passwords and SHA fingerprints
├── key.properties                     # Build configuration (read by Gradle)
└── app/
    └── build.gradle                   # Configured for release signing
```

### 🔒 All files are git-ignored for security!

## Keystore Details

### Generated Configuration
- **Algorithm**: RSA
- **Key Size**: 2048 bits
- **Validity**: 10,000 days (~27 years)
- **Alias**: release
- **Passwords**: Randomly generated (20 characters each)
- **Certificate**: Includes app name and organization

### keystore_credentials.txt Contents
```
Android Release Keystore Credentials
=====================================
App Name: Your App Name
Generated: [timestamp]

⚠️  IMPORTANT: Keep these credentials safe and secure!
⚠️  You will need these to sign app updates.
⚠️  Loss of these credentials means you cannot update your app!

Keystore Location: android/keystore/release.jks
Key Alias: release
Store Password: [auto-generated]
Key Password: [auto-generated]

SHA-1 Fingerprint: [extracted]
SHA-256 Fingerprint: [extracted]
```

## Build Configuration

### key.properties
```properties
storePassword=[auto-generated]
keyPassword=[auto-generated]
keyAlias=release
storeFile=keystore/release.jks
```

### build.gradle Configuration
The setup script automatically configures `android/app/build.gradle`:

```gradle
// Load keystore properties
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // Signing configuration
    signingConfigs {
        release {
            if (keystorePropertiesFile.exists()) {
                keyAlias keystoreProperties['keyAlias']
                keyPassword keystoreProperties['keyPassword']
                storeFile file(keystoreProperties['storeFile'])
                storePassword keystoreProperties['storePassword']
            }
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            // ... other release settings
        }
    }
}
```

## Usage

### Building Release APK
```bash
cd your_app_name_app
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk` (signed)

### Building App Bundle (for Play Store)
```bash
cd your_app_name_app
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab` (signed)

### Verifying Signing
```bash
# Check APK signature
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk

# Check App Bundle signature
jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab
```

## Firebase Integration

### SHA Fingerprints for Google Sign-In

The SHA-1 and SHA-256 fingerprints are automatically extracted and saved. You need to add these to Firebase for Google Sign-In to work on Android.

#### Automatic Process (during setup):
1. Fingerprints are extracted during keystore generation
2. Saved to `keystore_credentials.txt`
3. Added to `PROJECT_INFO.md`
4. Setup script can open Firebase Console for you

#### Manual Process:
1. Get fingerprints from credentials file or run:
```bash
keytool -list -v -keystore android/keystore/release.jks -alias release
```

2. Add to Firebase:
   - Go to Firebase Console → Project Settings
   - Select your Android app
   - Click "Add fingerprint"
   - Paste SHA-1 (required for Google Sign-In)
   - Paste SHA-256 (recommended)

## Security Best Practices

### ✅ DO:
- **Back up keystore and credentials immediately** after generation
- Store backups in multiple secure locations (password manager, encrypted cloud storage)
- Never share passwords in plain text
- Rotate passwords if compromised
- Use the same keystore for all app updates

### ❌ DON'T:
- Commit keystore files to git (already ignored)
- Share keystore files via email or chat
- Store credentials in plain text files (except the generated credentials.txt, which should be backed up securely)
- Lose your keystore - you cannot recover it!
- Generate a new keystore for updates (users won't be able to update)

### Git Ignore
The `.gitignore` already includes:
```gitignore
# Android signing keystore
**/android/keystore/
**/android/key.properties
```

## Backup Procedures

### Essential Files to Back Up:
1. `android/keystore/release.jks` - The keystore file
2. `android/keystore/keystore_credentials.txt` - All passwords and fingerprints
3. `android/key.properties` - Build configuration (can be regenerated from credentials)

### Recommended Backup Locations:
- Password manager (1Password, LastPass, Bitwarden)
- Encrypted cloud storage (iCloud Keychain, Google Drive with encryption)
- Secure team vault (for organizations)
- Offline encrypted USB drive

### Backup Verification:
```bash
# Test that you can list the keystore
keytool -list -v -keystore android/keystore/release.jks -alias release
# Enter the store password from your backup
```

## Troubleshooting

### Build Not Signing
**Problem**: Release builds not signed after setup

**Solution**:
```bash
# Run the signing configuration script
./configure_android_signing.sh
```

### Keystore Not Found
**Problem**: `FileNotFoundException: keystore/release.jks`

**Solution**:
- Ensure you're building from the correct directory
- Check that `android/keystore/release.jks` exists
- Verify `android/key.properties` has correct path

### Wrong Password
**Problem**: `Keystore was tampered with, or password was incorrect`

**Solution**:
- Check passwords in `android/keystore/keystore_credentials.txt`
- Ensure no extra spaces in `key.properties`
- Regenerate keystore if passwords are lost (will break app updates!)

### SHA Fingerprints Needed
**Problem**: Need to extract SHA fingerprints again

**Solution**:
```bash
# From project root
cd your_app_name_app
keytool -list -v -keystore android/keystore/release.jks -alias release
# Enter store password from credentials file
# Look for SHA1 and SHA256 lines
```

### Keystore Lost
**Problem**: Keystore file lost or corrupted

**Solution**:
- **If you have backups**: Restore from backup immediately
- **If no backups**: 
  - You CANNOT update existing app installations
  - Must publish as a new app with different package name
  - Users must uninstall old app and install new one
  - **This is why backups are critical!**

## Migration from Manual Keystore

If you already have a keystore:

1. Place it at: `your_app_name_app/android/keystore/release.jks`
2. Create `key.properties`:
```properties
storePassword=your_password
keyPassword=your_key_password
keyAlias=your_alias
storeFile=keystore/release.jks
```
3. Run: `./configure_android_signing.sh` to update build.gradle

## Scripts Reference

### setup.sh
- Generates keystore during initial setup
- Extracts SHA fingerprints
- Saves credentials
- Configures build.gradle (if it exists)

### configure_android_signing.sh
- Configures build.gradle for existing keystore
- Use when Flutter creates the Android project after setup
- Safe to run multiple times (checks if already configured)

### reset_to_vibebase.sh
- Does NOT delete keystore files
- Preserves `android/keystore/` directory
- You can safely reset and keep your signing configuration

## Advanced: Multiple Keystores

For different environments (dev, staging, production):

1. Generate separate keystores:
```bash
keytool -genkey -v -keystore android/keystore/dev.jks -alias dev ...
keytool -genkey -v -keystore android/keystore/staging.jks -alias staging ...
keytool -genkey -v -keystore android/keystore/production.jks -alias production ...
```

2. Create separate properties files:
```bash
android/key-dev.properties
android/key-staging.properties
android/key-production.properties
```

3. Modify build.gradle to load different properties based on build variant

## Resources

- [Android: Sign your app](https://developer.android.com/studio/publish/app-signing)
- [Flutter: Build and release an Android app](https://docs.flutter.dev/deployment/android)
- [Firebase: Add SHA certificate fingerprints](https://firebase.google.com/docs/android/setup#add_the_sha_fingerprint)
- [Google Play: App signing](https://support.google.com/googleplay/android-developer/answer/9842756)

---

**Remember: Your keystore is irreplaceable. Back it up today!** 🔐
