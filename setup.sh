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
        
        # Wait for project to be available in Firebase system (can take up to 2 minutes)
        echo -e "\n${YELLOW}⏳ Waiting for Firebase project to be fully available...${NC}"
        echo -e "${CYAN}(New projects can take up to 2 minutes to propagate)${NC}\n"
        
        MAX_WAIT_TIME=120  # 2 minutes
        WAIT_INTERVAL=10   # Check every 10 seconds
        ELAPSED=0
        PROJECT_FOUND=false
        
        while [ $ELAPSED -lt $MAX_WAIT_TIME ]; do
            echo -e "${YELLOW}⏱  Checking project availability... (${ELAPSED}s / ${MAX_WAIT_TIME}s)${NC}"
            
            # Check if project appears in the list
            if firebase projects:list 2>/dev/null | grep -q "$FIREBASE_PROJECT_ID"; then
                echo -e "${GREEN}✓ Project is now available!${NC}"
                PROJECT_FOUND=true
                break
            fi
            
            # Wait before next check
            sleep $WAIT_INTERVAL
            ELAPSED=$((ELAPSED + WAIT_INTERVAL))
            
            if [ $ELAPSED -lt $MAX_WAIT_TIME ]; then
                echo -e "${CYAN}   Still waiting... (Firebase is propagating the new project)${NC}"
            fi
        done
        
        if [ "$PROJECT_FOUND" = false ]; then
            echo -e "${RED}⚠️  Project not available after ${MAX_WAIT_TIME} seconds${NC}"
            echo -e "${YELLOW}The project was created but may need more time to propagate.${NC}"
            echo -e "${YELLOW}You can run ./configure_firebase.sh later to complete setup.${NC}"
            FIREBASE_CONFIGURED=false
        else
            # Extra buffer to ensure project is fully ready
            echo -e "${YELLOW}Waiting a few more seconds for project initialization...${NC}"
            sleep 5
            
            # Configure FlutterFire
            echo -e "\n${YELLOW}Configuring Firebase for your app...${NC}"
            cd "$NEW_DIR"
            
            if flutterfire configure --project="$FIREBASE_PROJECT_ID" --platforms=android,ios,web --yes --out=lib/firebase_options.dart; then
                echo -e "${GREEN}✓ Firebase configured for all platforms${NC}"
                FIREBASE_CONFIGURED=true
            else
                echo -e "${RED}⚠️  FlutterFire configuration failed.${NC}"
                echo -e "${YELLOW}The project exists but configuration timed out.${NC}"
                echo -e "${YELLOW}Run ./configure_firebase.sh to complete setup.${NC}"
                FIREBASE_CONFIGURED=false
            fi
            
            cd ..
        fi
        
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
            
            # Configure Authentication
            echo -e "\n${YELLOW}Would you like to enable Firebase Authentication?${NC}"
            echo -e "${CYAN}(This will enable Email/Password, Google, and Apple Sign-In)${NC}"
            read -p "Enable authentication providers? (y/n): " ENABLE_AUTH
            
            AUTH_CONFIGURED=false
            if [[ "$ENABLE_AUTH" =~ ^[Yy]$ ]]; then
                echo -e "\n${YELLOW}Configuring Firebase Authentication...${NC}"
                
                # Check if gcloud is authenticated
                if ! gcloud auth print-access-token &>/dev/null; then
                    echo -e "${YELLOW}⚠️  gcloud not authenticated. Attempting to authenticate...${NC}"
                    gcloud auth login --brief
                fi
                
                # Get access token for Firebase API
                ACCESS_TOKEN=$(gcloud auth print-access-token 2>/dev/null)
                
                if [ -z "$ACCESS_TOKEN" ]; then
                    echo -e "${RED}⚠️  Could not get authentication token${NC}"
                    echo -e "${YELLOW}You'll need to enable authentication manually in the console${NC}"
                else
                    # Enable Email/Password authentication
                    echo -e "${CYAN}Enabling Email/Password authentication...${NC}"
                    AUTH_RESPONSE=$(curl -s -w "\n%{http_code}" -X PATCH \
                        "https://identitytoolkit.googleapis.com/admin/v2/projects/$FIREBASE_PROJECT_ID/config?updateMask=signIn.email.enabled,signIn.email.passwordRequired" \
                        -H "Authorization: Bearer $ACCESS_TOKEN" \
                        -H "Content-Type: application/json" \
                        -d '{
                            "signIn": {
                                "email": {
                                    "enabled": true,
                                    "passwordRequired": true
                                }
                            }
                        }')
                    
                    HTTP_CODE=$(echo "$AUTH_RESPONSE" | tail -n1)
                    if [ "$HTTP_CODE" = "200" ]; then
                        echo -e "${GREEN}✓ Email/Password authentication enabled${NC}"
                        AUTH_CONFIGURED=true
                    else
                        echo -e "${YELLOW}⚠️  Could not auto-enable Email/Password (HTTP $HTTP_CODE)${NC}"
                        echo -e "${CYAN}   This may require enabling the Identity Toolkit API${NC}"
                    fi
                    
                    # Enable Anonymous authentication (useful for development)
                    echo -e "${CYAN}Enabling Anonymous authentication...${NC}"
                    ANON_RESPONSE=$(curl -s -w "\n%{http_code}" -X PATCH \
                        "https://identitytoolkit.googleapis.com/admin/v2/projects/$FIREBASE_PROJECT_ID/config?updateMask=signIn.anonymous.enabled" \
                        -H "Authorization: Bearer $ACCESS_TOKEN" \
                        -H "Content-Type: application/json" \
                        -d '{
                            "signIn": {
                                "anonymous": {
                                    "enabled": true
                                }
                            }
                        }')
                    
                    HTTP_CODE=$(echo "$ANON_RESPONSE" | tail -n1)
                    if [ "$HTTP_CODE" = "200" ]; then
                        echo -e "${GREEN}✓ Anonymous authentication enabled${NC}"
                    else
                        echo -e "${YELLOW}⚠️  Could not enable Anonymous auth${NC}"
                    fi
                    
                    # Note about Google and Apple Sign-In
                    echo -e "\n${CYAN}Additional Sign-In Methods:${NC}"
                    echo -e "${YELLOW}ℹ️  Google Sign-In:${NC}"
                    echo -e "   • Enabled by default for web"
                    echo -e "   • Android: Add SHA-1 fingerprint in Firebase Console"
                    echo -e "   • iOS: Add reversed client ID to Info.plist"
                    
                    echo -e "\n${YELLOW}ℹ️  Apple Sign-In:${NC}"
                    echo -e "   • Requires Apple Developer account"
                    echo -e "   • Must configure Service ID and domains"
                    echo -e "   • Enable in Firebase Console → Authentication → Sign-in method"
                    
                    if [ "$AUTH_CONFIGURED" = true ]; then
                        echo -e "\n${GREEN}✓ Core authentication providers configured!${NC}"
                        echo -e "${CYAN}Email/Password and Anonymous auth are ready to use${NC}"
                    else
                        echo -e "\n${YELLOW}⚠️  Authentication setup incomplete${NC}"
                        echo -e "${CYAN}Visit console to complete configuration${NC}"
                    fi
                fi
            else
                echo -e "${YELLOW}Skipping authentication setup${NC}"
            fi
            
            # Summary of what still needs manual setup
            echo -e "\n${YELLOW}📝 Manual Setup Required:${NC}"
            NEEDS_MANUAL=()
            
            if [ "$AUTH_CONFIGURED" = false ]; then
                NEEDS_MANUAL+=("${CYAN}• Authentication - Enable sign-in methods${NC}")
            fi
            
            NEEDS_MANUAL+=("${CYAN}• Firestore Database - Create database in test mode${NC}")
            NEEDS_MANUAL+=("${CYAN}• Storage - (Optional) Create storage bucket${NC}")
            
            if [ "$AUTH_CONFIGURED" = true ]; then
                NEEDS_MANUAL+=("${CYAN}• Apple Sign-In - Complete configuration with Apple Developer account${NC}")
            fi
            
            if [ ${#NEEDS_MANUAL[@]} -gt 0 ]; then
                printf '%s\n' "${NEEDS_MANUAL[@]}"
                echo -e "\n   Visit: ${CYAN}https://console.firebase.google.com/project/$FIREBASE_PROJECT_ID${NC}"
            fi
            
            if [ "$RULES_DEPLOYED" = false ]; then
                echo -e "\n   ${YELLOW}After enabling Firestore/Storage, deploy rules with:${NC}"
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
# STEP 6: Android Keystore Generation
# ============================================================================

echo -e "\n${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}         Step 6: Android Keystore Configuration${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}\n"

echo -e "${YELLOW}Would you like to generate an Android release keystore?${NC}"
echo -e "${CYAN}(Required for releasing Android apps to Google Play Store)${NC}"
read -p "Generate keystore? (y/n): " GENERATE_KEYSTORE

KEYSTORE_CREATED=false
if [[ "$GENERATE_KEYSTORE" =~ ^[Yy]$ ]]; then
    # Check if keytool is available
    if ! command -v keytool &> /dev/null; then
        echo -e "${RED}❌ keytool not found. Please install Java JDK.${NC}"
        echo -e "${YELLOW}Skipping keystore generation${NC}"
    else
        echo -e "\n${YELLOW}Setting up Android signing configuration...${NC}"
        
        # Create keystore directory
        mkdir -p "$NEW_DIR/android/keystore"
        
        # Generate secure random password
        KEYSTORE_PASSWORD=$(openssl rand -base64 24 | tr -d "=+/" | cut -c1-20)
        KEY_PASSWORD=$(openssl rand -base64 24 | tr -d "=+/" | cut -c1-20)
        
        # Get organization info for certificate
        CERT_CN="$APP_NAME"
        CERT_O="$ORG_ID"
        
        echo -e "${CYAN}Generating release keystore...${NC}"
        
        # Generate keystore
        if keytool -genkey -v \
            -keystore "$NEW_DIR/android/keystore/release.jks" \
            -keyalg RSA \
            -keysize 2048 \
            -validity 10000 \
            -alias release \
            -storepass "$KEYSTORE_PASSWORD" \
            -keypass "$KEY_PASSWORD" \
            -dname "CN=$CERT_CN, O=$CERT_O, C=US" \
            2>/dev/null; then
            
            echo -e "${GREEN}✓ Keystore generated successfully${NC}"
            
            # Create key.properties file
            cat > "$NEW_DIR/android/key.properties" <<EOF
# Android signing configuration
# ⚠️  DO NOT commit this file to version control!
storePassword=$KEYSTORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=release
storeFile=keystore/release.jks
EOF
            
            echo -e "${GREEN}✓ key.properties created${NC}"
            
            # Save credentials to a secure file
            cat > "$NEW_DIR/android/keystore/keystore_credentials.txt" <<EOF
Android Release Keystore Credentials
=====================================
App Name: $APP_NAME
Generated: $(date)

⚠️  IMPORTANT: Keep these credentials safe and secure!
⚠️  You will need these to sign app updates.
⚠️  Loss of these credentials means you cannot update your app!

Keystore Location: android/keystore/release.jks
Key Alias: release
Store Password: $KEYSTORE_PASSWORD
Key Password: $KEY_PASSWORD

Certificate Info:
CN: $CERT_CN
O: $CERT_O
C: US

Validity: 10000 days (~27 years)
Key Algorithm: RSA
Key Size: 2048 bits

To get SHA-1 and SHA-256 fingerprints (for Firebase/Google Sign-In):
keytool -list -v -keystore android/keystore/release.jks -alias release -storepass $KEYSTORE_PASSWORD

SHA-1 Fingerprint:
EOF
            
            # Get and append SHA-1 fingerprint
            SHA1=$(keytool -list -v -keystore "$NEW_DIR/android/keystore/release.jks" -alias release -storepass "$KEYSTORE_PASSWORD" 2>/dev/null | grep "SHA1:" | awk '{print $2}')
            SHA256=$(keytool -list -v -keystore "$NEW_DIR/android/keystore/release.jks" -alias release -storepass "$KEYSTORE_PASSWORD" 2>/dev/null | grep "SHA256:" | awk '{print $2}')
            
            echo "$SHA1" >> "$NEW_DIR/android/keystore/keystore_credentials.txt"
            echo "" >> "$NEW_DIR/android/keystore/keystore_credentials.txt"
            echo "SHA-256 Fingerprint:" >> "$NEW_DIR/android/keystore/keystore_credentials.txt"
            echo "$SHA256" >> "$NEW_DIR/android/keystore/keystore_credentials.txt"
            
            echo -e "${GREEN}✓ Credentials saved to android/keystore/keystore_credentials.txt${NC}"
            
            # Update build.gradle to use keystore
            GRADLE_FILE="$NEW_DIR/android/app/build.gradle"
            if [ -f "$GRADLE_FILE" ]; then
                echo -e "${CYAN}Configuring build.gradle for release signing...${NC}"
                
                # Check if key.properties loading already exists
                if ! grep -q "def keystoreProperties" "$GRADLE_FILE"; then
                    # Add keystore properties loading at the top of the file (after plugins)
                    sed -i.bak '/^plugins {/,/^}$/a\
\
def keystoreProperties = new Properties()\
def keystorePropertiesFile = rootProject.file('\''key.properties'\'')\
if (keystorePropertiesFile.exists()) {\
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))\
}
' "$GRADLE_FILE"
                fi
                
                # Add signing configs if not present
                if ! grep -q "signingConfigs {" "$GRADLE_FILE"; then
                    # Find the android { block and add signingConfigs
                    sed -i.bak '/android {/a\
    signingConfigs {\
        release {\
            if (keystorePropertiesFile.exists()) {\
                keyAlias keystoreProperties['\''keyAlias'\'']\
                keyPassword keystoreProperties['\''keyPassword'\'']\
                storeFile file(keystoreProperties['\''storeFile'\''])\
                storePassword keystoreProperties['\''storePassword'\'']\
            }\
        }\
    }
' "$GRADLE_FILE"
                fi
                
                # Update buildTypes to use signing config
                if grep -q "buildTypes {" "$GRADLE_FILE"; then
                    # Add signingConfig to release buildType
                    sed -i.bak '/release {/a\
            signingConfig signingConfigs.release
' "$GRADLE_FILE"
                fi
                
                rm -f "$GRADLE_FILE.bak"
                echo -e "${GREEN}✓ build.gradle configured for release signing${NC}"
            else
                echo -e "${YELLOW}⚠️  build.gradle not found yet (will be created by Flutter)${NC}"
            fi
            
            # Add SHA fingerprints to Firebase if project exists
            if [ -n "$FIREBASE_PROJECT_ID" ] && [ "$FIREBASE_CONFIGURED" = true ]; then
                echo -e "\n${YELLOW}Would you like to add the SHA-1 fingerprint to Firebase?${NC}"
                echo -e "${CYAN}(Required for Google Sign-In on Android)${NC}"
                echo -e "${CYAN}SHA-1: $SHA1${NC}"
                read -p "Add to Firebase? (y/n): " ADD_SHA_TO_FIREBASE
                
                if [[ "$ADD_SHA_TO_FIREBASE" =~ ^[Yy]$ ]]; then
                    echo -e "${CYAN}Adding SHA fingerprints to Firebase...${NC}"
                    echo -e "${YELLOW}Note: This requires manual addition in Firebase Console${NC}"
                    echo -e "${YELLOW}Go to: Project Settings → Your Android app → Add fingerprint${NC}"
                    echo -e "${CYAN}SHA-1: $SHA1${NC}"
                    echo -e "${CYAN}SHA-256: $SHA256${NC}"
                    
                    # Open Firebase Console in browser
                    if command -v open &> /dev/null; then
                        open "https://console.firebase.google.com/project/$FIREBASE_PROJECT_ID/settings/general"
                    elif command -v xdg-open &> /dev/null; then
                        xdg-open "https://console.firebase.google.com/project/$FIREBASE_PROJECT_ID/settings/general"
                    fi
                fi
            fi
            
            KEYSTORE_CREATED=true
            
            echo -e "\n${GREEN}✅ Android keystore setup complete!${NC}"
            echo -e "${YELLOW}⚠️  IMPORTANT:${NC}"
            echo -e "  • Credentials saved in: ${CYAN}android/keystore/keystore_credentials.txt${NC}"
            echo -e "  • ${RED}Back up this file securely!${NC}"
            echo -e "  • The keystore folder is git-ignored for security"
            echo -e "  • You'll need these credentials to release app updates"
        else
            echo -e "${RED}❌ Failed to generate keystore${NC}"
            KEYSTORE_CREATED=false
        fi
    fi
else
    echo -e "${YELLOW}Skipping keystore generation${NC}"
    echo -e "${CYAN}You can generate it later with: keytool -genkey ...${NC}"
fi

# ============================================================================
# STEP 7: Update Documentation
# ============================================================================

echo -e "\n${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}         Step 7: Generating Documentation${NC}"
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
## Android Signing
EOF

if [ "$KEYSTORE_CREATED" = true ]; then
    cat >> PROJECT_INFO.md << EOF
- **Keystore**: ✅ Generated
- **Location**: $NEW_DIR/android/keystore/release.jks
- **Credentials File**: $NEW_DIR/android/keystore/keystore_credentials.txt
- **⚠️  IMPORTANT**: Back up the keystore and credentials securely!
- **SHA-1 Fingerprint**: $SHA1
- **SHA-256 Fingerprint**: $SHA256

To add SHA fingerprints to Firebase (required for Google Sign-In):
1. Go to: https://console.firebase.google.com/project/$FIREBASE_PROJECT_ID/settings/general
2. Select your Android app
3. Click "Add fingerprint"
4. Add the SHA-1 and SHA-256 fingerprints above
EOF
else
    cat >> PROJECT_INFO.md << EOF
- **Keystore**: Not generated yet
- **To generate**: Run \`./setup.sh\` again or use keytool manually
EOF
fi

cat >> PROJECT_INFO.md << EOF

## Configuration Status
- [x] Project renamed
- [x] Bundle identifiers updated
- [x] Dependencies installed
- $FIREBASE_CONFIGURED_CHECK Firebase configured
- [ ] Firebase services enabled (Auth, Firestore, Storage)
- $RULES_DEPLOYED_CHECK Security rules deployed
EOF

if [ "$KEYSTORE_CREATED" = true ]; then
    echo "- [x] Android keystore generated" >> PROJECT_INFO.md
else
    echo "- [ ] Android keystore generated" >> PROJECT_INFO.md
fi

cat >> PROJECT_INFO.md << EOF

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
    
    if [ "$KEYSTORE_CREATED" = true ]; then
        echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
        echo -e "${BLUE}                Android Keystore Generated${NC}"
        echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
        echo -e "${GREEN}✓${NC} Keystore: ${CYAN}$NEW_DIR/android/keystore/release.jks${NC}"
        echo -e "${GREEN}✓${NC} Credentials: ${CYAN}$NEW_DIR/android/keystore/keystore_credentials.txt${NC}"
        echo -e "${GREEN}✓${NC} SHA-1: ${CYAN}$SHA1${NC}"
        echo -e "${RED}⚠️  IMPORTANT: Back up your keystore securely!${NC}"
        echo -e "\n${YELLOW}To add SHA fingerprints to Firebase (for Google Sign-In):${NC}"
        echo -e "   1. Go to Firebase Console → Settings → Your Android app"
        echo -e "   2. Click 'Add fingerprint'"
        echo -e "   3. Add SHA-1: ${CYAN}$SHA1${NC}"
        echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}\n"
    fi
    
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
