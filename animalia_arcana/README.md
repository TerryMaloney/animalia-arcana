# Animalia Arcana - Animal Tarot App

A mystical Flutter tarot app featuring animal spirits and beautiful dark theme UI.

## Features

- **Dark Theme**: Elegant dark UI with colors #0A0A0A background, #2D1B69 primary, #FFD700 accent
- **Bottom Navigation**: 4 tabs - Home, Readings, Gallery, History
- **Tarot Readings**: Multiple spread options (Single Card, Past-Present-Future, Celtic Cross)
- **Card Gallery**: Browse all 22 Major Arcana cards with animal themes
- **Reading History**: Track and review past readings

## Project Structure

```
animalia_arcana/
├── lib/
│   ├── main.dart              # Main app entry point
│   ├── screens/
│   │   ├── home_screen.dart   # Home screen with daily card
│   │   ├── readings_screen.dart # Tarot reading options
│   │   ├── gallery_screen.dart # Card gallery
│   │   └── history_screen.dart # Reading history
│   └── widgets/               # Reusable widgets
├── android/                   # Android configuration
├── assets/
│   └── images/               # Card images (to be added)
└── pubspec.yaml              # Flutter dependencies
```

## Setup Instructions

1. **Install Flutter SDK** (if not already installed):
   ```bash
   # Download Flutter from https://flutter.dev/docs/get-started/install
   # Add Flutter to your PATH
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the App**:
   ```bash
   flutter run
   ```

## Color Scheme

- **Background**: #0A0A0A (Very dark gray)
- **Primary**: #2D1B69 (Deep purple)
- **Accent**: #FFD700 (Golden yellow)

## Testing

To test navigation between tabs:
1. Launch the app
2. Tap each bottom navigation item
3. Verify each screen loads with proper content
4. Check that the dark theme is applied consistently

## Development Status

- ✅ Project structure created
- ✅ Dark theme implemented
- ✅ Bottom navigation with 4 tabs
- ✅ All screens with placeholder content
- ✅ Android configuration files
- 🔄 Ready for testing and compilation

## Next Steps

- Add actual card images to assets/images/
- Implement card reading functionality
- Add card detail screens
- Implement search and filter features
- Add reading save/load functionality 