#!/bin/bash

# Android Signing Configuration Script
# This script configures build.gradle to use the keystore for release signing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║          Android Signing Configuration Script                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}\n"

# Find app directory
APP_DIR=""
if [ -d "vibebase_app" ]; then
    APP_DIR="vibebase_app"
else
    APP_DIR=$(find . -maxdepth 1 -type d -name "*_app" | head -1 | sed 's|^\./||')
fi

if [ -z "$APP_DIR" ]; then
    echo -e "${RED}❌ No app directory found${NC}"
    exit 1
fi

echo -e "${GREEN}Found app directory: $APP_DIR${NC}\n"

# Check if keystore exists
if [ ! -f "$APP_DIR/android/keystore/release.jks" ]; then
    echo -e "${RED}❌ Keystore not found at $APP_DIR/android/keystore/release.jks${NC}"
    echo -e "${YELLOW}Run setup.sh to generate a keystore${NC}"
    exit 1
fi

# Check if key.properties exists
if [ ! -f "$APP_DIR/android/key.properties" ]; then
    echo -e "${RED}❌ key.properties not found${NC}"
    echo -e "${YELLOW}Run setup.sh to generate keystore configuration${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Keystore found${NC}"
echo -e "${GREEN}✓ key.properties found${NC}\n"

# Configure build.gradle
GRADLE_FILE="$APP_DIR/android/app/build.gradle"

if [ ! -f "$GRADLE_FILE" ]; then
    echo -e "${RED}❌ build.gradle not found at $GRADLE_FILE${NC}"
    echo -e "${YELLOW}Run 'flutter create' or 'flutter build' first${NC}"
    exit 1
fi

echo -e "${YELLOW}Configuring build.gradle...${NC}\n"

# Backup original file
cp "$GRADLE_FILE" "$GRADLE_FILE.backup"

# Check if already configured
if grep -q "def keystoreProperties" "$GRADLE_FILE"; then
    echo -e "${YELLOW}⚠️  build.gradle already configured for signing${NC}"
    echo -e "${CYAN}No changes made${NC}"
    rm "$GRADLE_FILE.backup"
    exit 0
fi

# Add keystore properties loading after plugins block
echo -e "${CYAN}1. Adding keystore properties loading...${NC}"
sed -i.tmp '/^plugins {/,/^}$/a\
\
def keystoreProperties = new Properties()\
def keystorePropertiesFile = rootProject.file("key.properties")\
if (keystorePropertiesFile.exists()) {\
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))\
}
' "$GRADLE_FILE"
rm "$GRADLE_FILE.tmp"
echo -e "${GREEN}   ✓ Properties loading added${NC}"

# Add signing configs after android { block
echo -e "${CYAN}2. Adding signing configuration...${NC}"
sed -i.tmp '/^[[:space:]]*android[[:space:]]*{/a\
    signingConfigs {\
        release {\
            if (keystorePropertiesFile.exists()) {\
                keyAlias keystoreProperties["keyAlias"]\
                keyPassword keystoreProperties["keyPassword"]\
                storeFile file(keystoreProperties["storeFile"])\
                storePassword keystoreProperties["storePassword"]\
            }\
        }\
    }
' "$GRADLE_FILE"
rm "$GRADLE_FILE.tmp"
echo -e "${GREEN}   ✓ Signing config added${NC}"

# Add signingConfig to release buildType
echo -e "${CYAN}3. Linking signing config to release build...${NC}"

# Find the buildTypes section and add signingConfig to release
if grep -q "buildTypes {" "$GRADLE_FILE"; then
    # Use awk to find release block and add signingConfig
    awk '
    /buildTypes[[:space:]]*{/ { in_build_types=1 }
    /^[[:space:]]*release[[:space:]]*{/ { 
        in_release=1
        print
        # Check if signingConfig already exists
        getline
        if ($0 !~ /signingConfig/) {
            print "            signingConfig signingConfigs.release"
        }
        print
        next
    }
    { print }
    ' "$GRADLE_FILE" > "$GRADLE_FILE.tmp"
    mv "$GRADLE_FILE.tmp" "$GRADLE_FILE"
    echo -e "${GREEN}   ✓ Release build configured${NC}"
else
    echo -e "${YELLOW}   ⚠️  buildTypes section not found - you may need to add it manually${NC}"
fi

echo -e "\n${GREEN}✅ Android signing configuration complete!${NC}\n"

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}                     Configuration Summary${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓${NC} Keystore properties loading added"
echo -e "${GREEN}✓${NC} Signing configuration added"
echo -e "${GREEN}✓${NC} Release build type configured"
echo -e "${GREEN}✓${NC} Backup saved: ${CYAN}$GRADLE_FILE.backup${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}\n"

echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Build release APK: ${CYAN}cd $APP_DIR && flutter build apk --release${NC}"
echo -e "  2. Build App Bundle: ${CYAN}cd $APP_DIR && flutter build appbundle --release${NC}"
echo -e "  3. Your app will be signed with the release keystore\n"

echo -e "${CYAN}🎉 Ready for production builds!${NC}\n"
