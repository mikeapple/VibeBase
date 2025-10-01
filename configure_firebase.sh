#!/bin/bash

# Firebase Configuration Script
# Run this after creating your Firebase project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║              🔥 Firebase Configuration Wizard                 ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}\n"

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

echo -e "${GREEN}✓ Found app directory: $APP_DIR${NC}\n"

# Check if user is logged in to Firebase
echo -e "${YELLOW}Checking Firebase authentication...${NC}"
if ! firebase projects:list &> /dev/null; then
    echo -e "${YELLOW}Please log in to Firebase...${NC}"
    firebase login
fi

echo -e "${GREEN}✓ Authenticated with Firebase${NC}\n"

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}            Your Firebase Projects${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}\n"
firebase projects:list

echo -e "\n${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}Enter your Firebase project ID:${NC}"
echo -e "${CYAN}(You can find this in the Firebase Console URL or the list above)${NC}"
read -r FIREBASE_PROJECT_ID

if [ -z "$FIREBASE_PROJECT_ID" ]; then
    echo -e "${RED}❌ Project ID cannot be empty${NC}"
    exit 1
fi

# Validate project exists
if ! firebase projects:list | grep -q "$FIREBASE_PROJECT_ID"; then
    echo -e "${YELLOW}⚠️  Warning: Project ID '$FIREBASE_PROJECT_ID' not found in your projects list${NC}"
    read -p "Continue anyway? (y/n): " CONTINUE
    if [[ ! "$CONTINUE" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Configuration cancelled.${NC}"
        exit 0
    fi
fi

# Navigate to Flutter project
cd "$APP_DIR"

# Configure FlutterFire
echo -e "\n${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}         Configuring Firebase for All Platforms${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}\n"

echo -e "${YELLOW}Running FlutterFire configuration...${NC}"
flutterfire configure --project="$FIREBASE_PROJECT_ID" --platforms=android,ios,web --yes

echo -e "\n${GREEN}✓ firebase_options.dart generated${NC}"
echo -e "${GREEN}✓ Android configuration updated${NC}"
echo -e "${GREEN}✓ iOS configuration updated${NC}"
echo -e "${GREEN}✓ Web configuration updated${NC}"

# Update PROJECT_INFO.md if it exists
cd ..
if [ -f "PROJECT_INFO.md" ]; then
    echo -e "\n${YELLOW}Updating PROJECT_INFO.md...${NC}"
    
    # Check if Firebase section exists, if not add it
    if ! grep -q "## Firebase Configuration" PROJECT_INFO.md; then
        cat >> PROJECT_INFO.md << EOF

## Firebase Configuration
- **Project ID**: $FIREBASE_PROJECT_ID
- **Configured Date**: $(date)
- **Platforms**: Android, iOS, Web
EOF
    else
        # Update existing Firebase section
        sed -i.bak "s/- \*\*Project ID\*\*:.*/- **Project ID**: $FIREBASE_PROJECT_ID/" PROJECT_INFO.md
        rm PROJECT_INFO.md.bak
    fi
    
    # Update checklist
    sed -i.bak "s/- \[ \] Firebase configured/- [x] Firebase configured/" PROJECT_INFO.md
    rm PROJECT_INFO.md.bak
    
    echo -e "${GREEN}✓ PROJECT_INFO.md updated${NC}"
fi

echo -e "\n${GREEN}"
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║            ✅ Firebase Configuration Complete!                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}\n"

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}                    Next Steps${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}1.${NC} Go to Firebase Console: ${CYAN}https://console.firebase.google.com/project/$FIREBASE_PROJECT_ID${NC}"
echo -e "\n${YELLOW}2.${NC} Enable ${CYAN}Authentication${NC}:"
echo -e "   • Go to Authentication → Sign-in method"
echo -e "   • Enable Email/Password"
echo -e "   • (Optional) Enable Google, Apple, etc."
echo -e "\n${YELLOW}3.${NC} Create ${CYAN}Firestore Database${NC}:"
echo -e "   • Go to Firestore Database"
echo -e "   • Click 'Create database'"
echo -e "   • Choose 'Start in test mode' (for development)"
echo -e "   • Select your preferred region"
echo -e "\n${YELLOW}4.${NC} (Optional) Set up ${CYAN}Storage${NC}:"
echo -e "   • Go to Storage"
echo -e "   • Click 'Get started'"
echo -e "   • Start in test mode"
echo -e "\n${YELLOW}5.${NC} Deploy ${CYAN}Security Rules${NC}:"
echo -e "   • Run: ${CYAN}firebase deploy --only firestore:rules,storage:rules${NC}"
echo -e "\n${YELLOW}6.${NC} Test your app:"
echo -e "   • ${CYAN}cd $APP_DIR${NC}"
echo -e "   • ${CYAN}flutter run -d chrome${NC} (for web)"
echo -e "   • ${CYAN}flutter run${NC} (for mobile)"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}\n"

echo -e "${GREEN}🎉 Your app is now connected to Firebase!${NC}\n"
