# Setup Script Auto-Accept Mode

The `setup.sh` script now supports automatic acceptance of all prompts for faster, unattended setup.

## Usage

```bash
# Interactive mode (default)
./setup.sh

# Auto-accept mode
./setup.sh -y
# or
./setup.sh --yes

# Show help
./setup.sh -h
# or
./setup.sh --help
```

## Auto-Accept Behavior

When using the `-y` or `--yes` flag, the script will:

### Default Values Used
- **App Name**: `MyApp`
- **Organization ID**: `com.example`
- **Description**: `A Flutter application built with Firebase`

### Automatic "Yes" Responses
All prompts that require confirmation will automatically answer "yes":
- ✅ Confirm project details
- ✅ Auto-create Firebase project
- ✅ Deploy security rules
- ✅ Enable authentication providers
- ✅ Generate Android keystore
- ✅ Add SHA fingerprints to Firebase

## Example: Full Automated Setup

```bash
# Run setup with all defaults and auto-confirmations
./setup.sh -y
```

This will:
1. Create an app named "MyApp" with bundle ID `com.example.myapp`
2. Rename the directory to `myapp_app/`
3. Install all dependencies
4. Create and configure a Firebase project
5. Deploy security rules
6. Enable Email/Password and Anonymous authentication
7. Generate an Android release keystore with SHA fingerprints
8. Link SHA fingerprints to Firebase

## Use Cases

### CI/CD Pipeline
```bash
#!/bin/bash
# Automated CI/CD setup
./setup.sh -y
cd myapp_app
flutter test
flutter build web --release
```

### Quick Testing
```bash
# Quickly spin up a new test project
./setup.sh -y && cd myapp_app && flutter run -d chrome
```

### Scripted Project Creation
```bash
# Create multiple projects for testing
for i in {1..3}; do
    git clone VibeBase.git TestProject$i
    cd TestProject$i
    ./setup.sh -y
    cd ..
done
```

## Interactive Mode (Default)

When running without the `-y` flag, the script will:
- Prompt for custom app name
- Prompt for organization ID
- Prompt for description
- Ask for confirmation at each step
- Allow you to skip optional features

This gives you full control over the setup process.

## Combining with Manual Configuration

Even in auto-accept mode, you can still:
- Modify the generated code after setup
- Run `./configure_firebase.sh` to connect to a different Firebase project
- Update bundle identifiers manually
- Re-generate keystores with different credentials

## Notes

- The auto-accept mode is ideal for development and testing
- For production apps, consider using interactive mode to provide proper branding
- The generated keystore in auto-accept mode still uses secure random passwords
- All auto-confirmed actions are logged with `✓ Auto-confirmed: Yes` messages

---

*Feature added: December 2024*
