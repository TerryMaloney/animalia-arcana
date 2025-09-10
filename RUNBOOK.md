# RUNBOOK

## Prerequisites
- Flutter 3.35.3 (stable channel)
- Android Studio with Android SDK
- Android emulator: Medium_Phone_API_36.0
- Git
- Windows Developer Mode ON (for symlink support)

## Daily Commands

### Start Development
```bash
# Navigate to project
cd "D:\Animal Tarot"

# Clean and get dependencies
flutter clean
flutter pub get

# Run on emulator
flutter run -d emulator-5554
```

### App Startup Flow
1. **Splash Screen**: Custom branded splash with animated logo (2 seconds)
2. **Onboarding**: First-time users see 4-page welcome flow
3. **Main App**: Home screen with daily draw, streak tracking, and navigation

### Development Tips
- **Animations**: Use centralized constants from `lib/presentation/theme/animations.dart`
- **FlipCard Widget**: Reusable 3D flip animation with controller support
- **Testing**: Run `flutter test` to verify widget animations and accessibility
- **Performance**: Animations are optimized for 60fps with proper frame budgeting

### Emulator Startup
1. Open Android Studio
2. Go to Device Manager
3. Start "Medium_Phone_API_36.0" emulator
4. Wait for emulator to fully boot

### Common Workflows

#### Hot Reload
- Press `r` in the terminal while app is running
- Press `R` for hot restart

#### Debug Build
```bash
flutter build apk --debug
# APK will be at: build/app/outputs/flutter-apk/app-debug.apk
```

#### Release Build
```bash
flutter build appbundle
# AAB will be at: build/app/outputs/bundle/release/app-release.aab
```

## Release Keystore Setup

### Generate Keystore (one-time)
```bash
keytool -genkeypair -v -keystore C:\keystores\animalia.jks -keyalg RSA -keysize 2048 -validity 10000 -alias animalia
```

### Create key.properties
Create `android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=animalia
storeFile=C:\\keystores\\animalia.jks
```

### Wire to Build
Add to `android/app/build.gradle.kts`:
```kotlin
android {
    signingConfigs {
        create("release") {
            keyAlias = "animalia"
            keyPassword = "your_key_password"
            storeFile = file("C:\\keystores\\animalia.jks")
            storePassword = "your_store_password"
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

## Troubleshooting

### Emulator Not Found
```bash
flutter devices
adb devices
```

### Gradle Issues
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Windows Symlink Warning
Enable Windows Developer Mode:
1. Open Settings → Update & Security → For developers
2. Turn on "Developer Mode"
3. Restart if prompted