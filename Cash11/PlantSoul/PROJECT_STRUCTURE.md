# PlantSoul - Plant Care iOS App

## Project Structure

### 📁 Core Files
- `PlantSoulApp.swift` - Main app entry point
- `ContentView.swift` - Root view with navigation logic
- `FontManager.swift` - Custom font management

### 🎨 Theme & Design
- `Theme/ColorScheme.swift` - Color palette and design constants

### 📱 Views
#### Main Screens
- `SplashScreenView.swift` - Animated splash screen
- `OnboardingView.swift` - User onboarding flow
- `CalendarView.swift` - Main calendar with care tasks
- `PlantsView.swift` - Plant management screen
- `InstructionsView.swift` - Care instructions library
- `FavoritesView.swift` - Favorite plants and instructions
- `ArchiveView.swift` - Archived items management
- `SettingsView.swift` - App settings and legal info

#### Secondary Screens
- `AddPlantView.swift` - Add new plant form
- `AddTaskView.swift` - Add new task form
- `TaskDetailView.swift` - Task details and plant details
- `InstructionsView.swift` - Instruction details

#### Components
- `CustomTabBar.swift` - Custom bottom navigation
- `TaskRowView.swift` - Task list item component

### 🏗️ Architecture (MVVM)
#### ViewModels
- `AppViewModel.swift` - Main app state management
- `PlantViewModel.swift` - Plant data management
- `TaskViewModel.swift` - Task data management
- `InstructionViewModel.swift` - Instruction data management

#### Models
- `Plant.swift` - Plant data model with care schedule
- `Task.swift` - Care task model with steps
- `Instruction.swift` - Care instruction model

### 🎯 Key Features Implemented

✅ **Splash Screen** - Animated loader with pulsing effects
✅ **Onboarding** - 3-screen introduction flow
✅ **Calendar View** - Interactive monthly calendar with task indicators
✅ **Plant Management** - Add, edit, archive plants with care schedules
✅ **Task System** - Create, complete, and manage care tasks
✅ **Instructions Library** - Step-by-step care guides
✅ **Favorites System** - Mark plants and instructions as favorites
✅ **Archive System** - Archive and restore items
✅ **Custom Design** - Dark theme with gradient backgrounds
✅ **Custom Fonts** - Poppins font family integration
✅ **Swipe Gestures** - Archive/favorite items with swipes
✅ **Settings** - Legal links and app rating

### 🎨 Design System
- **Colors**: Dark blue background with light blue and green accents
- **Typography**: Poppins font family with 5 weights
- **Layout**: Consistent padding, corner radius, and shadows
- **Animations**: Smooth transitions and micro-interactions

### 📋 Technical Requirements Met
- ✅ iOS 16.0+ target
- ✅ MVVM architecture
- ✅ SwiftUI framework
- ✅ Custom fonts from Resources folder
- ✅ Gradient backgrounds (not solid colors)
- ✅ Custom TabBar at bottom
- ✅ English language throughout
- ✅ StoreKit integration for app rating
- ✅ No emojis (system icons only)
- ✅ All buttons functional
- ✅ Splash screen with animated loader

### 🚀 Ready to Build
The app is fully functional and ready to be built and run on iOS devices or simulator. All screens are connected, data flows properly through the MVVM architecture, and the user experience is complete from splash screen to all main features.

