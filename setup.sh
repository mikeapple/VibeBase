#!/bin/bash

# VibeBase Setup Script
# This script automates the setup and customization of your Flutter application with Firebase

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                   🚀 VibeBase Setup Wizard                    ║"
echo "║          Transform VibeBase into Your Custom App              ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}\n"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed. Please install Flutter first.${NC}"
    echo "Visit: https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo -e "${GREEN}✓ Flutter is installed${NC}"
flutter --version
echo ""

# ============================================================================
# STEP 1: Collect Project Information
# ============================================================================

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}         Step 1: Project Identity Configuration${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}\n"

# App Name
echo -e "${YELLOW}Enter your app name (e.g., 'MyAwesomeApp'):${NC}"
echo -e "${CYAN}This will be displayed to users and used for branding.${NC}"
read -p "App Name: " APP_NAME

if [ -z "$APP_NAME" ]; then
    echo -e "${RED}App name cannot be empty. Exiting.${NC}"
    exit 1
fi

# App ID (lowercase, no spaces)
APP_ID=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr -cd '[:alnum:]_')
echo -e "${GREEN}✓ Generated app identifier: ${APP_ID}${NC}\n"

# Package/Bundle Identifier
echo -e "${YELLOW}Enter your organization identifier (e.g., 'com.mycompany' or 'io.github.username'):${NC}"
echo -e "${CYAN}This is used for Android/iOS bundle identifiers.${NC}"
read -p "Organization ID: " ORG_ID

if [ -z "$ORG_ID" ]; then
    echo -e "${YELLOW}No organization ID provided. Using 'com.example'${NC}"
    ORG_ID="com.example"
fi

BUNDLE_ID="${ORG_ID}.${APP_ID}"
echo -e "${GREEN}✓ Bundle identifier will be: ${BUNDLE_ID}${NC}\n"

# App Description
echo -e "${YELLOW}Enter a short description of your app:${NC}"
read -p "Description: " APP_DESCRIPTION

if [ -z "$APP_DESCRIPTION" ]; then
    APP_DESCRIPTION="A Flutter application built with Firebase"
fi

# Confirm information
echo -e "\n${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}              Please Confirm Your Project Details${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}App Name:${NC}          $APP_NAME"
echo -e "${CYAN}App ID:${NC}            $APP_ID"
echo -e "${CYAN}Bundle ID:${NC}         $BUNDLE_ID"
echo -e "${CYAN}Organization:${NC}      $ORG_ID"
echo -e "${CYAN}Description:${NC}       $APP_DESCRIPTION"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}\n"

read -p "Is this information correct? (y/n): " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Setup cancelled. Please run the script again.${NC}"
    exit 0
fi

# ============================================================================
# STEP 2: Rename Project Directory
# ============================================================================

echo -e "\n${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}         Step 2: Renaming Project Directory${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}\n"

OLD_DIR="vibebase_app"
NEW_DIR="${APP_ID}_app"

if [ "$OLD_DIR" != "$NEW_DIR" ]; then
    if [ -d "$NEW_DIR" ]; then
        echo -e "${RED}❌ Directory '$NEW_DIR' already exists!${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Renaming $OLD_DIR to $NEW_DIR...${NC}"
    mv "$OLD_DIR" "$NEW_DIR"
    echo -e "${GREEN}✓ Directory renamed${NC}"
else
    NEW_DIR="$OLD_DIR"
    echo -e "${YELLOW}⚠️  App ID matches existing name, keeping current directory${NC}"
fi

# ============================================================================
# STEP 3: Update Project Files
# ============================================================================

echo -e "\n${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}         Step 3: Updating Project Configuration${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}\n"

cd "$NEW_DIR"

# Update pubspec.yaml
echo -e "${YELLOW}Updating pubspec.yaml...${NC}"
if [ -f "pubspec.yaml" ]; then
    sed -i.bak "s/name: vibebase_app/name: ${APP_ID}_app/" pubspec.yaml
    sed -i.bak "s/description:.*/description: $APP_DESCRIPTION/" pubspec.yaml
    rm pubspec.yaml.bak
    echo -e "${GREEN}✓ pubspec.yaml updated${NC}"
fi

# Update main.dart
echo -e "${YELLOW}Updating main.dart...${NC}"
if [ -f "lib/main.dart" ]; then
    sed -i.bak "s/VibeBase/$APP_NAME/g" lib/main.dart
    sed -i.bak "s/title: 'VibeBase'/title: '$APP_NAME'/" lib/main.dart
    rm lib/main.dart.bak
    echo -e "${GREEN}✓ main.dart updated${NC}"
fi

# Update constants.dart
echo -e "${YELLOW}Updating constants.dart...${NC}"
if [ -f "lib/utils/constants.dart" ]; then
    sed -i.bak "s/appName = 'VibeBase'/appName = '$APP_NAME'/" lib/utils/constants.dart
    rm lib/utils/constants.dart.bak
    echo -e "${GREEN}✓ constants.dart updated${NC}"
fi

# Update Android package
echo -e "${YELLOW}Updating Android configuration...${NC}"
if [ -f "android/app/build.gradle" ]; then
    sed -i.bak "s/applicationId \"com.vibebase.vibebase_app\"/applicationId \"$BUNDLE_ID\"/" android/app/build.gradle
    rm android/app/build.gradle.bak
    echo -e "${GREEN}✓ Android applicationId updated${NC}"
fi

if [ -f "android/app/src/main/AndroidManifest.xml" ]; then
    sed -i.bak "s/android:label=\"vibebase_app\"/android:label=\"$APP_NAME\"/" android/app/src/main/AndroidManifest.xml
    rm android/app/src/main/AndroidManifest.xml.bak
    echo -e "${GREEN}✓ Android app label updated${NC}"
fi

# Update iOS configuration
echo -e "${YELLOW}Updating iOS configuration...${NC}"
if [ -f "ios/Runner/Info.plist" ]; then
    # Update CFBundleName and CFBundleDisplayName
    sed -i.bak "s/<string>vibebase_app<\/string>/<string>$APP_NAME<\/string>/" ios/Runner/Info.plist
    rm ios/Runner/Info.plist.bak
    echo -e "${GREEN}✓ iOS Info.plist updated${NC}"
fi

# Update web configuration
echo -e "${YELLOW}Updating Web configuration...${NC}"
if [ -f "web/index.html" ]; then
    sed -i.bak "s/<title>vibebase_app<\/title>/<title>$APP_NAME<\/title>/" web/index.html
    rm web/index.html.bak
    echo -e "${GREEN}✓ web/index.html updated${NC}"
fi

if [ -f "web/manifest.json" ]; then
    sed -i.bak "s/\"name\": \"vibebase_app\"/\"name\": \"$APP_NAME\"/" web/manifest.json
    sed -i.bak "s/\"short_name\": \"vibebase_app\"/\"short_name\": \"$APP_NAME\"/" web/manifest.json
    rm web/manifest.json.bak
    echo -e "${GREEN}✓ web/manifest.json updated${NC}"
fi

# ============================================================================
# STEP 4: Install Dependencies
# ============================================================================

echo -e "\n${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}         Step 4: Installing Dependencies${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}\n"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm is not installed. Please install Node.js first.${NC}"
    echo "Visit: https://nodejs.org/"
    exit 1
fi

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo -e "${YELLOW}⚠️  Firebase CLI not found. Installing...${NC}"
    npm install -g firebase-tools
else
    echo -e "${GREEN}✓ Firebase CLI is installed${NC}"
fi

# Check if FlutterFire CLI is installed
if ! command -v flutterfire &> /dev/null; then
    echo -e "${YELLOW}⚠️  FlutterFire CLI not found. Installing...${NC}"
    dart pub global activate flutterfire_cli
else
    echo -e "${GREEN}✓ FlutterFire CLI is installed${NC}"
fi

# Ensure user is logged into Firebase
echo -e "\n${YELLOW}Checking Firebase authentication...${NC}"
if ! firebase projects:list &> /dev/null; then
    echo -e "${YELLOW}Please log in to Firebase...${NC}"
    firebase login
fi
echo -e "${GREEN}✓ Authenticated with Firebase${NC}"

# Add Firebase dependencies
echo -e "\n${YELLOW}📦 Adding Firebase dependencies...${NC}"
flutter pub add firebase_core
flutter pub add firebase_auth
flutter pub add cloud_firestore
flutter pub add firebase_storage
flutter pub add firebase_analytics

# Add development dependencies
echo -e "\n${YELLOW}📦 Adding development dependencies...${NC}"
flutter pub add --dev flutter_launcher_icons
flutter pub add --dev flutter_native_splash

# Get all dependencies
echo -e "\n${YELLOW}📥 Getting dependencies...${NC}"
flutter pub get

# ============================================================================
# STEP 5: Create and Configure Firebase Project
# ============================================================================

echo -e "\n${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}         Step 5: Firebase Project Setup${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}\n"

cd ..

# Ask if user wants automatic Firebase setup
echo -e "${YELLOW}Would you like to automatically create and configure a Firebase project?${NC}"
echo -e "${CYAN}(This will create a new Firebase project with your app name)${NC}"
read -p "Auto-create Firebase project? (y/n): " AUTO_FIREBASE

if [[ "$AUTO_FIREBASE" =~ ^[Yy]$ ]]; then
    # Generate Firebase project ID (must be globally unique)
    FIREBASE_PROJECT_ID="${APP_ID}-$(date +%s | tail -c 5)"
    
    echo -e "\n${YELLOW}Creating Firebase project: ${FIREBASE_PROJECT_ID}${NC}"
    echo -e "${CYAN}Display name: $APP_NAME${NC}\n"
    
    # Create Firebase project
    if firebase projects:create "$FIREBASE_PROJECT_ID" --display-name="$APP_NAME" 2>&1 | tee /tmp/firebase_create.log; then
        echo -e "${GREEN}✓ Firebase project created!${NC}"
        
        # Wait a moment for project to be ready
        echo -e "${YELLOW}Waiting for project initialization...${NC}"
        sleep 3
        
        # Configure FlutterFire
        echo -e "\n${YELLOW}Configuring Firebase for your app...${NC}"
        cd "$NEW_DIR"
        
        if flutterfire configure --project="$FIREBASE_PROJECT_ID" --platforms=android,ios,web --yes --out=lib/firebase_options.dart; then
            echo -e "${GREEN}✓ Firebase configured for all platforms${NC}"
            FIREBASE_CONFIGURED=true
        else
            echo -e "${RED}⚠️  FlutterFire configuration failed. You may need to run ./configure_firebase.sh manually${NC}"
            FIREBASE_CONFIGURED=false
        fi
        
        cd ..
        
        # Set up Firebase project
        if [ "$FIREBASE_CONFIGURED" = true ]; then
            echo -e "\n${YELLOW}Setting up Firebase project...${NC}"
            
            # Initialize Firebase in the project
            if [ ! -f ".firebaserc" ]; then
                firebase use --add "$FIREBASE_PROJECT_ID" --alias default 2>/dev/null || true
            fi
            
            echo -e "${GREEN}✓ Firebase project linked${NC}"
            
            # Ask if user wants to deploy security rules immediately
            echo -e "\n${YELLOW}Would you like to deploy the security rules now?${NC}"
            echo -e "${CYAN}(This will set up secure defaults for Firestore and Storage)${NC}"
            read -p "Deploy security rules? (y/n): " DEPLOY_RULES
            
            if [[ "$DEPLOY_RULES" =~ ^[Yy]$ ]]; then
                echo -e "\n${YELLOW}Deploying security rules...${NC}"
                
                # Deploy Firestore and Storage rules
                if firebase deploy --only firestore:rules,storage:rules --project="$FIREBASE_PROJECT_ID" 2>&1 | grep -q "Deploy complete"; then
                    echo -e "${GREEN}✓ Security rules deployed${NC}"
                    RULES_DEPLOYED=true
                else
                    echo -e "${YELLOW}⚠️  Rules deployment may require services to be enabled first${NC}"
                    echo -e "${CYAN}You can deploy them later after enabling services${NC}"
                    RULES_DEPLOYED=false
                fi
            else
                echo -e "${YELLOW}Skipping rules deployment${NC}"
                RULES_DEPLOYED=false
            fi
            
            echo -e "\n${YELLOW}📝 Important: You still need to manually enable these services:${NC}"
            echo -e "   ${CYAN}• Authentication (Email/Password, Google, etc.)${NC}"
            echo -e "   ${CYAN}• Firestore Database (create in test mode)${NC}"
            echo -e "   ${CYAN}• Storage (optional, create in test mode)${NC}"
            echo -e "\n   Visit: ${CYAN}https://console.firebase.google.com/project/$FIREBASE_PROJECT_ID${NC}"
            
            if [ "$RULES_DEPLOYED" = false ]; then
                echo -e "\n   ${YELLOW}After enabling services, deploy rules with:${NC}"
                echo -e "   ${CYAN}firebase deploy --only firestore:rules,storage:rules${NC}"
            fi
        fi
    else
        echo -e "${RED}⚠️  Failed to create Firebase project${NC}"
        echo -e "${YELLOW}You can create it manually and run ./configure_firebase.sh${NC}"
        FIREBASE_PROJECT_ID=""
        FIREBASE_CONFIGURED=false
    fi
else
    echo -e "${YELLOW}Skipping automatic Firebase setup${NC}"
    echo -e "${CYAN}You can run ./configure_firebase.sh later to connect to Firebase${NC}"
    FIREBASE_PROJECT_ID=""
    FIREBASE_CONFIGURED=false
fi

# ============================================================================
# STEP 6: Update Documentation
# ============================================================================

echo -e "\n${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}         Step 6: Generating Documentation${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}\n"

cd ..

# Update firebase.json
if [ -f "firebase.json" ]; then
    echo -e "${YELLOW}Updating firebase.json...${NC}"
    sed -i.bak "s/vibebase_app/$NEW_DIR/" firebase.json
    rm firebase.json.bak
    echo -e "${GREEN}✓ firebase.json updated${NC}"
fi

# Update README.md
if [ -f "README.md" ]; then
    echo -e "${YELLOW}Updating README.md...${NC}"
    sed -i.bak "s/VibeBase/$APP_NAME/g" README.md
    sed -i.bak "s/vibebase_app/$NEW_DIR/g" README.md
    rm README.md.bak
    echo -e "${GREEN}✓ README.md updated${NC}"
fi

# Create a project info file
echo -e "${YELLOW}Creating PROJECT_INFO.md...${NC}"

# Build Firebase section if configured
FIREBASE_SECTION=""
if [ -n "$FIREBASE_PROJECT_ID" ]; then
    FIREBASE_SECTION="
## Firebase Configuration
- **Project ID**: $FIREBASE_PROJECT_ID
- **Configured Date**: $(date)
- **Platforms**: Android, iOS, Web
- **Console URL**: https://console.firebase.google.com/project/$FIREBASE_PROJECT_ID
"
fi

# Build configuration checklist
FIREBASE_CONFIGURED_CHECK="[ ]"
RULES_DEPLOYED_CHECK="[ ]"
if [ "$FIREBASE_CONFIGURED" = true ]; then
    FIREBASE_CONFIGURED_CHECK="[x]"
fi
if [ "$RULES_DEPLOYED" = true ]; then
    RULES_DEPLOYED_CHECK="[x]"
fi

cat > PROJECT_INFO.md << EOF
# Project Information

This file contains the identity information for your application.

## App Details
- **App Name**: $APP_NAME
- **App ID**: $APP_ID
- **Bundle Identifier**: $BUNDLE_ID
- **Organization**: $ORG_ID
- **Description**: $APP_DESCRIPTION

## Directory Structure
- **App Directory**: $NEW_DIR/
- **Created Date**: $(date)
$FIREBASE_SECTION
## Configuration Status
- [x] Project renamed
- [x] Bundle identifiers updated
- [x] Dependencies installed
- $FIREBASE_CONFIGURED_CHECK Firebase configured
- [ ] Firebase services enabled (Auth, Firestore, Storage)
- $RULES_DEPLOYED_CHECK Security rules deployed

## Next Steps
EOF

if [ "$FIREBASE_CONFIGURED" = true ]; then
    cat >> PROJECT_INFO.md << EOF
1. Visit Firebase Console: https://console.firebase.google.com/project/$FIREBASE_PROJECT_ID
2. Enable Authentication (Email/Password, Google, etc.)
3. Create Firestore Database (start in test mode)
4. Set up Storage (optional, start in test mode)
5. Deploy security rules: \`firebase deploy --only firestore:rules,storage:rules\`
6. Run your app: \`cd $NEW_DIR && flutter run\`
EOF
else
    cat >> PROJECT_INFO.md << EOF
1. Run \`./configure_firebase.sh\` to connect to Firebase (or create project manually)
2. Enable Firebase services (Auth, Firestore, Storage)
3. Deploy security rules: \`firebase deploy --only firestore:rules,storage:rules\`
4. Run your app: \`cd $NEW_DIR && flutter run\`
EOF
fi

cat >> PROJECT_INFO.md << EOF

## Useful Commands
\`\`\`bash
# Run on web
cd $NEW_DIR && flutter run -d chrome

# Run on mobile
cd $NEW_DIR && flutter run

# Deploy security rules
firebase deploy --only firestore:rules,storage:rules

# Deploy web app
flutter build web --release
firebase deploy --only hosting

# Build for production
cd $NEW_DIR
flutter build apk --release          # Android APK
flutter build appbundle --release    # Android App Bundle
flutter build ios --release          # iOS
\`\`\`

---
*Generated by VibeBase Setup Script on $(date)*
EOF

echo -e "${GREEN}✓ PROJECT_INFO.md created${NC}"

# ============================================================================
# COMPLETION
# ============================================================================

echo -e "\n${GREEN}"
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                    ✅ Setup Complete!                         ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${CYAN}Your app '$APP_NAME' is ready!${NC}\n"

if [ "$FIREBASE_CONFIGURED" = true ]; then
    echo -e "${GREEN}✨ Firebase project created and configured!${NC}\n"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}                 Firebase Project Details${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}Project ID:${NC}     $FIREBASE_PROJECT_ID"
    echo -e "${CYAN}Console URL:${NC}    https://console.firebase.google.com/project/$FIREBASE_PROJECT_ID"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}\n"
    
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}                    Next Steps${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}1.${NC} Enable Firebase services in console:"
    echo -e "   ${CYAN}• Authentication (Email/Password, Google, etc.)${NC}"
    echo -e "   ${CYAN}• Firestore Database (test mode)${NC}"
    echo -e "   ${CYAN}• Storage (optional, test mode)${NC}"
    echo -e "\n${YELLOW}2.${NC} Deploy security rules:"
    echo -e "   ${CYAN}firebase deploy --only firestore:rules,storage:rules${NC}"
    echo -e "\n${YELLOW}3.${NC} Run your app:"
    echo -e "   ${CYAN}cd $NEW_DIR && flutter run -d chrome${NC}"
    echo -e "   ${CYAN}cd $NEW_DIR && flutter run${NC} (for mobile)"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}\n"
    
    echo -e "${GREEN}🚀 Your app is fully configured and ready to run!${NC}\n"
else
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}                    Next Steps${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}1.${NC} Configure Firebase:"
    echo -e "   ${CYAN}./configure_firebase.sh${NC}"
    echo -e "\n${YELLOW}2.${NC} Enable Firebase services (Auth, Firestore, Storage)"
    echo -e "\n${YELLOW}3.${NC} Deploy security rules:"
    echo -e "   ${CYAN}firebase deploy --only firestore:rules,storage:rules${NC}"
    echo -e "\n${YELLOW}4.${NC} Run your app:"
    echo -e "   ${CYAN}cd $NEW_DIR && flutter run${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}\n"
fi

echo -e "${GREEN}📝 Project information saved to PROJECT_INFO.md${NC}"
echo -e "${GREEN}📚 Check SETUP_GUIDE.md for detailed instructions${NC}\n"

echo -e "${CYAN}Happy coding! 🎉${NC}\n"
