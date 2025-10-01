#!/bin/bash

# Deployment Script
# This script helps deploy the application to various platforms

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Find the app directory (support both old and new naming)
APP_DIR=""
if [ -d "vibebase_app" ]; then
    APP_DIR="vibebase_app"
else
    # Find directory ending with _app
    APP_DIR=$(find . -maxdepth 1 -type d -name "*_app" | head -1 | sed 's|^\./||')
fi

if [ -z "$APP_DIR" ]; then
    echo -e "${RED}❌ Could not find app directory (*_app)${NC}"
    echo -e "${YELLOW}Have you run ./setup.sh yet?${NC}"
    exit 1
fi

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                  🚀 Deployment Script                         ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}\n"

echo -e "${GREEN}✓ Found app directory: $APP_DIR${NC}\n"

# Function to deploy web to Firebase Hosting
deploy_web() {
    echo -e "${YELLOW}Building Flutter web app...${NC}"
    cd "$APP_DIR"
    flutter build web --release
    cd ..
    
    echo -e "${YELLOW}Deploying to Firebase Hosting...${NC}"
    firebase deploy --only hosting
    
    echo -e "${GREEN}✅ Web deployment complete!${NC}"
}

# Function to deploy Firestore rules
deploy_firestore_rules() {
    echo -e "${YELLOW}Deploying Firestore rules...${NC}"
    firebase deploy --only firestore:rules,firestore:indexes
    echo -e "${GREEN}✅ Firestore rules deployed!${NC}"
}

# Function to deploy Storage rules
deploy_storage_rules() {
    echo -e "${YELLOW}Deploying Storage rules...${NC}"
    firebase deploy --only storage:rules
    echo -e "${GREEN}✅ Storage rules deployed!${NC}"
}

# Function to build Android
build_android() {
    echo -e "${YELLOW}Building Android APK...${NC}"
    cd "$APP_DIR"
    flutter build apk --release
    echo -e "${GREEN}✅ Android APK built!${NC}"
    echo -e "Location: $APP_DIR/build/app/outputs/flutter-apk/app-release.apk"
    cd ..
}

# Function to build Android App Bundle
build_android_bundle() {
    echo -e "${YELLOW}Building Android App Bundle...${NC}"
    cd "$APP_DIR"
    flutter build appbundle --release
    echo -e "${GREEN}✅ Android App Bundle built!${NC}"
    echo -e "Location: $APP_DIR/build/app/outputs/bundle/release/app-release.aab"
    cd ..
}

# Function to build iOS
build_ios() {
    echo -e "${YELLOW}Building iOS app...${NC}"
    cd "$APP_DIR"
    flutter build ios --release
    echo -e "${GREEN}✅ iOS app built!${NC}"
    echo -e "Open $APP_DIR/ios/Runner.xcworkspace in Xcode to archive and upload"
    cd ..
}

# Main menu
echo "Select deployment option:"
echo "1) Deploy Web to Firebase Hosting"
echo "2) Deploy Firestore Rules"
echo "3) Deploy Storage Rules"
echo "4) Deploy All Firebase Resources (Web + Rules)"
echo "5) Build Android APK"
echo "6) Build Android App Bundle (for Play Store)"
echo "7) Build iOS"
echo "8) Build All Platforms"
echo "9) Exit"

read -p "Enter choice [1-9]: " choice

case $choice in
    1)
        deploy_web
        ;;
    2)
        deploy_firestore_rules
        ;;
    3)
        deploy_storage_rules
        ;;
    4)
        deploy_firestore_rules
        deploy_storage_rules
        deploy_web
        ;;
    5)
        build_android
        ;;
    6)
        build_android_bundle
        ;;
    7)
        build_ios
        ;;
    8)
        build_android
        build_android_bundle
        build_ios
        deploy_web
        ;;
    9)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid option${NC}"
        exit 1
        ;;
esac

echo -e "\n${GREEN}🎉 Done!${NC}"
