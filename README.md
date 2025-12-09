# Thoughts

A minimalist, typewriter-styled note-taking app for iOS with a Liquid Glass aesthetic for capturing thoughts and organizing notebooks.

## Features

- 📝 **Quick Notes**: Capture your thoughts instantly with auto-save functionality
- 📚 **Notebooks**: Organize your thoughts into custom notebooks
- 🔍 **Search**: Find any thought quickly with full-text search
- 🎨 **Liquid Glass Design**: Beautiful translucent UI with smooth animations
- 💾 **Local Storage**: All data stored securely on-device using SwiftData
- 🔐 **User Authentication**: Create an account to keep your thoughts private

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Getting Started

### Open in Xcode

1. Open the `Thoughts/Thoughts.xcodeproj` file in Xcode
2. Select your target device (iPhone or iPad Simulator)
3. Build and run the project (⌘+R)

### Project Structure

```
Thoughts/
├── Thoughts.xcodeproj/          # Xcode project file
└── Thoughts/
    ├── ThoughtsApp.swift        # App entry point
    ├── ContentView.swift        # Main content view
    ├── Models/
    │   ├── Note.swift           # Note data model
    │   ├── Notebook.swift       # Notebook data model
    │   └── User.swift           # User data model
    ├── ViewModels/
    │   └── AppViewModel.swift   # App state management
    ├── Views/
    │   ├── OnboardingView.swift # Onboarding flow
    │   ├── AuthView.swift       # Login/Register screen
    │   ├── HomeView.swift       # Main home screen
    │   ├── NotebookDetailView.swift
    │   ├── EditorView.swift     # Note editor
    │   ├── SearchOverlay.swift  # Search functionality
    │   ├── SettingsModal.swift  # Settings screen
    │   └── NewNotebookModal.swift
    ├── Components/
    │   ├── NoteCard.swift       # Note card component
    │   ├── NotebookCard.swift   # Notebook card component
    │   ├── BottomBar.swift      # Navigation bar
    │   ├── FloatingActionButton.swift
    │   └── Color+Extensions.swift
    └── Assets.xcassets/         # App icons and colors
```

## Technologies

- **SwiftUI**: Modern declarative UI framework
- **SwiftData**: Apple's persistence framework for data storage
- **Swift Observation**: For reactive state management

## Design Philosophy

The app follows the "Liquid Glass" design philosophy:
- High blur effects with translucent backgrounds
- Subtle borders for depth and light refraction
- Spring animations for natural interactions
- Minimum 44pt touch targets for accessibility
- Paper-like background with ink-colored text

## License

This project is available for personal use.
